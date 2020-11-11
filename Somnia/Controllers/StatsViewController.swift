//
//  StatsViewController.swift
//  Somnia
//
//  Created by Juan Felipe Torres on 15/10/20.
//

import UIKit
import Charts
import Firebase

class StatsViewController: UIViewController {
    
    // Sleep Stats Outlets
    
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var dailyAnalysisView: UIView!
    @IBOutlet weak var noAnalysisLabel: UILabel!
    @IBOutlet weak var deepHrsLabel: UILabel!
    @IBOutlet weak var lightHrsLabel: UILabel!
    @IBOutlet weak var remHrsLabel: UILabel!
    @IBOutlet weak var timeHrsLabel: UILabel!
    @IBOutlet weak var snorePerLabel: UILabel!
    @IBOutlet weak var totalBreathLabel: UILabel!
    
    @IBOutlet weak var deepView: UIView!
    @IBOutlet weak var lightView: UIView!
    @IBOutlet weak var remView: UIView!
    @IBOutlet weak var awakeView: UIView!
    @IBOutlet weak var snoreView: UIView!
    @IBOutlet weak var breathView: UIView!
    
    // Firebase
    
    let db = Firestore.firestore()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print("Analysis: \(SleepTwoViewController.analysis)")
        
        dailyAnalysisView.layer.cornerRadius = 12
        deepView.layer.cornerRadius = 12
        lightView.layer.cornerRadius = 12
        remView.layer.cornerRadius = 12
        awakeView.layer.cornerRadius = 12
        snoreView.layer.cornerRadius = 12
        breathView.layer.cornerRadius = 12

    }
    
    func loadAnalysis() {
        
        db.collection(K.FStore.analysisCollection)
            .getDocuments { (querySnapshot, error) in
                
                SleepActivitiesViewController.sleepStories = []
                
                if let e = error {
                    print("There was an issue retrieving data from Firestore. \(e)")
                } else {
                    for document in querySnapshot!.documents {
                        
                        let data = document.data()
                        
                        let createdBy = data["createdBy"] as? String
                        let deep = data["deep"] as? Int
                        let duration = data["duration"] as? Double
                        let hourStage = data["hourStage"] as? Int
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
