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
    @IBOutlet weak var stackViewAlarms: UIStackView!
    @IBOutlet weak var expectedHourLabel: UILabel!
    @IBOutlet weak var amExpectedLabel: UILabel!
    @IBOutlet weak var bedtimeHourLabel: UILabel!
    @IBOutlet weak var amBedtimeLabel: UILabel!
    @IBOutlet weak var tomorrowLabel: UILabel!
    @IBOutlet weak var expectedView: UIView!
    @IBOutlet weak var bedtimeView: UIView!
    
    
    var alarms: [Alarm] = []
    
    static var closest : Alarm = Alarm(alarm_date: Date(), createdBy: "", description: "", exact: false, repeat_day: [:])
    
    var otherAlarms = UILabel()
    var editButton = UIButton()
    var horizontalStack = UIStackView()
    var verticalStack = UIStackView()
    var bigVertical = UIStackView()
    var alarmV = AlarmElement()
    
   
    static var currentIdGlobal: String = ""
    
    let db = Firestore.firestore()
    
    @IBAction func AddAlarmAction(_ sender: UIButton) {
        
        
    }
        
    override func viewDidAppear(_ animated: Bool) {
        
        if(AlarmsNewUserViewController.closest.description == "not") {
            stackViewAlarms.isHidden = true
            tomorrowLabel.isHidden = true
            print("entre true appear")
        } else {
            stackViewAlarms.isHidden = false
            tomorrowLabel.isHidden = false
            print("entre false appear")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        loadAlarms()
        
        bedtimeView.layer.cornerRadius = 10
        expectedView.layer.cornerRadius = 10
        
        alarmV.hourLabel?.text = "Hola"
        alarmV.timeLabel?.text = "Como vas"
        alarmV.onOffSwitch?.isOn = true
        alarmV.descRepeatLabel?.text = "Chao"
        alarmV.translatesAutoresizingMaskIntoConstraints = false
                
        if(AlarmsNewUserViewController.closest.description == "not") {
            stackViewAlarms.isHidden = true
            tomorrowLabel.isHidden = true

            print("entre true load")
        } else {
            stackViewAlarms.isHidden = false
            tomorrowLabel.isHidden = false
            labelOne.text = "Other Alarms"
            labelOne.textAlignment = .left
            labelOne.font = UIFont(name: "HaboroSoft-NorMed",size: 24.0)

            print("entre false load")
        }
    
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
        
        print(date)
        print(description)
        print(repeatWhen)
        print(exact)
        print(createdBy)
    }
    
    func loadAlarms(){
        
        if let id = Auth.auth().currentUser?.uid {
            db.collection(K.FStore.alarmsCollection)
                .whereField("createdBy", isEqualTo: id)
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
                            
                        }
                        print("Lista alarmas 2: \(self.alarms)")
                        AlarmsNewUserViewController.closest = self.closer()
                        print("Este es closest en load: \(AlarmsNewUserViewController.closest)")
                    }
                }
        }
        
        
    }
        
    func addConstraints() {
        var constraints = [NSLayoutConstraint]()
        
        // Add constraints
        constraints.append(alarmV.widthAnchor.constraint(equalTo: view.widthAnchor))
        constraints.append(alarmV.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5))
        
        // Activate
        NSLayoutConstraint.activate(constraints)
    }
    
    func closer() -> Alarm {
        print("este es el length del arreglo de alarmas: \(alarms.count)")
        var menor = Double.infinity
        var rta = Alarm(alarm_date: Date(), createdBy: "", description: "not", exact: false, repeat_day: [:])
        for alarm in alarms{
            if(menor > alarm.alarm_date.timeIntervalSinceNow || alarm.alarm_date.timeIntervalSinceNow > 0  ){
                menor = alarm.alarm_date.timeIntervalSinceNow
                print("Encontré el menor")
                rta = alarm
            }
        }
        print("rta de closer: \(rta)")
        return rta
    }
    
}



