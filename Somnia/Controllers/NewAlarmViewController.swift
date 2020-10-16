//
//  NewAlarmViewController.swift
//  Somnia
//
//  Created by Nicolas Cobos on 15/10/20.
//

import UIKit
import Firebase

class NewAlarmViewController: UIViewController {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var BeforeExact: UISegmentedControl!
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBOutlet weak var CancelButton: UIBarButtonItem!
    
    @IBAction func cancelAction(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var AlarmHour: UIDatePicker!
    
    //Buttons of each day
    
    @IBOutlet weak var MondayButton: UIButton!
    
    @IBAction func MondayAction(_ sender: UIButton) {
        if !MondayButton.isSelected{
        MondayButton.isSelected=true
        }
        else{MondayButton.isSelected=false}
    }
    
    @IBOutlet weak var TuesdayButton: UIButton!
    
    @IBAction func TuesdayAction(_ sender: UIButton) {
        if !TuesdayButton.isSelected{
        TuesdayButton.isSelected=true
        }
        else{TuesdayButton.isSelected=false}
    }
    @IBOutlet weak var WednesdayButton: UIButton!
    @IBAction func WednesdayAction(_ sender: UIButton) {
        if !WednesdayButton.isSelected{
        WednesdayButton.isSelected=true
        }
        else{WednesdayButton.isSelected=false}
    }
    @IBOutlet weak var ThursdayButton: UIButton!
    @IBAction func ThursdayAction(_ sender: UIButton) {
        if !ThursdayButton.isSelected{
        ThursdayButton.isSelected=true
        }
        else{ThursdayButton.isSelected=false}
    }
    @IBOutlet weak var FridayButton: UIButton!
    @IBAction func FridayAction(_ sender: UIButton) {
        if !FridayButton.isSelected{
        FridayButton.isSelected=true
        }
        else{FridayButton.isSelected=false}
    }
    @IBOutlet weak var SaturdayButton: UIButton!
    @IBAction func SaturdayAction(_ sender: UIButton) {
        if !SaturdayButton.isSelected{
        SaturdayButton.isSelected=true
        }
        else{SaturdayButton.isSelected=false}
    }
    @IBOutlet weak var SundayButton: UIButton!
    @IBAction func SundayAction(_ sender: UIButton) {
        if !SundayButton.isSelected{
        SundayButton.isSelected=true
        }
        else{SundayButton.isSelected=false}
    }
    
    @IBOutlet weak var DayStack: UIStackView!
    
    @IBOutlet weak var DescriptionTxt: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DayStack.layer.cornerRadius=6
        DescriptionTxt.layer.cornerRadius=6
        UIDatePicker.appearance().tintColor = UIColor.white
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "HaboroSoft-NorBol", size: 14)!], for: .normal)
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "HaboroSoft-NorBol", size: 14)!], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.white], for: .normal)
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.black], for: .selected)
        
        
        
        for button in [MondayButton, TuesdayButton, WednesdayButton, ThursdayButton, FridayButton, SaturdayButton, SundayButton] {
            button?.setTitleColor(UIColor.green, for: UIControl.State.selected)
            button?.setTitleColor(UIColor.white, for: UIControl.State.normal)
            button?.layer.cornerRadius=25
        }
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "HaboroSoft-NorBoo", size: 15)!], for: [])

       
    }
}
