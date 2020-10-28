//
//  ViewController.swift
//  Somnia
//
//  Created by Juan Felipe Torres on 23/09/20.
//

import UIKit
import Firebase
import FBSDKLoginKit
import CoreLocation

class LoginViewController: UIViewController {
    
    // Outlets
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var verticalStackView: UIStackView!
    @IBOutlet weak var fbButton: UIButton!
    @IBOutlet weak var errorStackView: UIStackView!
    
    // Network
    
    let networkMonitor = NetworkMonitor()
    
    // Error labels
    
    let invalidEmailLabel = UILabel()
    let passwordLabel = UILabel()
    let difCredLabel = UILabel()
    let emailUsedLabel = UILabel()
    let otherErrorLabel = UILabel()
    
    // Firestore
    
    let db = Firestore.firestore()
    
    // Location
    
    let locationManager = CLLocationManager()
    static var currentLocation : CLLocation!
    static var lat: Double?
    static var lon: Double?
    
    // Set status bar to white
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        // Check if the user is logged in
        if UserDefaults.standard.object(forKey: "user_uid_key") != nil {
            // send them to a new view controller or do whatever you want
            let homeViewController = storyboard?.instantiateViewController(identifier: K.tabBar) as? UITabBarController
            
            view.window?.rootViewController = homeViewController
            view.window?.makeKeyAndVisible()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        loginButton.layer.cornerRadius = 10
        fbButton.layer.cornerRadius = 10
        emailTextField.layer.cornerRadius = 10
        passwordTextField.layer.cornerRadius = 10
        
        emailTextField.tag = 0
        passwordTextField.tag = 1
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        // Display pop-out to user to allow use of location
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
    }
    
    
    @IBAction func loginPressed(_ sender: UIButton) {
        
        networkMonitor.startMonitoring()
        
        invalidEmailLabel.text = ""
        passwordLabel.text = ""
        difCredLabel.text = ""
        emailUsedLabel.text = ""
        otherErrorLabel.text = ""
        
        if let email = emailTextField.text, let password = passwordTextField.text {
            
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
                Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                    if let e = error {
                        
                        let err = e as NSError
                        switch err.code {
                        case AuthErrorCode.wrongPassword.rawValue:
                            self.addErrorLabel(self.passwordLabel, "Wrong password")
                        case AuthErrorCode.invalidEmail.rawValue:
                            self.addErrorLabel(self.invalidEmailLabel, "Invalid email")
                        case AuthErrorCode.accountExistsWithDifferentCredential.rawValue:
                            self.addErrorLabel(self.difCredLabel, "accountExistsWithDifferentCredential")
                        case AuthErrorCode.emailAlreadyInUse.rawValue: //<- Your Error
                            self.addErrorLabel(self.emailUsedLabel, "The email is alreay in use")
                        default:
                            self.addErrorLabel(self.otherErrorLabel, err.localizedDescription)
                        }
                    } else {
                        // Navigate to Alarms view controller
                        self.transitionToHome()
                        UserDefaults.standard.set(Auth.auth().currentUser!.uid, forKey: "user_uid_key")
                        UserDefaults.standard.synchronize()
                    }
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
                        
                        if let emailPersisted = Auth.auth().currentUser?.email, let id = Auth.auth().currentUser?.uid {
                            self.db.collection(K.FStore.usersCollection)
                                .document(id)
                                .setData([K.FStore.userKey : emailPersisted]) { (error) in
                                    if let e = error {
                                        print("Error adding the user to the database, \(e.localizedDescription)")
                                    } else {
                                        print("Successfully saved data")
                                    }
                                }
                            
                        }
                        self.transitionToHome()
                    }
                }
                
            case .cancelled:
                break
            case .failed(_):
                break
            }
        }
    }
    
    func addErrorLabel(_ label: UILabel, _ content: String) {
        
        label.text = content
        label.textColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        label.font = UIFont(name: "HaboroSoft-NorLig",size: 13.0)
        errorStackView.insertArrangedSubview(label, at: 3)
    }
    
    func transitionToHome() {
        
        let homeViewController = storyboard?.instantiateViewController(identifier: K.tabBar) as? UITabBarController
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }
    
}

//MARK: - LoginViewController TextFieldDelegate

extension LoginViewController: UITextFieldDelegate {
    
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

extension LoginViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        LoginViewController.lat = locValue.latitude
        LoginViewController.lon = locValue.longitude
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
}





