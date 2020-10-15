//
//  ViewController.swift
//  Somnia
//
//  Created by Juan Felipe Torres on 23/09/20.
//

import UIKit
import Firebase

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
        
        if let email = emailTextField.text, let password = passwordTextField.text, let repeatPassword = repeatPassTextField.text {
            
            if password == repeatPassword {
                Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                    if let e = error{
                        // Should be a pop-up or message to the user
                        print("Error creating the user, \(e.localizedDescription)")
                    } else {
                        // Navigate to the Alarms view controller
                        self.performSegue(withIdentifier: "RegisterToMenu", sender: self)
                    }
                }
            } else {
                print("Passwords are not equal.")
            }
        }
    }
}

