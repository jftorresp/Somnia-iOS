//
//  AlarmViewController.swift
//  Somnia
//
//  Created by Nicolas Cobos on 15/10/20.
//

import UIKit
import Firebase
import CoreLocation

class AlarmsNewUserViewController: UIViewController, NewAlarmViewControllerDelegate {
    
    //    var exactOrBefore: String?
    //    var date: Date?
    //    var repeatDic: [Int: Bool]?
    //    var desc: String?
    //
    @IBOutlet weak var AddAlarmsButton: UIButton!
    @IBOutlet weak var labelOne: UILabel!
    @IBOutlet weak var labelTwo: UILabel!
    @IBOutlet weak var selectedtVStack: UIStackView!
    
    
    var alarms: [Alarm] = []
    
    static var closest : Alarm = Alarm(alarm_date: Date(), createdBy: "", description: "", exact: false, repeat_day: [:])
    
    var otherAlarms = UILabel()
    var editButton = UIButton()
    var horizontalStack = UIStackView()
    var verticalStack = UIStackView()
    var bigVertical = UIStackView()
    var alarmV = AlarmElement()
    
   
    static var currentIdGlobal: String = ""
    
    
    let locationManager = CLLocationManager()
    
    let db = Firestore.firestore()
    
    
    
    @IBAction func AddAlarmAction(_ sender: UIButton) {
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        loadAlarms()
        
        alarmV.hourLabel?.text = "Hola"
        alarmV.timeLabel?.text = "Como vas"
        alarmV.onOffSwitch?.isOn = true
        alarmV.descRepeatLabel?.text = "Chao"
        alarmV.translatesAutoresizingMaskIntoConstraints = false
        
        otherAlarms.text = "Hello"
        
        selectedtVStack.removeArrangedSubview(labelTwo)
        selectedtVStack.removeArrangedSubview(labelOne)
        selectedtVStack.addSubview(alarmV)
        
        locationManager.delegate = self
        // Display pop-out to user to allow use of location
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        
//        AlarmsNewUserViewController.closest = closer()
        
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
        
        if let id = Auth.auth().currentUser?.uid{
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
                            
                            // Fetch main thread and run the code inside
                            DispatchQueue.main.async {
                                
                            }
                        }
                        self.createAlarmsView()
                        print("Lista alarmas 2: \(self.alarms)")
                        AlarmsNewUserViewController.closest=self.closer()
                        print("Este es closest en load: \(AlarmsNewUserViewController.closest)")
                    }
                }
        }
        
        
    }
    
    func createAlarmsView() {
        
        labelOne.text = ""
        labelTwo.text = ""
        
        horizontalStack.axis = .horizontal
        horizontalStack.alignment = .fill
        horizontalStack.distribution = .fill
        horizontalStack.spacing = 20
        otherAlarms.text = "Other Alarms"
        otherAlarms.font = UIFont(name: "HaboroSoft-NorMed",size: 24.0)
        otherAlarms.textColor = UIColor.white
        editButton.setImage(UIImage(named: "pencil"), for: .normal)
        editButton.tintColor = UIColor.black
        
        horizontalStack.translatesAutoresizingMaskIntoConstraints = false
        horizontalStack.addSubview(otherAlarms)
        horizontalStack.addSubview(editButton)
                
        verticalStack.axis = .vertical
        verticalStack.alignment = .fill
        verticalStack.distribution = .fill
        verticalStack.spacing = 8
        verticalStack.translatesAutoresizingMaskIntoConstraints = false
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "HH:MM"
        
        let formatter2 = DateFormatter()
        formatter2.locale = Locale(identifier: "en_US_POSIX")
        formatter2.dateFormat = "a"
        formatter2.amSymbol = "AM"
        formatter2.pmSymbol = "PM"
        
        for alarm in alarms {
            
            let alarmView = AlarmElement()
            let hourString = formatter.string(from: alarm.alarm_date)
            let timeString = formatter2.string(from: alarm.alarm_date)

            alarmView.hourLabel?.text = "Hola"
            alarmView.timeLabel?.text = "Como vas"
            alarmView.onOffSwitch?.isOn = false
            alarmView.descRepeatLabel?.text = "Chao"
            
            verticalStack.addSubview(alarmView)
        }
        
        
        
        bigVertical.axis = .vertical
        bigVertical.alignment = .fill
        bigVertical.distribution = .fill
        bigVertical.spacing = 10
        bigVertical.translatesAutoresizingMaskIntoConstraints = false
        
        bigVertical.addSubview(horizontalStack)
        bigVertical.addSubview(verticalStack)
        
        self.view.addSubview(alarmV)
        
    }
    
    
    func addConstraints() {
        var constraints = [NSLayoutConstraint]()
        
        // Add constraints
        constraints.append(alarmV.widthAnchor.constraint(equalTo: view.widthAnchor))
        constraints.append(alarmV.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5))
        
        // Activate
        NSLayoutConstraint.activate(constraints)
    }
    
}

extension AlarmsNewUserViewController: CLLocationManagerDelegate {
        
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func closer() -> Alarm{
        print("este es el length del arreglo de alarmas: \(alarms.count)")
        var menor = Double.infinity
        var rta = Alarm(alarm_date: Date(), createdBy: "", description: "", exact: false, repeat_day: [:])
        for alarm in alarms{
            if(menor > alarm.alarm_date.timeIntervalSinceNow && alarm.alarm_date.timeIntervalSinceNow > 0  ){
                menor = alarm.alarm_date.timeIntervalSinceNow
                rta = alarm
            }
        }
        print("rta de closer: \(rta)")
        return rta
    }
    
}



