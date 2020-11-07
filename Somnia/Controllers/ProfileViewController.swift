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
    @IBOutlet weak var editButton: UIButton!
    
    static var nick:String=""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let salute = "Hello \(UserDefaults.standard.string(forKey: "nickname") ?? "Hello")"+"!"
        print("El salute es \(salute)")
        helloNicknameLabel!.text = salute
        
        
        award1View.layer.cornerRadius = 15
        award2View.layer.cornerRadius = 15
        log1View.layer.cornerRadius = 15
        log2View.layer.cornerRadius = 15
        profileInfoView.layer.cornerRadius = 15
        profileBannerView.layer.cornerRadius = 15
        profileBannerImage.layer.cornerRadius = 15
    }
    
    override func viewDidAppear(_ animated: Bool) {
        helloNicknameLabel.text = "Hello \(UserDefaults.standard.string(forKey: "nickname") ?? "Hello")"+"!"
    }
   
    
    @IBAction func logOutPressed(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()
            
            if Auth.auth().currentUser == nil {
                if let loginVC = storyboard?.instantiateViewController(identifier: K.loginVC) as? LoginViewController {
                    
                    UserDefaults.standard.removeObject(forKey: "user_uid_key")
                    UserDefaults.standard.synchronize()
                    view.window?.rootViewController = loginVC
                    view.window?.makeKeyAndVisible()
                }
            }
        } catch  {
            print("Unable to log out")
            
        }
    }
    
    
    @IBAction func editAction(_ sender: UIButton) {
    }
}
