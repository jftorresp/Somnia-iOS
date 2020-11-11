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
    
    // Profile Basic Info Outlets
    
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var occupationLabel: UILabel!
    
    // Scroll
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    override func viewDidLayoutSubviews() {
        self.scrollView.contentSize = self.view.frame.size
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    static var nick:String=""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        helloNicknameLabel.text = "Hello \(AlarmsNewUserViewController.user?.nickname ?? "Hello")"+"!"
        
        guard let editVC = self.storyboard?.instantiateViewController(withIdentifier: "EditInfo") as? EditInfoViewController else { return }
        editVC.callbackClosure = { [weak self] in
            self?.helloNicknameLabel.text = "Hello \(AlarmsNewUserViewController.user?.nickname ?? "Hello")"+"!"
        }
        
        award1View.layer.cornerRadius = 15
        award2View.layer.cornerRadius = 15
        log1View.layer.cornerRadius = 15
        log2View.layer.cornerRadius = 15
        profileInfoView.layer.cornerRadius = 15
        profileBannerView.layer.cornerRadius = 15
        profileBannerImage.layer.cornerRadius = 15
        
        // Set basic info
        
        fullNameLabel.text = AlarmsNewUserViewController.user?.fullname
        nicknameLabel.text = AlarmsNewUserViewController.user?.nickname
        ageLabel.text = String(AlarmsNewUserViewController.user?.age ?? 0)
        genderLabel.text = AlarmsNewUserViewController.user?.gender
        occupationLabel.text = AlarmsNewUserViewController.user?.occupation
    }
    
    override func viewDidAppear(_ animated: Bool) {
        helloNicknameLabel.text = "Hello \(AlarmsNewUserViewController.user?.nickname ?? "Hello")"+"!"
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
        guard let editVC = self.storyboard?.instantiateViewController(withIdentifier: "EditInfo") as? EditInfoViewController else { return }
        editVC.callbackClosure = { [weak self] in
            self?.helloNicknameLabel.text = "Hello \(AlarmsNewUserViewController.user?.nickname ?? "Hello")"+"!"
            
            // Set basic info
            
            self?.fullNameLabel.text = AlarmsNewUserViewController.user?.fullname
            self?.nicknameLabel.text = AlarmsNewUserViewController.user?.nickname
            self?.ageLabel.text = String(AlarmsNewUserViewController.user?.age ?? 0)
            self?.genderLabel.text = AlarmsNewUserViewController.user?.gender
            self?.occupationLabel.text = AlarmsNewUserViewController.user?.occupation
        }
        present(editVC, animated: true, completion: nil)
    }
}
