//
//  ViewController.swift
//  Somnia
//
//  Created by Juan Felipe Torres on 23/09/20.
//

import UIKit
import Firebase
import CoreLocation

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPassTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var verticalStackView: UIStackView!
    
    let db = Firestore.firestore()
    let emailLabel = UILabel()
    let passwordLabel = UILabel()
    let password2Label = UILabel()
    let repeatEmailLabel = UILabel()
    
    let locationManager = CLLocationManager()
    var currentLocation : CLLocation!
    var lat: Double?
    var lon: Double?
    
    var exists = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        locationManager.delegate = self
        // Display pop-out to user to allow use of location
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
                CLLocationManager.authorizationStatus() ==  .authorizedAlways) {
            
            currentLocation = locationManager.location
            lat = Double(currentLocation.coordinate.latitude)
            lon = Double(currentLocation.coordinate.longitude)
        }
        
    }
    
    @IBAction func signUpPressed(_ sender: UIButton) {
        
        emailLabel.text = ""
        passwordLabel.text = ""
        password2Label.text = ""
        
        if let email = emailTextField.text, let password = passwordTextField.text, let password2 = repeatPassTextField.text {
            
            if validations(email, password, password2) == 3 {
                Auth.auth().createUser(withEmail: email, password: password) { [self] authResult, error in
                    if let e = error{
                        // Should be a pop-up or message to the user
                        print("Error creating the user, \(e.localizedDescription)")
                    } else {
                        // Navigate to the Alarms view controller
                        if let emailPersisted = Auth.auth().currentUser?.email, let id = Auth.auth().currentUser?.uid, let latitude = lat, let longitude = lon {
                            self.db.collection(K.FStore.usersCollection)
                                .document(id)
                                .setData([K.FStore.userKey : emailPersisted, K.FStore.lat: latitude, K.FStore.lon: longitude]) { (error) in
                                    if let e = error {
                                        print("Error adding the user to the database, \(e.localizedDescription)")
                                    } else {
                                        print("Successfully saved data")
                                    }
                                }
                        }
                    }
                }
                transitionToHome()
            }
        }
    }
    
    //MARK: - Validation of the email and password
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func isPasswordValid(_ password : String) -> Bool{
        if(password.count > 7 && password.count < 17) {
        } else {
            return false
        }
        let nonUpperCase = CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZ").inverted
        let letters = password.components(separatedBy: nonUpperCase)
        let strUpper: String = letters.joined()
        
        let smallLetterRegEx  = ".*[a-z]+.*"
        let samlltest = NSPredicate(format:"SELF MATCHES %@", smallLetterRegEx)
        let smallresult = samlltest.evaluate(with: password)
        
        let numberRegEx  = ".*[0-9]+.*"
        let numbertest = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
        let numberresult = numbertest.evaluate(with: password)
        
        let regex = try! NSRegularExpression(pattern: ".*[^A-Za-z0-9].*", options: NSRegularExpression.Options())
        var isSpecial :Bool = false
        if regex.firstMatch(in: password, options: NSRegularExpression.MatchingOptions(), range:NSMakeRange(0, password.count)) != nil {
            print("could not handle special characters")
            isSpecial = true
        }else{
            isSpecial = false
        }
        return (strUpper.count >= 1) && smallresult && numberresult && isSpecial
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
        
        if isPasswordValid(password) == true {
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

extension SignUpViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
}
