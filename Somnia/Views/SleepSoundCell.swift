//
//  SleepSoundCell.swift
//  Somnia
//
//  Created by Juan Felipe Torres on 5/11/20.
//

import UIKit
import Firebase
import AVFoundation

class SleepSoundCell: UITableViewCell {
    
    @IBOutlet weak var soundName: UILabel!
    @IBOutlet weak var soundDuration: UILabel!
    @IBOutlet weak var soundDescription: UILabel!
    @IBOutlet weak var soundView: UIView!
    var cellDelegate : SleepSoundCellDelegate? = nil

    var storage = Storage.storage()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        soundView.layer.cornerRadius = 10
    }
    
    @IBAction func soundPressed(_ sender: UIButton) {
        
        cellDelegate?.launchVC()
        
        if let meditation =  SleepActivitiesViewController.sleepSounds.first(where: { $0.fileName == "meditation.mp3" }),
           let guitar =  SleepActivitiesViewController.sleepSounds.first(where: { $0.fileName == "guitar.mp3" }),
           let background =  SleepActivitiesViewController.sleepSounds.first(where: { $0.fileName == "background.mp3" }),
           let art =  SleepActivitiesViewController.sleepSounds.first(where: { $0.fileName == "art.mp3" }) {
            
            if soundName.text == "Meditation" {
                
                fetchPlaySound(fileName: meditation.fileName)
                                
            }
            else if soundName.text == "Guitar" {
                
                fetchPlaySound(fileName: guitar.fileName)
            }
            else if soundName.text == "Background" {
                
                fetchPlaySound(fileName: background.fileName)

            }
            else if soundName.text == "Art" {
                
                fetchPlaySound(fileName: art.fileName)

            }
        } else {
            print("Element not found")
        }
    }
    
    func fetchPlaySound(fileName: String) {
        let sleepSoundsRef = storage.reference().child("sleeping_sounds/\(fileName)")
        
        sleepSoundsRef.getData(maxSize: 7 * 1024 * 1024) { data, error in
            if let error = error {
                // Uh-oh, an error occurred!
                print("ERROR, \(error.localizedDescription)")
            } else {
                if let data = data {
                    do {
                        let sound = try AVAudioPlayer(data: data)
                        SleepActivitiesViewController.sleepSounds.first(where: { $0.fileName == fileName })?.audio = sound
                        
                        sound.play()
                        
                    } catch {
                        print("error")
                    }
                }
            }
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}

protocol SleepSoundCellDelegate {
    func launchVC()
}
