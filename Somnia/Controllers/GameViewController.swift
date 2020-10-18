//
//  GameViewController.swift
//  Somnia
//
//  Created by Nicolas Cobos on 18/10/20.
//

import Foundation
import UIKit
import Firebase

class GameViewController: UIViewController{
    
    var gameActive = false
    var score = 0
    var timeOfLastShake = 0
    var timer = Timer()
    var timerCountDown : Timer!
    var scoreGame = 0
    
    @IBOutlet weak var countDownLabel: UILabel!
    var count = 15

    override func viewDidLoad() {
        super.viewDidLoad()
        countDownLabel.text = String(count)
        timerCountDown = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)

    }

    func update() {
        if(count > 0) {
            count-=1
            countDownLabel.text = String(count)
        }
    }
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    override var canBecomeFirstResponder: Bool {
    get {
        return true
        }
    }
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
       print(motion)
       if motion == .motionShake {
          print("shake was detected")
        scoreGame = scoreGame+1
        scoreLabel.text = String(scoreGame)
       }
    }
    
    func startTimer(){
    timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateScore), userInfo: nil, repeats: true)
    }
    var a = ""
    @objc func updateScore(){
    score += 1
    scoreLabel.text = String(score)
    let timeSinceLastShake = score - timeOfLastShake
    switch timeSinceLastShake {
    case 1:
        a="q"
    //messageLabel.text = "Great Job!"
    case 2:
        a="q"
    //messageLabel.text = "Hurry Up!"
    case 3:
        a="q"
    //messageLabel.text = "That's Too Slow!"
    default:
    gameActive = false
    score = 0
    timeOfLastShake = 0
   // messageLabel.text = "Game Over! Shake to Play Again."
    timer.invalidate()
    timer = Timer()
    }
    }
    
    @objc func fireTimer() {
        if(count > 0) {
        count = count-1
        countDownLabel.text = String(count)
        }
    }
}
