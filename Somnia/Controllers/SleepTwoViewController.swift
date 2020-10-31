//
//  SleepTwoViewController.swift
//  Somnia
//
//  Created by Juan Felipe Torres on 15/10/20.
//

import UIKit
import AVFoundation
import Firebase

class SleepTwoViewController: UIViewController {
    
    @IBOutlet weak var sleepActButton: UIButton!
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var hour2Label: UILabel!
    
    static var alarmSound: AVAudioPlayer!
    
    // Network
    
    let networkMonitor = NetworkMonitor()
    
    let storage = Storage.storage()
    let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    
    let alarmFiles =  ["relaxing_birds.mp3", "sound_2.mp3", "sound_3.mp3"]
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidAppear(_ animated: Bool) {
        alarmShouldSound()
        print("Esta es la closest en sleep view APPEAR: \(AlarmsNewUserViewController.closest)")
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        networkMonitor.startMonitoring()
        print("Esta es la closest en sleep two view LOAD: \(AlarmsNewUserViewController.closest)")
        
        _ = Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(alarmShouldSound), userInfo: nil, repeats: true)
        
        let storageRef = storage.reference()
        let alarmSoundsRef = storageRef.child("alarm_sounds/relaxing_birds.mp3")
        
        if NetworkMonitor.connected == true {
            downloadAlarms(reference: alarmSoundsRef)
        } else {
            print("Sound is stored in cache already")
            let dialogMessage = UIAlertController(title: "No connection", message: "There is no Internet connection, a sound from your offline data will be used for the alarm.", preferredStyle: .alert)
            
            // Create OK button with action handler
            let ok = UIAlertAction(title: "Continue", style: .default, handler: { (action) -> Void in
                print("Ok button tapped")
            })
            
            //Add OK button to a dialog message
            dialogMessage.addAction(ok)
            // Present Alert to
            self.present(dialogMessage, animated: true, completion: nil)
        }
        
        sleepActButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        sleepActButton.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        sleepActButton.layer.shadowOpacity = 1.0
        sleepActButton.layer.shadowRadius = 0.0
        sleepActButton.layer.masksToBounds = false
        sleepActButton.titleLabel?.textAlignment = .center
        sleepActButton.layer.cornerRadius = sleepActButton.frame.size.width / 12
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "a"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        
        let formatter2 = DateFormatter()
        formatter2.locale = Locale(identifier: "en_US_POSIX")
        formatter2.dateFormat = "HH:mm"
        
        let dateString = formatter.string(from: Date())
        let dateString2 = formatter2.string(from: Date())
        
        hourLabel.text = dateString2
        hour2Label.text = dateString
        
        // Do any additional setup after loading the view.
    }
    
    func getAlarmSoundCache() {
        
    }
    
    func downloadAlarms(reference: StorageReference){
        
        let localURL = URL(string: "\(documentsURL.absoluteString)alarm_sounds/relaxing_birds.mp3")!
        print("La URL ES: \(localURL)")
        _ = reference.write(toFile: localURL as URL) { url, error in
            if let error = error {
                // Uh-oh, an error occurred!
                print("Error saving file, \(error)")
            } else {
                // Local file URL for "images/island.jpg" is returned
                print("Success!, \(localURL)")
            }
        }
    }
    
    @objc func alarmShouldSound() {
        let date = Date()

        if date.timeIntervalSince1970.rounded() == AlarmsNewUserViewController.closest.alarm_date.timeIntervalSince1970.rounded() {
//            let path = "\(documentsURL.absoluteString )alarm_sounds/relaxing_birds.mp3"
            let path = Bundle.main.path(forResource: "relaxing_birds.mp3", ofType: nil)!
            let url = URL(fileURLWithPath: path)

            do {
                SleepTwoViewController.alarmSound = try AVAudioPlayer(contentsOf: url)
                SleepTwoViewController.alarmSound.play()
                SleepTwoViewController.alarmSound.numberOfLoops = -1
                
                let alarmTriggeredVC = storyboard?.instantiateViewController(identifier: K.alarmTriggered) as? AlarmTriggeredViewController
                
                view.window?.rootViewController = alarmTriggeredVC
                view.window?.makeKeyAndVisible()
            } catch {
                print("couldn't load file :(")
            }
        }
    }
    
    @IBAction func sleepActPressed(_ sender: Any) {
        
    }
        
}
