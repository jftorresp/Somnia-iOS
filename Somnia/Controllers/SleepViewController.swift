//
//  SleepViewController.swift
//  Somnia
//
//  Created by Juan Felipe Torres on 15/10/20.
//

import UIKit
import Firebase
import CoreLocation

class SleepViewController: UIViewController{
    
    @IBOutlet weak var sleepLabel: UILabel!
    @IBOutlet weak var sleepButton: UIButton!
    @IBOutlet weak var sleepView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var timeLabel: UILabel!
    var label = UILabel()
    
    var alarms = [String]()
    let db = Firestore.firestore()
    
    let locationManager = CLLocationManager()
    static var currentLocation : CLLocation!
    var latactual: Double?
    var lonactual: Double?
    var nickname = ""
    
        
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("Esta es la closest en sleep view: \(AlarmsNewUserViewController.closest)")
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm a" // "a" prints "pm" or "am"
        
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        
        if(AlarmsNewUserViewController.closest.description != "not") {
            let hourString = formatter.string(from:AlarmsNewUserViewController.closest.alarm_date)
            
            sleepLabel.text = "You have an alarm set up at "
            
            timeLabel.text = hourString
            timeLabel.textColor = UIColor.white
            timeLabel.font = UIFont(name: "HaboroSoft-NorBol", size: 40.0)
            sleepView.isHidden = true
        }
        

    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        print("Esta es la closest en sleep view: \(AlarmsNewUserViewController.closest)")
        
        if(AlarmsNewUserViewController.closest.description == "not"){
            sleepView.isHidden = false

        }
            
            sleepButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            sleepButton.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
            sleepButton.layer.shadowOpacity = 1.0
            sleepButton.layer.shadowRadius = 0.0
            sleepButton.layer.masksToBounds = false
            sleepButton.layer.cornerRadius = sleepButton.frame.size.width / 12
            
            sleepView.layer.cornerRadius = 12
            imageView.layer.cornerRadius = 12
            datePicker.layer.cornerRadius = 12
            datePicker.setValue(UIColor(named: K.BrandColors.green), forKeyPath: "textColor")
            
            sleepView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.15).cgColor
            sleepView.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
            sleepView.layer.shadowOpacity = 1.0
            sleepView.layer.shadowRadius = 0.0
            sleepView.layer.masksToBounds = false
    
    }
    
    func goToSleep()
    {
        let sleepTwoVC = storyboard?.instantiateViewController(identifier: K.sleepTwoVC) as? SleepTwoViewController
        
        view.window?.rootViewController = sleepTwoVC
        view.window?.makeKeyAndVisible()
    }
    
    @IBAction func sleepPressed(_ sender: UIButton) {
        print("Entré al botón de la alerta")
        if abs(AlarmsNewUserViewController.user!.lat-latactual!)>0 || abs(AlarmsNewUserViewController.user!.lon-lonactual!)>0{
           
            let dialogMessage = UIAlertController(title: "You don't seem to be at home", message: "Are you sure that you want to start a sleep analysis?", preferredStyle: .alert)
            let wait = UIAlertAction(title: "Let's wait", style: .default, handler: { (action) -> Void in
                print("Great button tapped")})
            let ok = UIAlertAction(title: "Yes, go!", style: .default, handler: { (action) -> Void in self.goToSleep()})
            //Add OK button to a dialog message
            dialogMessage.addAction(wait)
            dialogMessage.addAction(ok)
            // Present Alert to
            self.present(dialogMessage, animated: true, completion: nil)
            
        }
        else{
            goToSleep()
        }
        
    }
}
extension SleepViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        latactual = locValue.latitude
        lonactual = locValue.longitude
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
}
