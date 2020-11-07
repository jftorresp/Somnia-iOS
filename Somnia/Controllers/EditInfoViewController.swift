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
    
    let transparentView = UIView()
    let tableView = UITableView()
    var selectedButton = UIButton()
        
    let db = Firestore.firestore()
    
    var dataSource = [String]()
        
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    }
    
    
    @IBAction func cancelAction(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func confirmAction(_ sender: UIBarButtonItem) {
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


