//
//  SignUpTwoViewController.swift
//  Somnia
//
//  Created by Juan Felipe Torres on 26/10/20.
//

import UIKit
import Firebase

class CellClass: UITableViewCell {
    
}

class SignUpTwoViewController: UIViewController {
    
    @IBOutlet weak var signUpView: UIView!
    @IBOutlet weak var fullNameLabel: UITextField! {
        didSet {
            let grayPlaceholderText = NSAttributedString(string: "Full Name",
                                                        attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
            
            fullNameLabel.attributedPlaceholder = grayPlaceholderText
        }
    }
    @IBOutlet weak var nicknameLabel: UITextField! {
        didSet {
            let grayPlaceholderText = NSAttributedString(string: "Nickname",
                                                        attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
            
            nicknameLabel.attributedPlaceholder = grayPlaceholderText
        }
    }
    @IBOutlet weak var ageLabel: UITextField! {
        didSet {
            let grayPlaceholderText = NSAttributedString(string: "Age",
                                                        attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
            
            ageLabel.attributedPlaceholder = grayPlaceholderText
        }
    }
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var genderDropDown: UIButton!
    @IBOutlet weak var occupationDropDown: UIButton!
    
    let transparentView = UIView()
    let tableView = UITableView()
    var selectedButton = UIButton()
    
    // Network
    
    let networkMonitor = NetworkMonitor()
        
    let db = Firestore.firestore()
    
    var dataSource = [String]()
        
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        networkMonitor.startMonitoring()
                
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CellClass.self, forCellReuseIdentifier: "Cell")
        
        fullNameLabel.delegate = self
        nicknameLabel.delegate = self
        ageLabel.delegate = self
        
        fullNameLabel.tag = 0
        nicknameLabel.tag = 1
        ageLabel.tag = 2
        
        signUpView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        signUpView.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        signUpView.layer.shadowOpacity = 1.0
        signUpView.layer.shadowRadius = 0.0
        signUpView.layer.masksToBounds = false
        signUpView.layer.cornerRadius = signUpView.frame.size.width / 12
        
        signUpButton.layer.cornerRadius = 10.0
        genderDropDown.layer.cornerRadius = 10
        occupationDropDown.layer.cornerRadius = 10
    }
    
    @IBAction func signUpPressed(_ sender: UIButton) {
        
        networkMonitor.startMonitoring()

        
        
        if  let fullName = fullNameLabel.text,
            let id = Auth.auth().currentUser?.uid,
            let nickname = nicknameLabel.text,
            let gender = genderDropDown.titleLabel?.text,
            let age = Int(ageLabel.text ?? "N/A"),
            let occupation = occupationDropDown.titleLabel?.text {
            
            
            if NetworkMonitor.connected == false {
                let dialogMessage = UIAlertController(title: "No connection", message: "It seems that you don´t have connection, try again later.", preferredStyle: .alert)
                
                // Create OK button with action handler
                let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                    print("Ok button tapped")
                })
                
                //Add OK button to a dialog message
                dialogMessage.addAction(ok)
                // Present Alert to
                self.present(dialogMessage, animated: true, completion: nil)
            } else {
                self.db.collection(K.FStore.usersCollection)
                    .document(id)
                    .updateData(["fullname" : fullName, "nickname" : nickname, "gender" : gender, "age" : age, "occupation" : occupation  ]) { (error) in
                        if let e = error {
                            print("Error updating the user to the database, \(e.localizedDescription)")
                        } else {
                            print("Successfully updated data")
                            UserDefaults.standard.set(nickname, forKey: "nickname")
                            UserDefaults.standard.synchronize()
                            self.transitionToHome()
                        }
                    }
            }
            

        }
        
    }
    
    func transitionToHome() {
        
        let homeViewController = storyboard?.instantiateViewController(identifier: K.tabBar) as? UITabBarController
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }
    
    @IBAction func genderPressed(_ sender: Any) {
        dataSource = ["Male", "Female", "Genderqueer/Non-binary", "Other", "Prefer not to disclose"]
        selectedButton = genderDropDown
        addTransparentView(frames: genderDropDown.frame)
    }
    
    @IBAction func occupationPressed(_ sender: Any) {
        dataSource = ["Student", "Worker", "Independent", "Unemployed", "Other"]
        selectedButton = occupationDropDown
        addTransparentView(frames: occupationDropDown.frame)
    }
    
    func addTransparentView(frames: CGRect) {
        
        transparentView.frame = view.window?.frame ?? self.view.frame
        signUpView.addSubview(transparentView)
        
        tableView.frame = CGRect(x: frames.origin.x + 20 , y: frames.origin.y + frames.height, width: frames.width, height: 0)
        signUpView.addSubview(tableView)
        tableView.layer.cornerRadius = 10
        
        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0)
        tableView.reloadData()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(removeTransparentView))
        transparentView.addGestureRecognizer(tapGesture)
        
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0.5
            self.tableView.frame = CGRect(x: frames.origin.x + 20, y: frames.origin.y + frames.height + 10, width: frames.width, height: 200)
        }, completion: nil)
    }
    
    @objc func removeTransparentView() {
        let frames = selectedButton.frame
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0
            self.tableView.frame = CGRect(x: frames.origin.x + 20, y: frames.origin.y + frames.height + 10, width: frames.width, height: 0)
        }, completion: nil)
    }
}

extension SignUpTwoViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = dataSource[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedButton == genderDropDown {
            genderDropDown.setTitle(dataSource[indexPath.row], for: .normal)

        }
        if selectedButton == occupationDropDown {
            occupationDropDown.setTitle(dataSource[indexPath.row], for: .normal)
        }
        removeTransparentView()
    }
    
}

//MARK: - SignUpTwoViewController TextFieldDelegate

extension SignUpTwoViewController: UITextFieldDelegate {
    
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

