//
//  NewAlarmViewController.swift
//  Somnia
//
//  Created by Juan Felipe Torres on 16/10/20.
//

import UIKit

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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    @IBAction func cancelAction(_ sender: UIBarButtonItem) {
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
    
    
    
}
