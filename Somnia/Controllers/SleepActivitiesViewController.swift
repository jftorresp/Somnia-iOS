//
//  SleepActivitiesViewController.swift
//  Somnia
//
//  Created by Juan Felipe Torres on 15/10/20.
//

import UIKit
import AVFoundation
import Firebase

class SleepActivitiesViewController: UIViewController {
    
    let storage = Storage.storage()
    let db = Firestore.firestore()
    
    // Network
    
    let networkMonitor = NetworkMonitor()
    
    @IBOutlet weak var soundsTableView: UITableView!
    @IBOutlet weak var storiesTableView: UITableView!
    @IBOutlet weak var yourSoundsLabel: UILabel!
    @IBOutlet weak var bedtimeLoadLabel: UILabel!
    
    static var sleepSounds: [SleepSound] = []
    static var sleepStories: [Stories] = []
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.global(qos: .background).async {
            self.loadSleepStories()
        }
        
        DispatchQueue.main.async {
            self.loadSleepSounds()
        }
        
        soundsTableView.register(UINib(nibName: K.cellNibName2, bundle: nil), forCellReuseIdentifier: K.sleepSoundcell)
        storiesTableView.register(UINib(nibName: K.cellNibName3, bundle: nil), forCellReuseIdentifier: K.storiesCell)
        soundsTableView.delegate = self
        soundsTableView.dataSource = self
        storiesTableView.delegate = self
        storiesTableView.dataSource = self
        
        networkMonitor.startMonitoring()
        
        if NetworkMonitor.connected == false {
            soundsTableView.isHidden = true
            storiesTableView.isHidden = true
            yourSoundsLabel.isHidden = true
            bedtimeLoadLabel.font = UIFont(name: "HaboroSoft-NorLig",size: 18.0)
            bedtimeLoadLabel.text = "You don´t have internet connection. Come back later when you regain connectivity."
            bedtimeLoadLabel.textAlignment = .center
        }
    }
    
    func loadSleepSounds() {
        
        db.collection(K.FStore.soundsCollection)
            .getDocuments { (querySnapshot, error) in
                
                SleepActivitiesViewController.sleepSounds = []
                
                if let e = error {
                    print("There was an issue retrieving data from Firestore. \(e)")
                } else {
                    for document in querySnapshot!.documents {
                        
                        let data = document.data()
                        
                        let name = data["name"] as? String
                        let fileName = data["fileName"] as? String
                        let description = data["description"] as? String
                        let duration = data["durationInSeconds"] as? Int
                        let image = data["image"] as? String
                        
                        if let nameR = name, let fileN = fileName, let descrip = description, let dur = duration, let img = image {
                            
                            let newSound = SleepSound(n: nameR, f: fileN, img: img, d: descrip, dur: dur, a: nil)
                            
                            SleepActivitiesViewController.sleepSounds.append(newSound)
                            
                            DispatchQueue.main.async {
                                self.soundsTableView.reloadData()
                                let indexPath = IndexPath(row: SleepActivitiesViewController.sleepSounds.count - 1, section: 0)
                                self.soundsTableView.scrollToRow(at: indexPath, at: .top, animated: true)
                            }
                        }
                    }
                }
            }
    }
    
    func loadSleepStories() {
        
        db.collection(K.FStore.storiesCollection)
            .getDocuments { (querySnapshot, error) in
                
                SleepActivitiesViewController.sleepStories = []
                
                if let e = error {
                    print("There was an issue retrieving data from Firestore. \(e)")
                } else {
                    for document in querySnapshot!.documents {
                        
                        let data = document.data()
                        
                        let name = data["name"] as? String
                        let fileName = data["filename"] as? String
                        let description = data["description"] as? String
                        let duration = data["durationInSeconds"] as? Int
                        let image = data["image"] as? String
                        
                        if let nameR = name, let fileN = fileName, let descrip = description, let dur = duration, let img = image {
                            
                            let newStory = Stories(n: nameR, f: fileN, img: img, d: descrip, dur: dur, a: nil)
                            
                            SleepActivitiesViewController.sleepStories.append(newStory)
                            
                            DispatchQueue.main.async {
                                self.storiesTableView.reloadData()
                                let indexPath = IndexPath(row: SleepActivitiesViewController.sleepStories.count - 1, section: 0)
                                self.storiesTableView.scrollToRow(at: indexPath, at: .top, animated: true)
                            }
                        }
                    }
                }
            }
    }
}

extension SleepActivitiesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tableView == soundsTableView ? SleepActivitiesViewController.sleepSounds.count : SleepActivitiesViewController.sleepStories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == soundsTableView {
            let sound = SleepActivitiesViewController.sleepSounds[indexPath.row]
            
            let cell = tableView.dequeueReusableCell(withIdentifier: K.sleepSoundcell, for: indexPath) as! SleepSoundCell
            cell.cellDelegate = self
            let nameFull = sound.name
            cell.soundName.text = nameFull
            let durationMin = sound.duration / 60
            cell.soundDuration.text = "\(durationMin) mins."
            cell.soundDescription.text = sound.description
            return cell
        }
        
        else if tableView == storiesTableView {
            let story = SleepActivitiesViewController.sleepStories[indexPath.row]
            
            let cell = tableView.dequeueReusableCell(withIdentifier: K.storiesCell, for: indexPath) as! StoriesCell
            
            cell.cellDelegate = self
            let nameFull = story.name
            cell.storyName.text = nameFull
            let durationMin = story.duration / 60
            cell.storyDuration.text = "\(durationMin) mins."
            cell.storyDescription.text = story.description
            //                let imageUrl = URL(fileURLWithPath: story.image)
            //                do {
            //                    let imageData = try Data(contentsOf: imageUrl)
            //                    cell.storyImage = UIImageView(image: UIImage(data: imageData))
            //                } catch {
            //                    print("error")
            //                }
            return cell
        }
        
        return UITableViewCell()
    }
    
}

extension SleepActivitiesViewController: SleepSoundCellDelegate {
    func launchVC() {
        let homeViewController = storyboard?.instantiateViewController(identifier: K.sleepTwoVC) as? SleepTwoViewController
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }
}

extension SleepActivitiesViewController: SleepStoryCellDelegate {
    func launchVC2() {
        let homeViewController = storyboard?.instantiateViewController(identifier: K.sleepTwoVC) as? SleepTwoViewController
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }
}


