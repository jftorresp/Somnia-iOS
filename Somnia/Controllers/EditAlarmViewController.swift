//
//  EditAlarmViewController.swift
//  Somnia
//
//  Created by Juan Felipe Torres on 11/11/20.
//

import UIKit
import Firebase

class EditAlarmViewController: UIViewController {

    @IBOutlet weak var date: UIDatePicker!
    @IBOutlet weak var beforeExact: UISegmentedControl!
    @IBOutlet weak var mondayButton: UIButton!
    @IBOutlet weak var tuesdayButton: UIButton!
    @IBOutlet weak var wednesdayButton: UIButton!
    @IBOutlet weak var thursdayButton: UIButton!
    @IBOutlet weak var fridayButton: UIButton!
    @IBOutlet weak var saturdayButton: UIButton!
    @IBOutlet weak var sundayButton: UIButton!
    @IBOutlet weak var descriptionButton: UITextField!
    @IBOutlet weak var iWantToLabel: UILabel!
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("ESTE ES MI PRECIOSO ID: \(AlarmsNewUserViewController.currenAlarmId)")

        iWantToLabel.text = "I want to wake up exactly at this hour"
        
        for button in [mondayButton, tuesdayButton, wednesdayButton, thursdayButton, fridayButton, saturdayButton, sundayButton] {
            button?.setTitleColor(UIColor(named: "Green"), for: UIControl.State.selected)
            button?.setTitleColor(UIColor.white, for: UIControl.State.normal)
            button?.layer.cornerRadius=25
            UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.white], for: .normal)
            UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.black], for: .selected)
        }
        
        if let currentAlarm = AlarmsNewUserViewController.selectedAlarm {
                        
            date.date = currentAlarm.alarm_date
            descriptionButton.text = currentAlarm.description
            mondayButton.isSelected = currentAlarm.repeat_day["1"]! == true  ? true: false
            tuesdayButton.isSelected = currentAlarm.repeat_day["2"]! == true ? true: false
            wednesdayButton.isSelected = currentAlarm.repeat_day["3"]! == true ? true: false
            thursdayButton.isSelected = currentAlarm.repeat_day["4"]! == true ? true: false
            fridayButton.isSelected = currentAlarm.repeat_day["5"]! == true ? true: false
            saturdayButton.isSelected = currentAlarm.repeat_day["6"]! == true ? true: false
            sundayButton.isSelected = currentAlarm.repeat_day["7"]! == true ? true: false
        }
    }
    
    func startOfHour(myDate: Date) -> Date?
    {
            let calendar = Calendar.current

            var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: myDate)

            components.second = 0

            return calendar.date(from: components)
    }

    @IBAction func cancelPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func editPressed(_ sender: UIBarButtonItem) {
        
        var isExact = false
        if beforeExact.titleForSegment(at: beforeExact.selectedSegmentIndex)! == "Exact"{
            isExact = true
        }
        
//        var difference = 0.0
//        if date.date.timeIntervalSince1970 < Date().timeIntervalSince1970 {
//            difference = Date().timeIntervalSince1970 - date.date.timeIntervalSince1970
//        }
//
//        let targetDate = date.date.addingTimeInterval(difference)
        
//        var finalDate = Date()
//
//        let newDate = startOfHour(myDate: targetDate)!
//
//        var dateComponent = DateComponents()
//        dateComponent.day = 1
//
//        if newDate.timeIntervalSinceNow < Date().timeIntervalSinceNow {
//
//            if let newDate2 = Calendar.current.date(byAdding: dateComponent, to: newDate) {
//                finalDate = newDate2
//            }
//        } else {
//            finalDate = newDate
//        }
        
        let dateEdited = date.date
        let currentDate = Date()
        let calendar = Calendar.current
        var components2 = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: dateEdited)
        var componentsCurrent = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: currentDate)
        components2.second = 0
        components2.day = componentsCurrent.day
        components2.month = componentsCurrent.month
        var dateOk = calendar.date(from: components2)!
        var dateComponent = DateComponents()
        dateComponent.day = 1
        
        if dateOk.timeIntervalSinceNow < Date().timeIntervalSinceNow {
            
            if let newDate2 = Calendar.current.date(byAdding: dateComponent, to: dateOk) {
                dateOk = newDate2
            }
        } else{
            
        }
        
        let repeatEdited = ["1": mondayButton.isSelected, "2": tuesdayButton.isSelected, "3": wednesdayButton.isSelected, "4": thursdayButton.isSelected, "5": fridayButton.isSelected, "6": saturdayButton.isSelected, "7": sundayButton.isSelected]
        
        if let alarmId = AlarmsNewUserViewController.currenAlarmId, let id = Auth.auth().currentUser?.uid, let descriptionEdited = descriptionButton.text {
            
            self.db.collection(K.FStore.alarmsCollection)
                .document(alarmId)
                .updateData(["alarm_date": dateOk, "createdBy": id, "description": descriptionEdited, "exact": isExact, "isActive": true, "repeat": repeatEdited]) { (error) in
                    if let e = error {
                        print("Error updating the user to the database, \(e.localizedDescription)")
                    } else {
                        print("Successfully updated data")
                    }
                }
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func deletePressed(_ sender: UIButton) {
        
        if let alarmId = AlarmsNewUserViewController.currenAlarmId {
            db.collection(K.FStore.alarmsCollection).document(alarmId).delete() { err in
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    print("Document successfully removed!")
                }
            }
        }
        AlarmsNewUserViewController.alarms.filter { $0.alarm_date != date.date }

        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func dayPressed(_ sender: UIButton) {
        
        if sender == mondayButton {
            if !mondayButton.isSelected{
                mondayButton.isSelected=true
            }
            else{ mondayButton.isSelected=false }
            
        } else if sender == tuesdayButton {
            if !tuesdayButton.isSelected{
                tuesdayButton.isSelected = true
            }
            else{ tuesdayButton.isSelected=false }
            
        } else if sender == wednesdayButton {
            if !wednesdayButton.isSelected{
                wednesdayButton.isSelected = true
            }
            else{ wednesdayButton.isSelected=false }
            
        } else if sender == thursdayButton {
            if !thursdayButton.isSelected{
                thursdayButton.isSelected = true
            }
            else{ thursdayButton.isSelected=false }
            
        } else if sender == fridayButton {
            if !fridayButton.isSelected{
                fridayButton.isSelected = true
            }
            else{ fridayButton.isSelected=false }
            
        } else if sender == saturdayButton {
            if !saturdayButton.isSelected{
                saturdayButton.isSelected = true
            }
            else{ saturdayButton.isSelected=false }
            
        } else if sender == sundayButton {
            if !sundayButton.isSelected{
                sundayButton.isSelected = true
            }
            else{ sundayButton.isSelected=false }
        }
    }
    
    @IBAction func beforeExactChanged(_ sender: UISegmentedControl) {
        if beforeExact.titleForSegment(at: beforeExact.selectedSegmentIndex)! == "Exact"{
            iWantToLabel.text = "I want to wake up exactly at this hour"
        } else {
            iWantToLabel.text = "I want to wake up smoothly (30 min time window)"
        }
    }
    
}
