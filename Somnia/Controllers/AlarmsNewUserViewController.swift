//
//  AlarmViewController.swift
//  Somnia
//
//  Created by Nicolas Cobos on 15/10/20.
//

import UIKit
import Firebase

class AlarmsNewUserViewController: UIViewController {
    
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
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editButLabel: UIButton!
    
    static var user: User?
    
    var alarms: [Alarm] = []
    let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .allDomainsMask).first
    
    static var closest : Alarm = Alarm(alarm_date: Date().addingTimeInterval(-10000000000000), createdBy: "", description: "not", exact: false, repeat_day: [:])
           
    static var currentIdGlobal: String = ""
    
    let db = Firestore.firestore()
    
    @IBAction func AddAlarmAction(_ sender: UIButton) {
        
        
    }
        
    override func viewDidAppear(_ animated: Bool) {
                
        let formatter = DateFormatter()
        let formatter2 = DateFormatter()
        formatter.dateFormat = "HH:mm" // "a" prints "pm" or "am"
        formatter2.dateFormat = "a"
        
        formatter2.amSymbol = "AM"
        formatter2.pmSymbol = "PM"
        let hourString = formatter.string(from:AlarmsNewUserViewController.closest.alarm_date)
        let amString = formatter2.string(from: AlarmsNewUserViewController.closest.alarm_date)
        
        var dateComponent = DateComponents()
        dateComponent.hour = -8
        let newDate2 = Calendar.current.date(byAdding: dateComponent, to: AlarmsNewUserViewController.closest.alarm_date)
        
        let hourString2 = formatter.string(from: newDate2!)
        let amString2 = formatter2.string(from: newDate2!)
        
        if(AlarmsNewUserViewController.closest.description == "not" && alarms.count == 0) {
            stackViewAlarms.isHidden = true
            tomorrowLabel.isHidden = true
            editButLabel.isHidden = true
            labelOne.text = "You don't have any alarms yet. Press the + button to create a new one."
        } else {
            stackViewAlarms.isHidden = false
            tomorrowLabel.isHidden = false
            editButLabel.isHidden = false
            bedtimeView.layer.cornerRadius = 10
            expectedView.layer.cornerRadius = 10
            expectedHourLabel.text = hourString
            amExpectedLabel.text = amString
            labelOne.text = "Other Alarms"
            labelOne.textAlignment = .left
            labelOne.font = UIFont(name: "HaboroSoft-NorMed",size: 24.0)
            
            bedtimeHourLabel.text = hourString2
            amBedtimeLabel.text = amString2
            
        }
        
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        loadAlarms()
        
        getUsernickName()

        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
                 
        if(AlarmsNewUserViewController.closest.description == "not" && alarms.count == 0) {
            stackViewAlarms.isHidden = true
            tomorrowLabel.isHidden = true
            labelOne.text = "You don't have any alarms yet. Press the + button to create a new one."
        } else {
            stackViewAlarms.isHidden = false
            tomorrowLabel.isHidden = false
            labelOne.text = "Other Alarms"
            labelOne.textAlignment = .left
            labelOne.font = UIFont(name: "HaboroSoft-NorMed",size: 24.0)

            bedtimeView.layer.cornerRadius = 10
            expectedView.layer.cornerRadius = 10
        }
        
        let uid = UserDefaults.standard.object(forKey: "user_uid_key")
        
    
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
        
    @IBAction func editPressed(_ sender: UIButton) {
    }
    
    func loadAlarms() {
        
        if let id = Auth.auth().currentUser?.uid {
            db.collection(K.FStore.alarmsCollection)
                .whereField(K.FStore.createdByField, isEqualTo: id)
                .order(by: K.FStore.dateField, descending: true)
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
                                self.alarms.append(newAlarm)
                                
                                DispatchQueue.main.async {
                                    self.tableView.reloadData()
                                    let indexPath = IndexPath(row: self.alarms.count - 1, section: 0)
                                    self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                                    self.viewDidAppear(true)
                                }
                            }
                            
                        }
                        AlarmsNewUserViewController.closest = self.closer()
                    }
                }
        }
        
        
    }
    
    func closer() -> Alarm {
        var menor = Double.infinity
        var rta = Alarm(alarm_date: Date().addingTimeInterval(-10000000000000), createdBy: "", description: "not", exact: false, repeat_day: [:])
        for alarm in alarms {
            if(menor > alarm.alarm_date.timeIntervalSinceNow && alarm.alarm_date.timeIntervalSinceNow > 0  ) {
                menor = alarm.alarm_date.timeIntervalSinceNow
                print("Encontré el menor")
                rta = alarm
            }
        }
        return rta
    }
    
    func getUsernickName() {
        
        if let email = Auth.auth().currentUser?.email {
            db.collection(K.FStore.usersCollection)
                .whereField("email", isEqualTo: email)
                .addSnapshotListener { (querySnapshot, error) in
                    
                    if let e = error {
                        print("There was an issue retrieving data from Firestore. \(e)")
                    } else {
                        for document in querySnapshot!.documents {
                            
                            let data = document.data()
                            
                            if let email = data["email"] as? String,
                            let age = data["age"] as? Int,
                            let fullname = data["fullname"] as? String,
                            let nickname = data["nickname"] as? String,
                            let gender = data["gender"] as? String,
                            let occupation = data["occupation"] as? String {
                                AlarmsNewUserViewController.user = User(email: email, a: age, f: fullname, n: nickname, g: gender, o: occupation)
                            }
                        }
                    }
                }
        }
    }
    
}

extension AlarmsNewUserViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alarms.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                
        let alarm = alarms[indexPath.row]
        
        let formatter = DateFormatter()
        let formatter2 = DateFormatter()
        formatter.dateFormat = "HH:mm " // "a" prints "pm" or "am"
        formatter2.dateFormat = "a"
        
        formatter2.amSymbol = "AM"
        formatter2.pmSymbol = "PM"
        let hourString = formatter.string(from:alarm.alarm_date)
        let amString = formatter2.string(from: alarm.alarm_date)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! AlarmCell
        cell.hourLabel.text = hourString
        cell.amLabel.text = amString
        cell.descriptionLabel.text = "\(alarm.description), \(alarm.getRepeatDays())"

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
        
}



