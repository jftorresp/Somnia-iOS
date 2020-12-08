//
//  RecordDreamsViewController.swift
//  Somnia
//
//  Created by Nicolas Cobos on 7/12/20.
//

import Foundation
import UIKit

class RecordDreamsViewController: UIViewController {
    
    
    @IBOutlet weak var minutesLabel: UILabel!
    @IBOutlet weak var secondsLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var repeatButton: UIButton!
    
    @IBOutlet weak var saveButton: UIButton!
    override func viewDidLoad() {
        startButton.layer.cornerRadius = 12
        repeatButton.layer.cornerRadius = 12
        saveButton.layer.cornerRadius = 12
    }
    @IBAction func startAction(_ sender: UIButton) {
    }
    
    @IBAction func saveAction(_ sender: UIButton) {
        let homeViewController = storyboard?.instantiateViewController(identifier: K.tabBar) as? UITabBarController
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }
    @IBAction func repeatButton(_ sender: UIButton) {
        let homeViewController = storyboard?.instantiateViewController(identifier: K.tabBar) as? UITabBarController
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }
}
