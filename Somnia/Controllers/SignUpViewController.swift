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
    @IBOutlet weak var verticalStackView: UIStackView!
    
    // Network
    
    let networkMonitor = NetworkMonitor()
    
    // Firestore
    
    let db = Firestore.firestore()
    
    // Validations labels
    
    let emailLabel = UILabel()
    let passwordLabel = UILabel()
    let password2Label = UILabel()
    let repeatEmailLabel = UILabel()
    
    var exists = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        networkMonitor.startMonitoring()
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        repeatPassTextField.delegate = self
        
        emailTextField.tag = 0
        passwordTextField.tag = 1
        repeatPassTextField.tag = 2
        
        emailTextField.layer.cornerRadius = 10
        passwordTextField.layer.cornerRadius = 10
        repeatPassTextField.layer.cornerRadius = 10
        signUpButton.layer.cornerRadius = 10
        
    }
    
    @IBAction func signUpPressed(_ sender: UIButton) {
        
        networkMonitor.startMonitoring()
        
        emailLabel.text = ""
        passwordLabel.text = ""
        password2Label.text = ""
        repeatEmailLabel.text = ""
        
        
        if let email = emailTextField.text, let password = passwordTextField.text, let password2 = repeatPassTextField.text {
            
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
                if validations(email, password, password2) == 3 {
                    Auth.auth().createUser(withEmail: email, password: password) { [self] authResult, error in
                        if let e = error{
                            // Should be a pop-up or message to the user
                            let err = e as NSError
                            switch err.code {
                            case AuthErrorCode.emailAlreadyInUse.rawValue:
                                repeatEmailLabel.text = "Email already in use"
                                repeatEmailLabel.textColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
                                repeatEmailLabel.font = UIFont(name: "HaboroSoft-NorLig",size: 13.0)
                                verticalStackView.insertArrangedSubview(repeatEmailLabel, at: 3)
                            default:
                                print(e.localizedDescription)
                            }
                        } else {
                            // Navigate to the Alarms view controller
                            
                            if let emailPersisted = Auth.auth().currentUser?.email, let id = Auth.auth().currentUser?.uid, let latitude = LoginViewController.lat, let longitude = LoginViewController.lon {
                                self.db.collection(K.FStore.usersCollection)
                                    .document(id)
                                    .setData([K.FStore.userKey : emailPersisted, K.FStore.lat: latitude, K.FStore.lon: longitude]) { (error) in
                                        if let e = error {
                                            print(e.localizedDescription)
                                            
                                        } else {
                                            print("Successfully saved data")
                                            transitionToHome()
                                        }
                                    }
                            }
                        }
                    }
                }
            }
        }
    }
    
    //MARK: - Validation of the email and password
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func isValidPassword(_ password: String) -> Bool {
        let passwordRegex = "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])[0-9a-zA-Z!@#$%^&*()\\-_=+{}|?>.<,:;~`’]{8,}$"
        let passPred = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passPred.evaluate(with: password)
    }
    
    func equalPasswords(_ pass1: String, _ pass2: String) -> Bool {
        var equal = false
        if pass1 == pass2 {
            equal = true
        }
        return equal
    }
    
    func validations(_ email: String, _ password: String, _ password2: String ) -> Int {
        var count = 0
        
        if isValidEmail(email) == true{
            count += 1
        } else {
            emailLabel.text = "The email entered is not valid"
            emailLabel.textColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
            emailLabel.font = UIFont(name: "HaboroSoft-NorLig",size: 13.0)
            verticalStackView.insertArrangedSubview(emailLabel, at: 3)
        }
        
        if isValidPassword(password) == true {
            count += 1
        } else {
            passwordLabel.text = "The password must have at least 8 characters,\n a number, a capital letter and special character"
            passwordLabel.numberOfLines = 2
            passwordLabel.textColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
            passwordLabel.font = UIFont(name: "HaboroSoft-NorLig",size: 13.0)
            verticalStackView.insertArrangedSubview(passwordLabel, at: 3)
        }
        
        if equalPasswords(password, password2) == true {
            count += 1
        } else {
            password2Label.text = "The passwords are not equal"
            password2Label.textColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
            password2Label.font = UIFont(name: "HaboroSoft-NorLig",size: 13.0)
            verticalStackView.insertArrangedSubview(password2Label, at: 3)
        }
        
        return count
    }
    
    //MARK: - Transition to Alarms View
    
    func transitionToHome() {
        
        let homeViewController = storyboard?.instantiateViewController(identifier: K.signUpVC) as? SignUpTwoViewController
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }
}

//MARK: - SignUpViewController TextFieldDelegate

extension SignUpViewController: UITextFieldDelegate {
    
    //Funciones que permite el protocolo de UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            // Not found, so remove keyboard.
            textField.resignFirstResponder()
        }
        
        return true
    }
}
