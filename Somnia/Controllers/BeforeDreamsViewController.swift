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
    
    let networkMonitor = NetworkMonitor()
    
    @IBAction func yesAction(_ sender: UIButton) {
        
        networkMonitor.startMonitoring()
        
        if NetworkMonitor.connected == false {
            let dialogMessage = UIAlertController(title: "No connection", message: "It seems that you don´t have connection, try later.", preferredStyle: .alert)
            
            // Create OK button with action handler
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                print("Ok button tapped")
            })
            
            //Add OK button to a dialog message
            dialogMessage.addAction(ok)
            // Present Alert to
            self.present(dialogMessage, animated: true, completion: nil)
        } else {
        
        let homeViewController = storyboard?.instantiateViewController(identifier: "RecordDreamsViewController") as? RecordDreamsViewController
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
        }
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
