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
    
    var editMode:Bool = false
    
    var alarmsId: [AlarmsId] = []
    static var currenAlarmId : String?
    
    static var selectedAlarm: Alarm?
    
    static var listAnalysis: [Analysis] = []
    
    static var user: User?
    
    static var alarms: [Alarm] = []
    let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .allDomainsMask).first
    
    static var closest : Alarm = Alarm(alarm_date: Date().addingTimeInterval(-10000000000000), createdBy: "", description: "not", exact: false, repeat_day: [:])
           
    static var currentIdGlobal: String = ""
    
    let db = Firestore.firestore()
    
    @IBAction func AddAlarmAction(_ sender: UIButton) {
        
        
    }
        
    override func viewDidAppear(_ animated: Bool) {
        
        tableView.allowsSelectionDuringEditing = true
                        
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
        
        if(AlarmsNewUserViewController.closest.description == "not" && AlarmsNewUserViewController.alarms.count == 0) {
            stackViewAlarms.isHidden = true
            tomorrowLabel.isHidden = true
            editButLabel.isHidden = true
            labelOne.textAlignment = .center
            labelOne.font = UIFont(name: "HaboroSoft-NorMed",size: 18.0)
            labelOne.text = "You don't have any alarms yet. Press the + button to create a new one."
            tableView.separatorStyle = .none
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
            tableView.separatorStyle = .singleLine
            
        }
        
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        loadAlarms()
        editMode = false
        getUsernickName()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        loadAnalysis()
        
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
                 
        if(AlarmsNewUserViewController.closest.description == "not" && AlarmsNewUserViewController.alarms.count == 0) {
            stackViewAlarms.isHidden = true
            tomorrowLabel.isHidden = true
            labelOne.text = "You don't have any alarms yet. Press the + button to create a new one."
            tableView.separatorStyle = .none

        } else {
            stackViewAlarms.isHidden = false
            tomorrowLabel.isHidden = false
            labelOne.text = "Other Alarms"
            labelOne.textAlignment = .left
            labelOne.font = UIFont(name: "HaboroSoft-NorMed",size: 24.0)

            bedtimeView.layer.cornerRadius = 10
            expectedView.layer.cornerRadius = 10
            tableView.separatorStyle = .singleLine

        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
        
    @IBAction func editPressed(_ sender: UIButton) {
                
        if(!editMode){
            editButLabel.setImage(nil, for: .normal)
            editButLabel.setTitle("Cancel", for: .normal)
            editButLabel.titleLabel?.font = UIFont(name: "HaboroSoft-NorMed",size: 15.0)
            editMode = true
            tableView.setEditing(true, animated: true)
            
        }
        else{
            editButLabel.setImage(UIImage(systemName: "pencil"), for: .normal)
            editButLabel.setTitle("", for: .normal)
            editMode = false
            tableView.setEditing(false, animated: true)
        }
    }
    
    func loadAlarms() {
        
        if let id = Auth.auth().currentUser?.uid {
            db.collection(K.FStore.alarmsCollection)
                .whereField(K.FStore.createdByField, isEqualTo: id)
                .order(by: K.FStore.dateField, descending: true)
                .addSnapshotListener { (querySnapshot, error) in
                    
                    AlarmsNewUserViewController.alarms = []
                    
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
                                AlarmsNewUserViewController.alarms.append(newAlarm)
                                
                                let alarmId = AlarmsId(id: document.documentID, date: dateCorrect, description: descriptionCorrect)
                                
                                self.alarmsId.append(alarmId)
                                
                                DispatchQueue.main.async {
                                    self.tableView.reloadData()
                                    let indexPath = IndexPath(row: AlarmsNewUserViewController.alarms.count - 1, section: 0)
                                    self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                                    self.viewDidAppear(true)
                                }
                            }
                            
                        }
                        AlarmsNewUserViewController.closest = self.closer()
                        print("Alarms: \(AlarmsNewUserViewController.alarms)")
                    }
                }
        }
        
        
    }
    
    func closer() -> Alarm {
        var menor = Double.infinity
        var rta = Alarm(alarm_date: Date().addingTimeInterval(-10000000000000), createdBy: "", description: "not", exact: false, repeat_day: [:])
        for alarm in AlarmsNewUserViewController.alarms {
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
                            let lat = data["lat"] as? Double,
                            let lon = data["lon"] as? Double,
                            let occupation = data["occupation"] as? String {
                                AlarmsNewUserViewController.user = User(email: email, a: age, f: fullname, n: nickname, g: gender, o: occupation, la: lat, lo: lon)
                            }
                        }
                    }
                }
        }
        
        UserDefaults.standard.set(AlarmsNewUserViewController.user?.nickname, forKey: "nickname")
    }
    
    func deleteAlarm(position: Int) {
        
        let currentId = getAlarmIdDelete(position: position)
        db.collection(K.FStore.alarmsCollection).document(currentId).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
    
    func getAlarmIdDelete(position: Int) -> String{
        var current = ""
        for (index, alarm) in alarmsId.enumerated() {
            if index == position {
                current = alarm.id
            }
        }
        return current
    }
    
    func getCurrentAlarmId(selectedDate: Date?, selectedDescription: String?){
        for alarm in alarmsId {
            if alarm.date == selectedDate && alarm.description == selectedDescription {
                AlarmsNewUserViewController.currenAlarmId = alarm.id
            }
        }
    }
    
    
    func loadAnalysis() {
        
        if let id = Auth.auth().currentUser?.uid {
            
            db.collection(K.FStore.analysisCollection)
                .whereField(K.FStore.createdByField, isEqualTo: id)
                .getDocuments { (querySnapshot, error) in
                    
                    AlarmsNewUserViewController.listAnalysis = []
                                        
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
                                
                                let newAnalysis = Analysis(nightDate: date, duration: duration!, totalEvents: totalEvents!, totalSnores: totalSnores!, snorePercentage: snorePer!, wake: wake!, light: light!, deep: deep!, rem: rem!, hourStage: hourStage!)
                                
                                AlarmsNewUserViewController.listAnalysis.append(newAnalysis)
                                                                
                            }
                        }
                        StatsViewController.closerAnalysis = self.getCloserAnalysis()
                        print(StatsViewController.closerAnalysis)
                    }
                }
        }
    }
    
    func getCloserAnalysis()-> Analysis {
//        var menor = Double.infinity
//        var analisis = Analysis(nightDate: Date().addingTimeInterval(-10000000000000), duration: 0.0, totalEvents: 0, totalSnores: 0, snorePercentage: 0.0, wake: 0.0, light: 0.0, deep: 0.0, rem: 0.0, hourStage: [:])
//        for i in AlarmsNewUserViewController.listAnalysis {
//            if(menor > i.nightDate.timeIntervalSinceNow) {
//                menor = i.nightDate.timeIntervalSinceNow
//                analisis = i
//            }
//        }
//        return analisis
        
        var menor = -1.0
        var analisis = Analysis(nightDate: Date().addingTimeInterval(-10000000000000), duration: 0.0, totalEvents: 0, totalSnores: 0, snorePercentage: 0.0, wake: 0.0, light: 0.0, deep: 0.0, rem: 0.0, hourStage: [:])
        for i in AlarmsNewUserViewController.listAnalysis {
            if(menor < i.nightDate.timeIntervalSince1970) {
                menor = i.nightDate.timeIntervalSince1970
                analisis = i
            }
        }
        return analisis
    }
    
}

