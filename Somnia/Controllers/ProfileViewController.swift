//
//  ProfileViewController.swift
//  Somnia
//
//  Created by Juan Felipe Torres on 15/10/20.
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        award1View.layer.cornerRadius = 15
        award2View.layer.cornerRadius = 15
        log1View.layer.cornerRadius = 15
        log2View.layer.cornerRadius = 15
        profileInfoView.layer.cornerRadius = 15
        profileBannerView.layer.cornerRadius = 15
        profileBannerImage.layer.cornerRadius = 15
        // Do any additional setup after loading the view.
        
//        let email = Auth.auth().currentUser?.email
//
//        let emailLabel = UILabel()
//        emailLabel.text = email
//        emailLabel.textColor = UIColor.white
//
//        profileInfoView.addSubview(emailLabel)
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
