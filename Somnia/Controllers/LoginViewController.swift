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
    @IBOutlet weak var errorStackView: UIStackView!
    
    let db = Firestore.firestore()
    
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
                    
                    self?.loginButton.isEnabled = false
                    
                    let err = e as NSError
                    switch err.code {
                    case AuthErrorCode.wrongPassword.rawValue:
                        self?.addErrorLabel("Wrong password")
                    case AuthErrorCode.invalidEmail.rawValue:
                        self?.addErrorLabel("Invalid email")
                    case AuthErrorCode.accountExistsWithDifferentCredential.rawValue:
                        self?.addErrorLabel("accountExistsWithDifferentCredential")
                    case AuthErrorCode.emailAlreadyInUse.rawValue: //<- Your Error
                        self?.addErrorLabel("The email is alreay in use")
                    default:
                        self?.addErrorLabel(err.localizedDescription)
                    }
                } else {
                    // Navigate to Alarms view controller
                    self?.performSegue(withIdentifier: K.Segues.loginToMenu, sender: self)
                }
                
            }
        }
    }
        
    @IBAction func fbButtonPressed(_ sender: UIButton) {
        
        
        let loginManager = LoginManager()
        loginManager.logOut()
        loginManager.logIn(permissions: [.email], viewController: self) { (result) in
            
            switch result {
            
            case .success(granted: _, declined: _, token: let token):
                
                let credential = FacebookAuthProvider.credential(withAccessToken: token.tokenString)
                
                Auth.auth().signIn(with: credential) { (result, error) in
                    if let e = error {
                        print("Error with Facebook login, \(e.localizedDescription)")
                    } else {
//                        self.performSegue(withIdentifier: K.Segues.loginToMenu, sender: self)
                        if let emailPersisted = Auth.auth().currentUser?.email {
                            self.db.collection(K.FStore.usersCollection).addDocument(data: [K.FStore.userKey : emailPersisted]) { (error) in
                                if let e = error {
                                    print("Error adding the user to the database, \(e.localizedDescription)")
                                } else {
                                    print("Successfully saved data")
                                }
                            }
                        }
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
    
    
    
    func addErrorLabel(_ content: String) {
        let label = UILabel()
        
        label.text = content
        label.textColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        label.font = UIFont(name: "HaboroSoft-NorLig",size: 13.0)
        errorStackView.insertArrangedSubview(label, at: 3)
    }
    
}

