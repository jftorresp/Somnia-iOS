//
//  AlarmViewController.swift
//  Somnia
//
//  Created by Nicolas Cobos on 15/10/20.
//

import UIKit
import Firebase

class AlarmsNewUserViewController: UIViewController {
    
//    var exactOrBefore: String?
//    var date: Date?
//    var repeatDic: [Int: Bool]?
//    var desc: String?
//
    @IBOutlet weak var AddAlarmsButton: UIButton!
    
    var label1: UILabel!
    var label2: UILabel!
    var label3: UILabel!
    
    @IBAction func AddAlarmAction(_ sender: UIButton) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
               
//        let formatter = DateFormatter()
//        formatter.locale = Locale(identifier: "en_US_POSIX")
//        formatter.dateFormat = "HH:mm a"
//        formatter.amSymbol = "AM"
//        formatter.pmSymbol = "PM"
//
//        let dateString = formatter.string(from: Date())
        
//        label1.text = exactOrBefore
//        label2.text = dateString
//        label3.text = desc
        
//        print(exactOrBefore)
//        print(date)
//        print(desc)
//        print(repeatDic)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

