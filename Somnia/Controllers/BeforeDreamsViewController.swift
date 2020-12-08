//
//  BeforeDreamsViewController.swift
//  Somnia
//
//  Created by Nicolas Cobos on 7/12/20.
//

import Foundation
import UIKit

class BeforeDreamsViewController: UIViewController {
    
    
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    @IBAction func yesAction(_ sender: UIButton) {
    }
    @IBAction func noAction(_ sender: UIButton) {
    }
    
    override func viewDidLoad() {
        yesButton.layer.cornerRadius = 12
        noButton.layer.cornerRadius = 12
    }
}
