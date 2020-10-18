//
//  SleepTwoViewController.swift
//  Somnia
//
//  Created by Juan Felipe Torres on 15/10/20.
//

import UIKit

class SleepTwoViewController: UIViewController {

    @IBOutlet weak var sleepActButton: UIButton!
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var hour2Label: UILabel!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sleepActButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        sleepActButton.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        sleepActButton.layer.shadowOpacity = 1.0
        sleepActButton.layer.shadowRadius = 0.0
        sleepActButton.layer.masksToBounds = false
        sleepActButton.titleLabel?.textAlignment = .center
        sleepActButton.layer.cornerRadius = sleepActButton.frame.size.width / 12
                
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "a"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        
        let formatter2 = DateFormatter()
        formatter2.locale = Locale(identifier: "en_US_POSIX")
        formatter2.dateFormat = "HH:mm"
        
        let dateString = formatter.string(from: Date())
        let dateString2 = formatter2.string(from: Date())
        
        hourLabel.text = dateString2
        hour2Label.text = dateString
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func sleepActPressed(_ sender: Any) {
        
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
