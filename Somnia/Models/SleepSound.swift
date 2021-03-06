//
//  SleepSound.swift
//  Somnia
//
//  Created by Juan Felipe Torres on 5/11/20.
//

import Foundation
import AVFoundation

class SleepSound {
    let name: String
    let fileName: String
    let image: String
    let description: String
    let duration: Int
    var audio: AVAudioPlayer?
    
    init(n: String, f: String, img: String, d: String, dur: Int, a: AVAudioPlayer?) {
        name = n
        fileName = f
        image = img
        description = d
        duration = dur
        audio = a
    }
}
