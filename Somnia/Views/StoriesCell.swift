//
//  StoriesCell.swift
//  Somnia
//
//  Created by Juan Felipe Torres on 6/11/20.
//

import UIKit
import Firebase
import AVFoundation

class StoriesCell: UITableViewCell {
    
    @IBOutlet weak var storyName: UILabel!
    @IBOutlet weak var storyDescription: UILabel!
    @IBOutlet weak var storyDuration: UILabel!
    @IBOutlet weak var storyView: UIView!
    @IBOutlet var storyImage: UIImageView!
    var cellDelegate : SleepStoryCellDelegate? = nil
    
    var storage = Storage.storage()

    override func awakeFromNib() {
        super.awakeFromNib()
        storyView.layer.cornerRadius = 10
    }
    
    func fetchPlaySound(fileName: String) {
        let sleepStoriesRef = storage.reference().child("sleeping_stories/\(fileName)")
        
        sleepStoriesRef.getData(maxSize: 40 * 1024 * 1024) { data, error in
            if let error = error {
                // Uh-oh, an error occurred!
                print("ERROR, \(error.localizedDescription)")
            } else {
                print("Descargando ...")
                if let data = data {
                    do {
                        let sound = try AVAudioPlayer(data: data)
                        SleepActivitiesViewController.sleepStories.first(where: { $0.fileName == fileName })?.audio = sound
                        
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

        // Configure the view for the selected state
    }
    
    @IBAction func storyPressed(_ sender: UIButton) {
        
        cellDelegate?.launchVC()
        
        if let blueGold =  SleepActivitiesViewController.sleepStories.first(where: { $0.fileName == "blue_gold.mp3" }) {
            
            if storyName.text == "Blue Gold" {
                
                DispatchQueue.global(qos: .background).async {
                    self.fetchPlaySound(fileName: blueGold.fileName)
                }
            }

        } else {
        }
    }
}

protocol SleepStoryCellDelegate {
    func launchVC()
}
