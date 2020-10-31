//
//  FeedbackViewController.swift
//  Somnia
//
//  Created by Juan Felipe Torres on 30/10/20.
//

import UIKit
import Firebase

class FeedbackViewController: UIViewController {
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var badIconButton: UIButton!
    @IBOutlet weak var medIconButton: UIButton!
    @IBOutlet weak var goodIconButton: UIButton!
    
    let db = Firestore.firestore()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        badIconButton.layer.cornerRadius = 10
        medIconButton.layer.cornerRadius = 10
        goodIconButton.layer.cornerRadius = 10
        
        scoreLabel.text = "\(GameViewController.scoreGame) pts."
        // Do any additional setup after loading the view.
    }
    
    @IBAction func goodMoodPressed(_ sender: UIButton) {
        sendScoreDB(mood: "GOOD")
        let homeViewController = storyboard?.instantiateViewController(identifier: K.tabBar) as? UITabBarController
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }
    
    @IBAction func medMoodPressed(_ sender: UIButton) {
        sendScoreDB(mood: "GRUMPY")
        let homeViewController = storyboard?.instantiateViewController(identifier: K.tabBar) as? UITabBarController
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }
    
    @IBAction func badMoodPressed(_ sender: UIButton) {
        sendScoreDB(mood: "BAD")
        let homeViewController = storyboard?.instantiateViewController(identifier: K.tabBar) as? UITabBarController
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }
    
    func sendScoreDB(mood: String) {
        
        if let id = Auth.auth().currentUser?.uid{
            db.collection(K.FStore.analysisCollection).addDocument(data: ["createdBy": id, "deep": 0, "duration": 0, "hourStage": ["1": "", "2": ""], "light": 0, "nightDate": Date(), "rem": 0, "snorePercentage": 0, "totalEvents": 0, "totalSnores": 0, "wake": 0, "score": GameViewController.scoreGame, "mood": mood]) { (error) in
                
                if let e = error {
                    print("Error adding the score to the user analysis, \(e.localizedDescription)")
                } else {
                    print("Successfully saved score data")
                }
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
