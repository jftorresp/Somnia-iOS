//
//  SignUpTwoViewController.swift
//  Somnia
//
//  Created by Juan Felipe Torres on 26/10/20.
//

import UIKit
import Firebase

class SignUpTwoViewController: UIViewController {
    
    @IBOutlet weak var signUpView: UIView!
    @IBOutlet weak var fullNameLabel: UITextField!
    @IBOutlet weak var nicknameLabel: UITextField!
    @IBOutlet weak var genderSegmentedControl: UISegmentedControl!
    @IBOutlet weak var ageLabel: UITextField!
    @IBOutlet weak var ocupationSegControl: UISegmentedControl!
    @IBOutlet weak var signUpButton: UIButton!
    
    let db = Firestore.firestore()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signUpView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        signUpView.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        signUpView.layer.shadowOpacity = 1.0
        signUpView.layer.shadowRadius = 0.0
        signUpView.layer.masksToBounds = false
        signUpView.layer.cornerRadius = signUpView.frame.size.width / 12
        
        signUpButton.layer.cornerRadius = 10.0
        
    }
    
    @IBAction func signUpPressed(_ sender: UIButton) {
        
        if  let fullName = fullNameLabel.text,
            let id = Auth.auth().currentUser?.uid,
            let nickname = nicknameLabel.text,
            let gender = genderSegmentedControl.titleForSegment(at: genderSegmentedControl.selectedSegmentIndex),
            let age = Int(ageLabel.text ?? "N/A"),
            let ocupation = ocupationSegControl.titleForSegment(at: ocupationSegControl.selectedSegmentIndex) {
            
            self.db.collection(K.FStore.usersCollection)
                .document(id)
                .updateData(["full name" : fullName, "nickname" : nickname, "gender" : gender, "age" : age, "ocupation" : ocupation  ]) { (error) in
                    if let e = error {
                        print("Error updating the user to the database, \(e.localizedDescription)")
                    } else {
                        print("Successfully updated data")
                    }
                }
        }
        
        self.performSegue(withIdentifier: K.Segues.registerToMenu, sender: self)
    }
    
}

