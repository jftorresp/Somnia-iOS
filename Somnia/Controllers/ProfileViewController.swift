//
//  ProfileViewController.swift
//  Somnia
//
//  Created by Juan Felipe Torres on 16/10/20.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var award1View: UIView!
    @IBOutlet weak var award2View: UIView!
    @IBOutlet weak var log1View: UIView!
    @IBOutlet weak var log2View: UIView!
    @IBOutlet weak var profileInfoView: UIView!
    @IBOutlet weak var profileBannerView: UIView!
    @IBOutlet weak var profileBannerImage: UIImageView!
    @IBOutlet weak var helloNicknameLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let nickname = UserDefaults.standard.object(forKey: "nickname") {
            helloNicknameLabel.text = "Hello \(nickname)!"
        }
        
        award1View.layer.cornerRadius = 15
        award2View.layer.cornerRadius = 15
        log1View.layer.cornerRadius = 15
        log2View.layer.cornerRadius = 15
        profileInfoView.layer.cornerRadius = 15
        profileBannerView.layer.cornerRadius = 15
        profileBannerImage.layer.cornerRadius = 15
    }
    
    @IBAction func logOutPressed(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()
            
            if Auth.auth().currentUser == nil {
                if let loginVC = storyboard?.instantiateViewController(identifier: K.loginVC) as? LoginViewController {
                    
                    UserDefaults.standard.removeObject(forKey: "user_uid_key")
                    UserDefaults.standard.synchronize()
                    UserDefaults.standard.removeObject(forKey: "nickname")
                    UserDefaults.standard.synchronize()
                    view.window?.rootViewController = loginVC
                    view.window?.makeKeyAndVisible()
                }
            }
        } catch  {
            print("Unable to log out")
            
        }
    }
}
