//
//  SleepSoundCell.swift
//  Somnia
//
//  Created by Juan Felipe Torres on 5/11/20.
//

import UIKit

class SleepSoundCell: UITableViewCell {
    
    @IBOutlet weak var soundName: UILabel!
    @IBOutlet weak var soundView: UIView!
    var cellDelegate : SleepSoundCellDelegate? = nil

    
    override func awakeFromNib() {
        super.awakeFromNib()
        soundView.layer.cornerRadius = 10
    }
    
    @IBAction func soundPressed(_ sender: UIButton) {
        
        cellDelegate?.launchVC()
        
        if let meditation =  SleepActivitiesViewController.sleepSounds.first(where: { $0.name == "meditation.mp3" }),
           let guitar =  SleepActivitiesViewController.sleepSounds.first(where: { $0.name == "guitar.mp3" }),
           let background =  SleepActivitiesViewController.sleepSounds.first(where: { $0.name == "background.mp3" }),
           let art =  SleepActivitiesViewController.sleepSounds.first(where: { $0.name == "art.mp3" }) {
            
            if soundName.text == "Meditation" {
                
                meditation.audio.play()
                                
            }
            else if soundName.text == "Guitar" {
                
                guitar.audio.play()
                
            }
            else if soundName.text == "Background" {
                
                background.audio.play()
                
            }
            else if soundName.text == "Art" {
                
                art.audio.play()
                
            }
        } else {
            print("Element not found")
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}

protocol SleepSoundCellDelegate {
    func launchVC()
}
