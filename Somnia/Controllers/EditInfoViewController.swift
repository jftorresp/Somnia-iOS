//
//  EditInfoViewController.swift
//  Somnia
//
//  Created by Nicolas Cobos on 6/11/20.
//

import Foundation
import UIKit
import Firebase
import UserNotifications
import CoreLocation


class CellClass2: UITableViewCell {
    
}

class EditInfoViewController: UIViewController{
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    @IBOutlet weak var confirmButton: UIBarButtonItem!
    
    @IBOutlet weak var editView: UIView!
    @IBOutlet weak var nameTxt: UITextField! 
    @IBOutlet weak var nicknameTxt: UITextField!
    @IBOutlet weak var ageTxt: UITextField!
    @IBOutlet weak var occupationButton: UIButton!
    @IBOutlet weak var genderButton: UIButton!
    @IBOutlet weak var setHomeButton: UIButton!
    
    let transparentView = UIView()
    let tableView = UITableView()
    var selectedButton = UIButton()
    let networkMonitor = NetworkMonitor()
    
    let locationManager = CLLocationManager()
    static var currentLocation : CLLocation!
    static var lat: Double?
    static var lon: Double?
    
    var callbackClosure: (() -> Void)?
        
    let db = Firestore.firestore()
    
    var dataSource = [String]()
        
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        let usuario = AlarmsNewUserViewController.user
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CellClass2.self, forCellReuseIdentifier: "Cell")
        
        editView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        editView.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        editView.layer.shadowOpacity = 1.0
        editView.layer.shadowRadius = 0.0
        editView.layer.masksToBounds = false
        editView.layer.cornerRadius = editView.frame.size.width / 12
        
        genderButton.layer.cornerRadius = 10
        occupationButton.layer.cornerRadius = 10
        setHomeButton.layer.cornerRadius = 10
        
        nameTxt.text = usuario?.fullname
        nicknameTxt.text = usuario?.nickname
        ageTxt.text = String(usuario!.age)
        occupationButton.setTitle(usuario?.occupation, for: .normal)
        genderButton.setTitle(usuario?.gender, for: .normal)
        
        
    }
    
    @IBAction func cancelAction(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func confirmAction(_ sender: UIBarButtonItem) {
        
        if  let fullName = nameTxt.text,
            let id = Auth.auth().currentUser?.uid,
            let nicknameE = nicknameTxt.text,
            let gender = genderButton.titleLabel?.text,
            let age = Int(ageTxt.text ?? "N/A"),
            let occupation = occupationButton.titleLabel?.text {
            
            self.db.collection(K.FStore.usersCollection)
                .document(id)
                .updateData(["fullname" : fullName, "nickname" : nicknameE, "gender" : gender, "age" : age, "occupation" : occupation  ]) { (error) in
                    if let e = error {
                        print("Error updating the user to the database, \(e.localizedDescription)")
                    } else {
                        print("Successfully updated data")
                        AlarmsNewUserViewController.user?.nickname = nicknameE
                        AlarmsNewUserViewController.user?.fullname = fullName
                        AlarmsNewUserViewController.user?.age = age
                        AlarmsNewUserViewController.user?.occupation = occupation
                        AlarmsNewUserViewController.user?.gender = gender
                    }
                }
        }
       
        dismiss(animated: true) { [weak self] in
            self?.callbackClosure?()
        }

    }
    
    @IBAction func genderAction(_ sender: UIButton) {
        dataSource = ["Male", "Female", "Genderqueer/Non-binary", "Other", "Prefer not to disclose"]
        selectedButton = genderButton
        addTransparentView(frames: genderButton.frame)
    }
    
    @IBAction func occupationAction(_ sender: UIButton) {
        dataSource = ["Student", "Worker", "Independent", "Unemployed", "Other"]
        selectedButton = occupationButton
        addTransparentView(frames: occupationButton.frame)
    }
    
    func addTransparentView(frames: CGRect) {
        
        transparentView.frame = view.window?.frame ?? self.view.frame
        editView.addSubview(transparentView)
        
        tableView.frame = CGRect(x: frames.origin.x + 20 , y: frames.origin.y + frames.height, width: frames.width, height: 0)
        editView.addSubview(tableView)
        tableView.layer.cornerRadius = 10
        
        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0)
        tableView.reloadData()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(removeTransparentView))
        transparentView.addGestureRecognizer(tapGesture)
        
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0.5
            self.tableView.frame = CGRect(x: frames.origin.x + 20, y: frames.origin.y + frames.height + 10, width: frames.width, height: 180)
        }, completion: nil)
    }
    
    @objc func removeTransparentView() {
        let frames = selectedButton.frame
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0
            self.tableView.frame = CGRect(x: frames.origin.x + 20, y: frames.origin.y + frames.height + 10, width: frames.width, height: 0)
        }, completion: nil)
    }
    
    
    @IBAction func setHomeAction(_ sender: UIButton) {
        
        if  let id = Auth.auth().currentUser?.uid, let lat = EditInfoViewController.lat, let lon = EditInfoViewController.lon{
            self.db.collection(K.FStore.usersCollection)
                .document(id)
                .updateData(["lat" : lat , "lon" : lon  ]) { (error) in
                    if let e = error {
                        print("Error updating the user to the database, \(e.localizedDescription)")
                    } else {
                        print("Successfully updated data")
                        let dialogMessage = UIAlertController(title: "Location succesfully set!", message: "Now we'll double check when you start an sleep analysis when not at home.", preferredStyle: .alert)
                        let ok = UIAlertAction(title: "Great!", style: .default, handler: { (action) -> Void in
                            print("Great button tapped")
                        })
                        //Add OK button to a dialog message
                        dialogMessage.addAction(ok)
                        // Present Alert to
                        self.present(dialogMessage, animated: true, completion: nil)
                        
                    }
                }
        }
    }
}

extension EditInfoViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = dataSource[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedButton == genderButton {
            genderButton.setTitle(dataSource[indexPath.row], for: .normal)

        }
        if selectedButton == occupationButton {
            occupationButton.setTitle(dataSource[indexPath.row], for: .normal)
        }
        removeTransparentView()
    }
    
}
extension EditInfoViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        EditInfoViewController.lat = locValue.latitude
        EditInfoViewController.lon = locValue.longitude
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
}


