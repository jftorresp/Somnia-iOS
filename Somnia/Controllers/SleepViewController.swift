//
//  SleepViewController.swift
//  Somnia
//
//  Created by Juan Felipe Torres on 15/10/20.
//

import UIKit

class SleepViewController: UIViewController {
    
    @IBOutlet weak var sleepLabel: UILabel!
    @IBOutlet weak var sleepButton: UIButton!
    @IBOutlet weak var sleepView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var imageView: UIImageView!
    
        
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
