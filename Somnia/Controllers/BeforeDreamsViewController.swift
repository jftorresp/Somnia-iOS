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
        let homeViewController = storyboard?.instantiateViewController(identifier: "RecordDreamsViewController") as? RecordDreamsViewController
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }
    @IBAction func noAction(_ sender: UIButton) {
        let homeViewController = storyboard?.instantiateViewController(identifier: K.tabBar) as? UITabBarController
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        yesButton.layer.cornerRadius = 12
        noButton.layer.cornerRadius = 12
    }
}
