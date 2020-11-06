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
    
    @IBOutlet weak var tableView: UITableView!
    
    
    static var sleepSounds: [SleepSound] = []
    var label = UILabel()
    @IBOutlet weak var loadingLabel: UILabel!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadSleepSounds()
        
        if SleepActivitiesViewController.sleepSounds.count != 4 {
            loadingLabel.text = "Loading your Sounds, please wait ..."
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: K.cellNibName2, bundle: nil), forCellReuseIdentifier: K.sleepSoundcell)
        
    }
    
    func loadSleepSounds() {
        
        struct Holder { static var called = false }
        
        if !Holder.called {
            Holder.called = true
            let sleepSoundsRef = storage.reference().child("sleeping_sounds")
            sleepSoundsRef.listAll { (result, error) in
                if let error = error {
                    // ...
                    print("Error loading files, \(error.localizedDescription)")
                }
                for item in result.items {
                    
                    item.getData(maxSize: 7 * 1024 * 1024) { data, error in
                        if let error = error {
                            // Uh-oh, an error occurred!
                            print("ERROR, \(error.localizedDescription)")
                        } else {
                            if let data = data {
                                do {
                                    let name = item.name
                                    let sound = try AVAudioPlayer(data: data)
                                    let newSound = SleepSound(name: name, audio: sound)
                                    print("Array of sounds in : \(SleepActivitiesViewController.sleepSounds)")
                                    SleepActivitiesViewController.sleepSounds.append(newSound)
                                    
                                    DispatchQueue.main.async {
                                        self.tableView.reloadData()
                                        let indexPath = IndexPath(row: SleepActivitiesViewController.sleepSounds.count - 1, section: 0)
                                        self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                                    }
                                    self.loadingLabel.text = ""

                                } catch {
                                    print("error")
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

extension SleepActivitiesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SleepActivitiesViewController.sleepSounds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let sound = SleepActivitiesViewController.sleepSounds[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.sleepSoundcell, for: indexPath) as! SleepSoundCell
        cell.cellDelegate = self
        let nameFull = sound.name.replacingOccurrences(of: ".mp3", with: "").capitalized
        cell.soundName.text = nameFull
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
}

extension SleepActivitiesViewController: SleepSoundCellDelegate {
    func launchVC() {
        let homeViewController = storyboard?.instantiateViewController(identifier: K.sleepTwoVC) as? SleepTwoViewController
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }
}
