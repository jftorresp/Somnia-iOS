//
//  AlarmTriggeredViewController.swift
//  Somnia
//
//  Created by Nicolas Cobos on 29/10/20.
//

import Foundation
import UIKit

class AlarmTriggeredViewController: UIViewController {
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var ampmLabel: UILabel!
    @IBOutlet weak var gameButton: UIButton!
    
    
    @IBAction func gameButtonAction(_ sender: UIButton) {
        
        SleepTwoViewController.alarmSound?.stop()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let date = Date()
        let formatter = DateFormatter()
        let formatter2 = DateFormatter()
        formatter.dateFormat = "HH:mm " // "a" prints "pm" or "am"
        formatter2.dateFormat = "a"
        
        formatter2.amSymbol = "AM"
        formatter2.pmSymbol = "PM"
        let hourString = formatter.string(from:date)
        let amString = formatter2.string(from: date)
        
        hourLabel.text = hourString
        ampmLabel.text = amString
        
        gameButton.layer.cornerRadius = 10
    }
}
