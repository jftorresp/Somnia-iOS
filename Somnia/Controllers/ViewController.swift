//
//  ViewController.swift
//  Somnia
//
//  Created by Juan Felipe Torres on 23/09/20.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var facebookButton: UIButton!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.layer.cornerRadius = 10
        facebookButton.layer.cornerRadius = 10
        emailTextField.layer.cornerRadius = 10
        passwordTextField.layer.cornerRadius = 10
        
        // Do any additional setup after loading the view.
    }
    
//    override func viewDidLayoutSubviews() {
//        view.setGradientBackground(colorOne: UIColor(named: K.BrandColors.darkBlue)!, colorTwo: UIColor(named: K.BrandColors.blue)!)
//    }
    
    
    @IBAction func loginPressed(_ sender: UIButton) {
    }
    
    @IBAction func loginFbPressed(_ sender: UIButton) {
    }
    

}

