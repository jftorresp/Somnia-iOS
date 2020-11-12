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
    
    var analysis: Analysis?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadAnalysis()
        
        dailyAnalysisView.layer.cornerRadius = 12
        deepView.layer.cornerRadius = 12
        lightView.layer.cornerRadius = 12
        remView.layer.cornerRadius = 12
        awakeView.layer.cornerRadius = 12
        snoreView.layer.cornerRadius = 12
        breathView.layer.cornerRadius = 12
        
    }
    
    func loadAnalysis() {
        
        if let id = Auth.auth().currentUser?.uid {
            
            db.collection(K.FStore.analysisCollection)
                .whereField(K.FStore.createdByField, isEqualTo: id)
                .getDocuments { (querySnapshot, error) in
                                        
                    if let e = error {
                        print("There was an issue retrieving data from Firestore. \(e)")
                    } else {
                        for document in querySnapshot!.documents {
                            
                            let data = document.data()
                                                                                    
                            let deep = data["deep"] as? Double
                            let duration = data["duration"] as? Double
                            let hourStage = data["hourStage"] as? [String: String]
                            let light = data["light"] as? Double
                            let nightDate = data["nightDate"] as? Timestamp
                            let rem = data["rem"] as? Double
                            let snorePer = data["snorePercentage"] as? Double
                            let totalEvents = data["totalEvents"] as? Int
                            let totalSnores = data["totalSnores"] as? Int
                            let wake = data["wake"] as? Double
                                
                            if let date = nightDate?.dateValue() {
                                
                                self.analysis = Analysis(nightDate: date, duration: duration!, totalEvents: totalEvents!, totalSnores: totalSnores!, snorePercentage: snorePer!, wake: wake!, light: light!, deep: deep!, rem: rem!, hourStage: hourStage!)
                                
                                print("Analysis: \(self.analysis)")
                            }
                        }
                    }
                }
        }
    }
    
}
