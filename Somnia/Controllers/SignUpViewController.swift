//
//  ViewController.swift
//  Somnia
//
//  Created by Juan Felipe Torres on 23/09/20.
//

import UIKit

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPassTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.layer.cornerRadius = 10
        passwordTextField.layer.cornerRadius = 10
        repeatPassTextField.layer.cornerRadius = 10
        signUpButton.layer.cornerRadius = 10
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func signUpPressed(_ sender: UIButton) {
        
    }
}

