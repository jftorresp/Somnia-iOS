//
//  SleepViewController.swift
//  Somnia
//
//  Created by Juan Felipe Torres on 15/10/20.
//

import UIKit
import Firebase

class SleepViewController: UIViewController {
    
    @IBOutlet weak var sleepLabel: UILabel!
    @IBOutlet weak var sleepButton: UIButton!
    @IBOutlet weak var sleepView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var timeLabel: UILabel!
    var label = UILabel()
    
    var alarms = [String]()
    let db = Firestore.firestore()
    
        
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("Esta es la closest en sleep view: \(AlarmsNewUserViewController.closest)")
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm a" // "a" prints "pm" or "am"
        
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        
        if(AlarmsNewUserViewController.closest.description != "not") {
            let hourString = formatter.string(from:AlarmsNewUserViewController.closest.alarm_date)
            
            sleepLabel.text = "You have an alarm set up at "
            
            timeLabel.text = hourString
            timeLabel.textColor = UIColor.white
            timeLabel.font = UIFont(name: "HaboroSoft-NorBol", size: 40.0)
            sleepView.isHidden = true
        }
        

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Esta es la closest en sleep view: \(AlarmsNewUserViewController.closest)")
        
        if(AlarmsNewUserViewController.closest.description == "not"){
            sleepView.isHidden = false

        }
            
            sleepButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            sleepButton.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
            sleepButton.layer.shadowOpacity = 1.0
            sleepButton.layer.shadowRadius = 0.0
            sleepButton.layer.masksToBounds = false
            sleepButton.layer.cornerRadius = sleepButton.frame.size.width / 12
            
            sleepView.layer.cornerRadius = 12
            imageView.layer.cornerRadius = 12
            datePicker.layer.cornerRadius = 12
            datePicker.setValue(UIColor(named: K.BrandColors.green), forKeyPath: "textColor")
            
            sleepView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.15).cgColor
            sleepView.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
            sleepView.layer.shadowOpacity = 1.0
            sleepView.layer.shadowRadius = 0.0
            sleepView.layer.masksToBounds = false
    
        // Do any additional setup after loading the view.
    }
    
    @IBAction func sleepPressed(_ sender: UIButton) {
        
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
