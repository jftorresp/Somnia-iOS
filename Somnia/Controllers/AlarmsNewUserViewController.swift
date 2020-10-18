//
//  AlarmViewController.swift
//  Somnia
//
//  Created by Nicolas Cobos on 15/10/20.
//

import UIKit
import Firebase

class AlarmsNewUserViewController: UIViewController, NewAlarmViewControllerDelegate {
    
    //    var exactOrBefore: String?
    //    var date: Date?
    //    var repeatDic: [Int: Bool]?
    //    var desc: String?
    //
    @IBOutlet weak var AddAlarmsButton: UIButton!
    @IBOutlet weak var labelOne: UILabel!
    @IBOutlet weak var labelTwo: UILabel!
    
    var alarms: [Alarm] = []
    
    var label1: UILabel!
    var label2: UILabel!
    var label3: UILabel!
    
    var currentId: String = ""
    
    let db = Firestore.firestore()
    
    @IBAction func AddAlarmAction(_ sender: UIButton) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        print("ID: \(currentId)")
        userDocuments()
        loadAlarms()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddAlarmToAlarm" {
            let destinationVC = segue.destination as! NewAlarmViewController
            destinationVC.delegate = self
        }
    }
    
    func doSomethingWith(date: Date, description: String, repeatWhen: [String: Bool], exact: Bool, createdBy: String) {
        // Do something here after receiving data from destination view controller
        
        labelOne.text = ""
        labelTwo.text = ""
        print(date)
        print(description)
        print(repeatWhen)
        print(exact)
        print(createdBy)
    }
    
    func loadAlarms(){
        
        db.collection(K.FStore.alarmsCollection)
            .whereField("createdBy", isEqualTo: "EmlbKGMmDfOgZXbvTRHB")
            .addSnapshotListener { (querySnapshot, error) in
                
                self.alarms = []
                
                if let e = error {
                    print("There was an issue retrieving data from Firestore. \(e)")
                } else {
                    for document in querySnapshot!.documents {
                        
                        let data = document.data()
                        
                        let date = data["alarm_date"] as? Timestamp
                        let description = data["description"] as? String
                        let repeated = data["repeat"] as? [String: Bool]
                        let exact = data["exact"] as? Bool
                        let userId = data["createdBy"] as? String
                        
                        if let dateCorrect = date?.dateValue(), let descriptionCorrect = description, let repeatedCorrect = repeated, let exactCorrect = exact, let userIdCorrect = userId {
                            
                            let newAlarm = Alarm(alarm_date: dateCorrect, createdBy: userIdCorrect, description: descriptionCorrect, exact: exactCorrect, repeat_day: repeatedCorrect)
                            print("Alarms 2: \(newAlarm)")
                            self.alarms.append(newAlarm)
                        }
                        
                        // Fetch main thread and run the code inside
                        DispatchQueue.main.async {
                            
                        }
                    }
                    print("Lista alarmas 2: \(self.alarms)")
                }
            }
    }
    
    func userDocuments() {
        db.collection(K.FStore.usersCollection).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                }
            }
        }
    }
    
}



