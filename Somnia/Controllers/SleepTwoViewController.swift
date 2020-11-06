//
//  SleepTwoViewController.swift
//  Somnia
//
//  Created by Juan Felipe Torres on 15/10/20.
//

import UIKit
import AVFoundation
import Firebase
import Foundation

class SleepTwoViewController: UIViewController {
    
    @IBOutlet weak var sleepActButton: UIButton!
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var hour2Label: UILabel!
    @IBOutlet weak var soundName: UILabel!
    @IBOutlet weak var playButon: UIButton!
    @IBOutlet weak var playMusicSV: UIStackView!
    @IBOutlet weak var soundImage: UIImageView!
    @IBOutlet weak var soundView: UIView!
    
    static var alarmSound: AVAudioPlayer!
    
    var recordingSession: AVAudioSession!
    var recorder: AVAudioRecorder!
    var timer: Timer?
    var hourTimer: Timer?
    
    // Sleep analysis events
    
    var totalEvents: Int = 0
    var eventsPerHour: Int = 0
    var totalSnores: Int = 0
    var snoresPerHour: Int = 0
    var timeStart: Date?
    var timeFinish: Date?
    var hourCounter: Int = 0
    var totalWake: Double = 0.0
    var totalREM: Double = 0.0
    var totalLight: Double = 0.0
    var totalDeep: Double = 0.0
    var hourStage: [String: String] = [:]
    var hourSnores: [String: Int] = [:]
    var hourEvents: [String: Int] = [:]
    var analysis: Analysis?
    
    var isTime = false
    
    // Network
    
    let networkMonitor = NetworkMonitor()
    
    let storage = Storage.storage()
    let db = Firestore.firestore()
    let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    
    let alarmFiles =  ["relaxing_birds.mp3", "sound_2.mp3", "sound_3.mp3"]
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidAppear(_ animated: Bool) {
                
        print("Esta es la closest en sleep view APPEAR: \(AlarmsNewUserViewController.closest)")
        
        if let meditation =  SleepActivitiesViewController.sleepSounds.first(where: { $0.name == "meditation.mp3" }),
           let guitar =  SleepActivitiesViewController.sleepSounds.first(where: { $0.name == "guitar.mp3" }),
           let background =  SleepActivitiesViewController.sleepSounds.first(where: { $0.name == "background.mp3" }),
           let art =  SleepActivitiesViewController.sleepSounds.first(where: { $0.name == "art.mp3" }) {
            
            if meditation.audio.isPlaying == true {
                
                playMusicSV.isHidden = false
                let nameFull = meditation.name.replacingOccurrences(of: ".mp3", with: "").capitalized
                soundName.text = nameFull
                                
            }
            else if guitar.audio.isPlaying == true {
                
                playMusicSV.isHidden = false
                let nameFull = guitar.name.replacingOccurrences(of: ".mp3", with: "").capitalized
                soundName.text = nameFull
                
            }
            else if background.audio.isPlaying == true {
                
                playMusicSV.isHidden = false
                let nameFull = background.name.replacingOccurrences(of: ".mp3", with: "").capitalized
                soundName.text = nameFull
            }
            else if art.audio.isPlaying == true {
                
                playMusicSV.isHidden = false
                let nameFull = art.name.replacingOccurrences(of: ".mp3", with: "").capitalized
                soundName.text = nameFull
                
            }
        } else {
            print("Element not found")
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playMusicSV.isHidden = true
        
        soundName.layer.cornerRadius = 12
        soundView.layer.cornerRadius = 12
        soundImage.layer.cornerRadius = 12
        playMusicSV.layer.cornerRadius = 12
        
        recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        print("permission allowed")
                    } else {
                        print("permission denied")
                    }
                }
            }
        } catch {
            print("permission denied")
        }
        
        startRecording()
        
        networkMonitor.startMonitoring()
        
        _ = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(alarmShouldSound), userInfo: nil, repeats: true)
        
