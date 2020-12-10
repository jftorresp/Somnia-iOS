//
//  ProfileViewController.swift
//  Somnia
//
//  Created by Juan Felipe Torres on 16/10/20.
//

import UIKit
import Firebase
import AVFoundation

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var log1View: UIView!
    @IBOutlet weak var profileInfoView: UIView!
    @IBOutlet weak var profileBannerView: UIView!
    @IBOutlet weak var profileBannerImage: UIImageView!
    @IBOutlet weak var helloNicknameLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var dateDreamLogLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    
    
    // Profile Basic Info Outlets
    
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var occupationLabel: UILabel!
    
    // Scroll
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    // Firebase
    
    let db = Firestore.firestore()
    let storage = Storage.storage()
    
    var audioPlayer: AVAudioPlayer!
    
    var dreamlogs: [Dreamlog] = []
    var closerDl: Dreamlog = Dreamlog(fileName: "not", dreamType: "", createdBy: "", date: Date().addingTimeInterval(-100000000))
    
    override func viewDidLayoutSubviews() {
        self.scrollView.contentSize = self.view.frame.size
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    static var nick:String=""
    
    override func viewDidLoad() {
        progressBar.setProgress(0, animated: false)
        super.viewDidLoad()
        loadDreamlogCloser()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "E, MMM d"
        let hourString = formatter.string(from: closerDl.date)
        
        dateDreamLogLabel.text = hourString
        
        helloNicknameLabel.text = "Hello \(AlarmsNewUserViewController.user?.nickname ?? "Hello")"+"!"
        
        guard let editVC = self.storyboard?.instantiateViewController(withIdentifier: "EditInfo") as? EditInfoViewController else { return }
        editVC.callbackClosure = { [weak self] in
            self?.helloNicknameLabel.text = "Hello \(AlarmsNewUserViewController.user?.nickname ?? "Hello")"+"!"
        }
        
        log1View.layer.cornerRadius = 15
        profileInfoView.layer.cornerRadius = 15
        profileBannerView.layer.cornerRadius = 15
        profileBannerImage.layer.cornerRadius = 15
        
        // Set basic info
        
        fullNameLabel.text = AlarmsNewUserViewController.user?.fullname
        nicknameLabel.text = AlarmsNewUserViewController.user?.nickname
        ageLabel.text = String(AlarmsNewUserViewController.user?.age ?? 0)
        genderLabel.text = AlarmsNewUserViewController.user?.gender
        occupationLabel.text = AlarmsNewUserViewController.user?.occupation
    }
    
    override func viewDidAppear(_ animated: Bool) {
        helloNicknameLabel.text = "Hello \(AlarmsNewUserViewController.user?.nickname ?? "Hello")"+"!"
    }
    
    @IBAction func logOutPressed(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()
            
            if Auth.auth().currentUser == nil {
                if let loginVC = storyboard?.instantiateViewController(identifier: K.loginVC) as? LoginViewController {
                    
                    UserDefaults.standard.removeObject(forKey: "user_uid_key")
                    UserDefaults.standard.synchronize()
                    view.window?.rootViewController = loginVC
                    view.window?.makeKeyAndVisible()
                }
            }
        } catch  {
            print("Unable to log out")
            
        }
    }
    
    
    @IBAction func editAction(_ sender: UIButton) {
        guard let editVC = self.storyboard?.instantiateViewController(withIdentifier: "EditInfo") as? EditInfoViewController else { return }
        editVC.callbackClosure = { [weak self] in
            self?.helloNicknameLabel.text = "Hello \(AlarmsNewUserViewController.user?.nickname ?? "Hello")"+"!"
            
            // Set basic info
            
            self?.fullNameLabel.text = AlarmsNewUserViewController.user?.fullname
            self?.nicknameLabel.text = AlarmsNewUserViewController.user?.nickname
            self?.ageLabel.text = String(AlarmsNewUserViewController.user?.age ?? 0)
            self?.genderLabel.text = AlarmsNewUserViewController.user?.gender
            self?.occupationLabel.text = AlarmsNewUserViewController.user?.occupation
        }
        present(editVC, animated: true, completion: nil)
    }
    
    func loadDreamlogCloser() {
        
        if let id = Auth.auth().currentUser?.uid {
            db.collection(K.FStore.dreamLogCollection)
                .whereField(K.FStore.createdByField, isEqualTo: id)
                .addSnapshotListener { (querySnapshot, error) in
                    
                    self.dreamlogs = []
                    
                    if let e = error {
                        print("There was an issue retrieving data from Firestore. \(e)")
                    } else {
                        for document in querySnapshot!.documents {
                            
                            let data = document.data()
                            
                            let date = data["dateCreated"] as? Timestamp
                            let fileName = data["fileName"] as? String
                            let dreamType = data["dreamType"] as? String
                            let createdBy = data["createdBy"] as? String
                            
                            if let dateCorrect = date?.dateValue(), let fileNameCorrect = fileName, let dreamCorrect = dreamType, let createdCorrect = createdBy{
                                
                                let newDl = Dreamlog(fileName: fileNameCorrect, dreamType: dreamCorrect, createdBy: createdCorrect, date: dateCorrect)
                                self.dreamlogs.append(newDl)
                                
                            }
                            
                        }
                        self.closerDl = self.closer()
                        print("Dreamlogs: \(self.dreamlogs)")
                        print("Dreamlog closer: \(self.closerDl.fileName) : \(self.closerDl.date)")
                    }
                }
        }
    }
    
    func closer() -> Dreamlog {
        var rta = Dreamlog(fileName: "not", dreamType: "", createdBy: "", date: Date().addingTimeInterval(-100000000))
        var dates: [Date] = []
        for dl in dreamlogs {
            dates.append(dl.date)
        }
        
        dates.sort()
        dates.reverse()
        
        print("dates sorted: \(dates)")
        for dl in dreamlogs {
            if dl.date == dates.first {
                rta = dl
            }
        }
        
        return rta
    }
        
    lazy var fetchPlaySound: Void = {
        progressBar.setProgress(0, animated: false)
        let id = Auth.auth().currentUser?.uid
        let dreamlogsRef = storage.reference().child("dreamlog/\(id!)/\(closerDl.fileName)")
        
        dreamlogsRef.getData(maxSize: 7 * 1024 * 1024) { data, error in
            if let error = error {
                // Uh-oh, an error occurred!
                print("ERROR, \(error.localizedDescription)")
            } else {
                if let data = data {
                    do {
                        self.audioPlayer = try AVAudioPlayer(data: data)
                        self.audioPlayer.play()
                        
                    } catch {
                        print("error")
                    }
                }
            }
        }
    }()
    
    @IBAction func playPressed(_ sender: Any) {
        _ = fetchPlaySound
        
        if let audio = audioPlayer {
            let duration = Int(audio.duration.magnitude)
            for x in 0..<duration+1 {
                DispatchQueue.main.asyncAfter(deadline: .now() + (Double(x))) {
                    self.progressBar.setProgress(Float(x)/Float(duration), animated: true)
                }
            }
        }

        
        playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        
        if audioPlayer != nil {
            
            if audioPlayer.isPlaying == true {
                audioPlayer.stop()
                playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            } else {
                audioPlayer.play()
                
            }
        }
    }
    
}
