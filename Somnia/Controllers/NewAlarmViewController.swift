//
//  NewAlarmViewController.swift
//  Somnia
//
//  Created by Juan Felipe Torres on 16/10/20.
//

import UIKit
import Firebase
import UserNotifications

class NewAlarmViewController: UIViewController{
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var beforeExact: UISegmentedControl!
    @IBOutlet weak var mondayButton: UIButton!
    @IBOutlet weak var tuesdayButton: UIButton!
    @IBOutlet weak var wednesdayButton: UIButton!
    @IBOutlet weak var thursdayButton: UIButton!
    @IBOutlet weak var fridayButton: UIButton!
    @IBOutlet weak var saturdayButton: UIButton!
    @IBOutlet weak var sundayButton: UIButton!
    @IBOutlet weak var dayStack: UIStackView!
    @IBOutlet weak var descriptionTxt: UITextField!
    @IBOutlet weak var iWantToLabel: UILabel!
    
    weak var delegate : NewAlarmViewControllerDelegate?
    
    var currentId: String = ""
    
    let db = Firestore.firestore()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        iWantToLabel.text = "I want to wake up exactly at this hour"
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: { success, error in
                    if success {
                        // schedule test
//                        self.scheduleTest()
                    }
                    else if error != nil {
                        print("error occurred")
                    }
                })
                
        dayStack.layer.cornerRadius=6
        descriptionTxt.layer.cornerRadius=6
        UIDatePicker.appearance().tintColor = UIColor.white
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "HaboroSoft-NorBol", size: 14)!], for: .normal)
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "HaboroSoft-NorBol", size: 14)!], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.white], for: .normal)
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.black], for: .selected)
        
        for button in [mondayButton, tuesdayButton, wednesdayButton, thursdayButton, fridayButton, saturdayButton, sundayButton] {
            button?.setTitleColor(UIColor.green, for: UIControl.State.selected)
            button?.setTitleColor(UIColor.white, for: UIControl.State.normal)
            button?.layer.cornerRadius=25
        }
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "HaboroSoft-NorBoo", size: 15)!], for: [])
    }
    
    //MARK: - Action of buttons
    
    @IBAction func cancelAction(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    func startOfHour(myDate: Date) -> Date?
    {
            let calendar = Calendar.current

            var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: myDate)

            components.second = 0

            return calendar.date(from: components)
    }

    
    
    @IBAction func addAction(_ sender: UIBarButtonItem) {
        
        let repeatDic = ["1": mondayButton.isSelected, "2": tuesdayButton.isSelected, "3": wednesdayButton.isSelected, "4": thursdayButton.isSelected, "5": fridayButton.isSelected, "6": saturdayButton.isSelected, "7": sundayButton.isSelected]
        
        var isExact = false
        if beforeExact.titleForSegment(at: beforeExact.selectedSegmentIndex)! == "Exact"{
            isExact = true
        }
        
        let targetDate = datePicker.date
        
        var finalDate = Date()
        
        let newDate = startOfHour(myDate: targetDate)!
        
        var dateComponent = DateComponents()
        dateComponent.day = 1
        
        if newDate.timeIntervalSinceNow < Date().timeIntervalSinceNow {
            
            if let newDate2 = Calendar.current.date(byAdding: dateComponent, to: newDate) {
                finalDate = newDate2
            }
        } else {
            finalDate = newDate
        }
        
        if let id = Auth.auth().currentUser?.uid{
            db.collection(K.FStore.alarmsCollection).addDocument(data: ["alarm_date": finalDate, "createdBy": id, "description": descriptionTxt.text!, "exact": isExact, "isActive": true, "repeat": repeatDic]) { (error) in
                
                if let e = error {
                    print("Error adding the user to the database, \(e.localizedDescription)")
                } else {
                    print("Successfully saved data")
                }
            }
        }
        
        let content = UNMutableNotificationContent()
                        content.title = "Alarm!"
                        content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "relaxing_birds.mp3"))
                        content.body = descriptionTxt.text ?? ""

      
        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second],
                                                                                                                  from: newDate),
                                                                    repeats: false)

                        let request = UNNotificationRequest(identifier: "some_long_id", content: content, trigger: trigger)
                        UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
                            if error != nil {
                                print("something went wrong")
                            }
                        })
        
        dismiss(animated: true, completion: nil)
        
        
        
        if let delegate = delegate{
            delegate.doSomethingWith(date: datePicker.date, description: descriptionTxt.text!, repeatWhen: repeatDic, exact: isExact, createdBy: currentId)
        }
    }
    
    @IBAction func mondayAction(_ sender: UIButton) {
        if !mondayButton.isSelected{
            mondayButton.isSelected=true
        }
        else{mondayButton.isSelected=false}
    }
    
    @IBAction func tuesdayAction(_ sender: UIButton) {
        if !tuesdayButton.isSelected{
            tuesdayButton.isSelected=true
        }
        else{tuesdayButton.isSelected=false}
    }
    
    @IBAction func wednesdayAction(_ sender: UIButton) {
        if !wednesdayButton.isSelected{
            wednesdayButton.isSelected=true
        }
        else{wednesdayButton.isSelected=false}
    }
    
    @IBAction func thursdayAction(_ sender: UIButton) {
        if !thursdayButton.isSelected{
            thursdayButton.isSelected=true
        }
        else{thursdayButton.isSelected=false}
    }
    
    @IBAction func fridayAction(_ sender: UIButton) {
        if !fridayButton.isSelected{
            fridayButton.isSelected=true
        }
        else{fridayButton.isSelected=false}
    }
    
    @IBAction func saturdayAction(_ sender: UIButton) {
        if !saturdayButton.isSelected{
            saturdayButton.isSelected=true
        }
        else{saturdayButton.isSelected=false}
    }
    
    @IBAction func sundayAction(_ sender: UIButton) {
        if !sundayButton.isSelected{
            sundayButton.isSelected=true
        }
        else{sundayButton.isSelected=false}
    }
    
    @IBAction func beforeExactChanged(_ sender: UISegmentedControl) {
        if beforeExact.titleForSegment(at: beforeExact.selectedSegmentIndex)! == "Exact"{
            iWantToLabel.text = "I want to wake up exactly at this hour"
        } else {
            iWantToLabel.text = "I want to wake up smoothly (30 min time window)"
        }
    }
    
    
    
    //MARK: - Send info to AlarmsNeUserViewController
    
}

protocol NewAlarmViewControllerDelegate : NSObjectProtocol{
    func doSomethingWith(date: Date, description: String, repeatWhen: [String: Bool], exact: Bool, createdBy: String)
}
