//
//  NewAlarmViewController.swift
//  Somnia
//
//  Created by Juan Felipe Torres on 16/10/20.
//

import UIKit
import Firebase

class NewAlarmViewController: UIViewController {
    
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
    
    var currentId: String = ""
    
    let db = Firestore.firestore()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let emailPersisted = Auth.auth().currentUser?.email {
            db.collection(K.FStore.usersCollection).whereField("email", isEqualTo: emailPersisted)
                .getDocuments() { [self] (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        let documents = querySnapshot!.documents
                        for i in 0 ..< documents.count-1 {
                            self.currentId = String(documents[i].documentID)
                        }
                        self.currentId = documents[0].documentID
                    }
                }
        }
        else {
            print("Not a user logged in")
        }
        
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
    
    @IBAction func addAction(_ sender: UIBarButtonItem) {
        
        let repeatDic = ["1": mondayButton.isSelected, "2": tuesdayButton.isSelected, "3": wednesdayButton.isSelected, "4": thursdayButton.isSelected, "5": fridayButton.isSelected, "6": saturdayButton.isSelected, "7": sundayButton.isSelected]
        
        var isExact = false
        if beforeExact.titleForSegment(at: beforeExact.selectedSegmentIndex)! == "Exact"{
            isExact = true
        }
        
        db.collection(K.FStore.alarmsCollection).addDocument(data: ["alarm_date": datePicker.date, "createdBy": currentId, "description": descriptionTxt.text!, "exact": isExact, "repeat": repeatDic]) { (error) in
            
            if let e = error {
                print("Error adding the user to the database, \(e.localizedDescription)")
            } else {
                print("Successfully saved data")
            }
        }
        
        dismiss(animated: true, completion: nil)
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
    
    //MARK: - Send info to AlarmsNeUserViewController
    
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //        if segue.identifier == "AddAlarmToAlarm" {
    //            let destinationVC = segue.destination as! AlarmsNewUserViewController
    //            destinationVC.date = datePicker.date
    //            destinationVC.exactOrBefore = beforeExact.titleForSegment(at: beforeExact.selectedSegmentIndex)!
    //            destinationVC.desc = descriptionTxt.text!
    //            destinationVC.repeatDic = [1: mondayButton.isSelected, 2: tuesdayButton.isSelected, 3: wednesdayButton.isSelected, 4: thursdayButton.isSelected, 5: fridayButton.isSelected, 6: saturdayButton.isSelected, 7: sundayButton.isSelected]
    //        }
    //    }
    
}
