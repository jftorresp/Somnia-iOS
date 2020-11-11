//
//  User.swift
//  Somnia
//  Class that represents a user of the app
//  Created by Nicolas Cobos on 23/09/20.
//

import Foundation

class User {
    
    var email: String
    var age: Int
    var fullname: String
    var nickname: String
    var gender: String
    var occupation: String
    var lat: Double
    var lon: Double
    
    init(email user: String, a: Int, f: String, n: String, g: String, o: String, la: Double, lo: Double) {
        self.email = user
        age = a
        fullname = f
        nickname = n
        gender = g
        occupation = o
        lat = la
        lon = lo
    }
}
