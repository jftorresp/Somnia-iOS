//
//  ViewController.swift
//  Somnia
//
//  Created by Juan Felipe Torres on 23/09/20.
//

import UIKit
import Firebase
import FBSDKLoginKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var verticalStackView: UIStackView!
    @IBOutlet weak var fbButton: UIButton!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        loginButton.layer.cornerRadius = 10
        fbButton.layer.cornerRadius = 10
        emailTextField.layer.cornerRadius = 10
        passwordTextField.layer.cornerRadius = 10
        
    
        // Do any additional setup after loading the view.
    }
    
    //    override func viewDidLayoutSubviews() {
    //        view.setGradientBackground(colorOne: UIColor(named: K.BrandColors.darkBlue)!, colorTwo: UIColor(named: K.BrandColors.blue)!)
    //    }
    
    
    @IBAction func loginPressed(_ sender: UIButton) {
        
        if let email = emailTextField.text, let password = passwordTextField.text {
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
                if let e = error {
                    print("Error login the user, \(e.localizedDescription)")
                } else {
                    // Navigate to Alarms view controller
                    self?.performSegue(withIdentifier: "LoginToMenu", sender: self)
                }
                
            }
        }
    }
    
    
    @IBAction func fbButtonPressed(_ sender: UIButton) {
        
        let loginManager = LoginManager()
        loginManager.logOut()
        loginManager.logIn(permissions: [.email], viewController: self) { (result) in
            
            switch result {
            
            case .success(granted: let granted, declined: let declined, token: let token):
                
                let credential = FacebookAuthProvider.credential(withAccessToken: token.tokenString)
                
                Auth.auth().signIn(with: credential) { (result, error) in
                    if let e = error {
                        print(e)
                    } else {
                        self.performSegue(withIdentifier: "LoginToMenu", sender: self)
                        // loginManager.logOut()
                    }
                }
                
            case .cancelled:
                break
            case .failed(_):
                break
            }
        }
    }
}

