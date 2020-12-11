//
//  RecordDreamsViewController.swift
//  Somnia
//
//  Created by Nicolas Cobos on 7/12/20.
//

import Foundation
import UIKit
import AVFoundation
import Firebase

class RecordDreamsViewController: UIViewController, AVAudioRecorderDelegate {
    
    // Outlets
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var repeatButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var minutesLabel: UILabel!
    @IBOutlet weak var secondsLabel: UILabel!
    @IBOutlet weak var dreamType: UISegmentedControl!
    @IBOutlet weak var twoMinLabel: UILabel!
    
    // Attributes
    
    var seconds = 0
    var minutes = 0
    var fileName = ""
    var timerSec: Timer!
    var timerMin: Timer!
    
    // Firebase
    
    let db = Firestore.firestore()
    let storage = Storage.storage()
    
    // Network
    
    let networkMonitor = NetworkMonitor()
    
    // Record audio
    
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        
        startButton.layer.cornerRadius = 12
        repeatButton.layer.cornerRadius = 12
        saveButton.layer.cornerRadius = 12
        
        networkMonitor.startMonitoring()
        
        secondsLabel.text = "0\(seconds)"
        minutesLabel.text = "0\(minutes)"
        
        recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                
                DispatchQueue.main.async {
                    if allowed {
                        print("Recording allowed")
                    } else {
                        print("Error recording audio")
                    }
                }
            }
        } catch {
            print("Error recording audio")
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print(paths[0])
        return paths[0]
    }
    
    func startRecording() {
        fileName = "TempRecording\(Int.random(in: 0..<100000)).m4a"
        let audioFilename = getDocumentsDirectory().appendingPathComponent(fileName)
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
            
            print("recording ...")
            
        } catch {
            finishRecording(success: false)
        }
    }
    
    func recordTapped() {
        if audioRecorder == nil {
            startRecording()
        }
    }
    
    func rerecordTapped() {
        seconds = 0
        minutes = 0
        secondsLabel.text = "00"
        minutesLabel.text = "00"
        if audioRecorder == nil {
            startRecording()
        } else {
            finishRecording2(success: true)
        }
    }
    
    func stopSaveTapped() {
        if audioRecorder != nil {
            finishRecording(success: true)
        }
    }
    
    @objc func increaseSeconds() {
        seconds += 1
        if (seconds < 10) {
            secondsLabel.text = "0\(seconds)"
            
        } else if (seconds >= 10 && seconds < 60) {
            secondsLabel.text = "\(seconds)"
        }
        else if (seconds == 60) {
            seconds = 0
            secondsLabel.text = "00"
            print("One minute")
        }
        print("Seconds: \(seconds)")
    }
    
    @objc func increaseMinutes() {
            minutes += 1
            minutesLabel.text = "0\(minutes)"
            print("Minutes: \(minutes)")
        
        if minutes == 2 {
            audioRecorder.stop()
            timerMin.invalidate()
            timerSec.invalidate()
            twoMinLabel.text = "Two minutes have passed. If you wanna save this log, press the 'Stop and save' button below."
        }
    }
    
    func persistAudio(file: String) {
        
        // Save to Firebase Storage
        
        print("success recording audio")
        let userId = Auth.auth().currentUser?.uid
        
        let localFile = getDocumentsDirectory().appendingPathComponent(file)
        let storageRef = storage.reference()
        
        // Create a reference to the file you want to upload
        let dreamLogFile = storageRef.child("dreamlog/\(userId!)/\(file)")
        
        // Upload the file to the path "images/rivers.jpg"
        _ = dreamLogFile.putFile(from: localFile, metadata: nil) { metadata, error in
            guard let metadata = metadata else {
                // Uh-oh, an error occurred!
                return
            }
            // Metadata contains file metadata such as size, content-type.
            _ = metadata.size
            // You can also access to download URL after upload.
            dreamLogFile.downloadURL { (url, error) in
                guard url != nil else {
                    // Uh-oh, an error occurred!
                    return
                }
            }
        }
        
        // Save to Firestore
        let dreamT = dreamType.titleForSegment(at: dreamType.selectedSegmentIndex)!
        if let id = Auth.auth().currentUser?.uid{
            db.collection(K.FStore.dreamLogCollection).addDocument(data: ["createdBy": id, "dateCreated": Date(), "fileName": fileName, "dreamType" : dreamT]) { (error) in
                
                if let e = error {
                    print("Error adding the user to the database, \(e.localizedDescription)")
                } else {
                    print("Successfully saved audio reference to the collection")
                }
            }
        }
    }
    
    func finishRecording(success: Bool) {
        audioRecorder.stop()
        audioRecorder = nil
        
        if success {
            persistAudio(file: fileName)
            DispatchQueue.global().asyncAfter(deadline: .now() + 5) {
                self.deleteAudioLocally()
            }
        } else {
            // recording failed :(
            print("Error recording")
        }
    }
    
    func finishRecording2(success: Bool) {
        audioRecorder.stop()
        audioRecorder = nil
        
        if success {
            print("Audio saved and deleted")
            deleteAudioLocally()
        } else {
            // recording failed :(
            print("Error recording")
        }
    }
    
    func deleteAudioLocally() {
        let fileManager = FileManager.default
        let audioPath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(fileName)
        if fileManager.fileExists(atPath: audioPath) {
            try! fileManager.removeItem(atPath: audioPath)
        }
    }
    
    @IBAction func startAction(_ sender: UIButton) {
        timerSec = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(increaseSeconds), userInfo: nil, repeats: true)
        timerMin = Timer.scheduledTimer(timeInterval: 60.0, target: self, selector: #selector(increaseMinutes), userInfo: nil, repeats: true)
        recordTapped()
    }
    
    @IBAction func saveAction(_ sender: UIButton) {
        
       
            
            stopSaveTapped()
            timerSec.invalidate()
            timerMin.invalidate()
            
            let homeViewController = storyboard?.instantiateViewController(identifier: K.tabBar) as? UITabBarController
            
            view.window?.rootViewController = homeViewController
            view.window?.makeKeyAndVisible()
        
    }
        
        
        @IBAction func repeatButton(_ sender: UIButton) {
            rerecordTapped()
            timerSec.invalidate()
            timerMin.invalidate()
            
        }
    }