extension AlarmsNewUserViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AlarmsNewUserViewController.alarms.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                
        let alarm = AlarmsNewUserViewController.alarms[indexPath.row]
        
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
        cell.selectionStyle = .none
        
        let smallConf = UIImage.SymbolConfiguration(scale: .small)
        let isActive = UISwitch()
        let editBut = UIButton()
        editBut.setImage(UIImage(systemName: "chevron.right", withConfiguration: smallConf), for: .normal)
        editBut.sizeToFit()
        isActive.isOn = true
        isActive.onTintColor = UIColor(named: "Green")
        cell.accessoryView = isActive
        
        cell.editingAccessoryView = editBut
        cell.amLabel.text = amString
        cell.descriptionLabel.text = "\(alarm.description), \(alarm.getRepeatDays())"

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.tableView.isEditing == true && AlarmsNewUserViewController.alarms.isEmpty == false {
            print("Alarms: \(alarmsId)")
            
            AlarmsNewUserViewController.selectedAlarm = AlarmsNewUserViewController.alarms[indexPath.row]
            
            getCurrentAlarmId(selectedDate: AlarmsNewUserViewController.selectedAlarm?.alarm_date, selectedDescription: AlarmsNewUserViewController.selectedAlarm?.description)
            
            if let editAlarmVC = storyboard?.instantiateViewController(identifier: "EditAlarmVC") as EditAlarmViewController? {
                self.present(editAlarmVC, animated: true, completion: nil)
            }
        }
        
        editButLabel.setImage(UIImage(systemName: "pencil"), for: .normal)
        editButLabel.setTitle("", for: .normal)
        self.tableView.setEditing(false, animated: true)
    }
        
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            AlarmsNewUserViewController.alarms.remove(at: indexPath.row)
            self.tableView.beginUpdates()
            deleteAlarm(position: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .none)
            self.tableView.endUpdates()
            
        }
    }
    
}



struct AlarmsId {
    var id: String
    var date: Date
    var description: String
}



