//
//  AlarmViewController.swift
//  Somnia
//
//  Created by Nicolas Cobos on 15/10/20.
//

import UIKit
import Firebase

class AlarmsNewUserViewController: UIViewController {

    @IBOutlet weak var ImportAlarmsButton: UIButton!
    
    @IBOutlet weak var AddAlarmsButton: UIButton!
    
    @IBAction func ImportAction(_ sender: UIButton) {
    }
    @IBAction func AddAlarmAction(_ sender: UIButton) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