//        if SleepTwoViewController.alarmSound.isPlaying == true {
//            persistAnalysis()
//        }
                
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
        
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func startRecording() {
        
        let url = getDocumentsDirectory().appendingPathComponent("analysis.m4a")

        // 4
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        do {
            // 5
            recorder = try AVAudioRecorder(url: url, settings: settings)
            recorder.delegate = self
            recorder.isMeteringEnabled = true
            recorder.record()
            print("recording")
            timeStart = Date()
            recorder.updateMeters()
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(getDecibels), userInfo: nil, repeats: true)
            hourTimer = Timer.scheduledTimer(timeInterval: 3600.0, target: self, selector: #selector(checkSleepState), userInfo: nil, repeats: true)

        } catch {
            finishRecording(success: false)
        }
    }
    
    func finishRecording(success: Bool) {
        recorder.stop()

        if success {
            print("succesfully recorded data")
            timer?.invalidate()
            hourTimer?.invalidate()
            timeFinish = Date()
        } else {
            print("There was a problem recording")
        }
    }
    
    @objc func getDecibels() -> Float {
        if let recorder = recorder {
            recorder.updateMeters()
            let decibels = recorder.averagePower(forChannel: 0)
            
            print("decibels: \(decibels) dB")
            if decibels > -100 {
                // Breathing event
                totalEvents += 1
                eventsPerHour += 1
                if decibels > -75 && decibels < -30 {
                    // Snore event
                    totalSnores += 1
                    snoresPerHour += 1
                }
            }
        }
        return 0
    }
    
    @objc func checkSleepState() {
        hourCounter += 1
        var stage = "WAKE"
        
        if snoresPerHour > 250 {
            totalWake += 1
        } else if snoresPerHour > 165 {
            stage = "REM"
            totalREM += 1
        } else if snoresPerHour > 130 {
            stage = "DEEP"
            totalDeep += 1
        } else if snoresPerHour > 80 {
            stage = "LIGHT"
            totalLight += 1
        } else {
            totalWake += 1
        }
        
        hourStage[String(hourCounter)] = stage
        hourEvents[String(hourCounter)] = eventsPerHour
        hourSnores[String(hourCounter)] = snoresPerHour
        snoresPerHour = 0
        eventsPerHour = 0
    }
    
    func downloadAlarms(reference: StorageReference) {
        
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
    
    func persistAnalysis() {
        
        let path = Bundle.main.path(forResource: "relaxing_birds.mp3", ofType: nil)!
        let url = URL(fileURLWithPath: path)
        print("Alarm should sound now!")
        
        do {
            SleepTwoViewController.alarmSound = try AVAudioPlayer(contentsOf: url)
            SleepTwoViewController.alarmSound.play()
            SleepTwoViewController.alarmSound.numberOfLoops = -1
            
            finishRecording(success: true)
            timeFinish = Date()
            let durationSec = timeFinish?.timeIntervalSince(timeStart!) ?? 0
            let durationHours = durationSec / 3600
            let percentage = (Double(totalSnores)/Double(totalEvents))
            
            analysis = Analysis(nightDate: timeStart!, duration: durationHours, totalEvents: totalEvents, totalSnores: totalSnores, snorePercentage: percentage, wake: totalWake, light: totalLight, deep: totalDeep, rem: totalREM, hourStage: hourStage)
            
            if let id = Auth.auth().currentUser?.uid {
                db.collection(K.FStore.analysisCollection).addDocument(data: ["createdBy": id, "deep": totalDeep, "duration": durationHours, "hourStage": hourStage, "light": totalLight, "nightDate": timeStart!, "rem": totalREM, "snorePercentage": percentage, "totalEvents": totalEvents, "totalSnores": totalSnores, "wake": totalWake, "score": 0, "mood": ""]) { (error) in
                    
                    if let e = error {
                        print("Error adding the score to the user analysis, \(e.localizedDescription)")
                    } else {
                        print("Successfully saved analysis data!!!")
                    }
                }
            }

            print("Sleep Analysis:")
            print("hourcounter: \(hourCounter)")
            print("hourStage: \(hourStage)")
                            
            let alarmTriggeredVC = storyboard?.instantiateViewController(identifier: K.alarmTriggered) as? AlarmTriggeredViewController
            
            view.window?.rootViewController = alarmTriggeredVC
            view.window?.makeKeyAndVisible()
        } catch {
            print("couldn't load file :(")
        }
        

    }
    
    @objc func alarmShouldSound() -> Bool {
        let date = Date()

        if date.timeIntervalSince1970.rounded() == AlarmsNewUserViewController.closest.alarm_date.timeIntervalSince1970.rounded() && isTime == false{
            checkSleepState()
            isTime = true
            persistAnalysis()
        }
        print("isTime: \(isTime)")
        return isTime
    }
    
    @IBAction func sleepActPressed(_ sender: Any) {
        
    }
    
    @IBAction func reproducePressed(_ sender: UIButton) {
        
        
        if let meditation =  SleepActivitiesViewController.sleepSounds.first(where: { $0.name == "meditation.mp3" }),
           let guitar =  SleepActivitiesViewController.sleepSounds.first(where: { $0.name == "guitar.mp3" }),
           let background =  SleepActivitiesViewController.sleepSounds.first(where: { $0.name == "background.mp3" }),
           let art =  SleepActivitiesViewController.sleepSounds.first(where: { $0.name == "art.mp3" }) {
            
            if soundName.text == "Meditation" {
                if meditation.audio.isPlaying == true {
                    meditation.audio.stop()
                    playButon.setImage(UIImage(systemName: "play.fill"), for: .normal)
                } else {
                    meditation.audio.play()
                    
                    guitar.audio.stop()
                    background.audio.stop()
                    art.audio.stop()
                    playButon.setImage(UIImage(systemName: "pause.fill"), for: .normal)
                }
            } else if soundName.text == "Guitar" {
                if guitar.audio.isPlaying == true {
                    guitar.audio.stop()
                    playButon.setImage(UIImage(systemName: "play.fill"), for: .normal)
                } else {
                    guitar.audio.play()
                    
                    meditation.audio.stop()
                    background.audio.stop()
                    art.audio.stop()
                    playButon.setImage(UIImage(systemName: "pause.fill"), for: .normal)
                }
            } else if soundName.text == "Background" {
                if background.audio.isPlaying == true {
                    background.audio.stop()
                    playButon.setImage(UIImage(systemName: "play.fill"), for: .normal)
                } else {
                    background.audio.play()
                    
                    meditation.audio.stop()
                    guitar.audio.stop()
                    art.audio.stop()
                    playButon.setImage(UIImage(systemName: "pause.fill"), for: .normal)
                }
            } else if soundName.text == "Art" {
                if art.audio.isPlaying == true  {
                    art.audio.stop()
                    playButon.setImage(UIImage(systemName: "play.fill"), for: .normal)
                } else {
                    art.audio.play()
                    
                    meditation.audio.stop()
                    guitar.audio.stop()
                    background.audio.stop()
                    playButon.setImage(UIImage(systemName: "pause.fill"), for: .normal)
                }
            }
        }
    }
}

extension SleepTwoViewController: AVAudioRecorderDelegate {
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
    }
}
