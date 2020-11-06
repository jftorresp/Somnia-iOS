//
//  User.swift
//  Somnia
//  Class that represents a user of the app
//  Created by Nicolas Cobos on 23/09/20.
//

import Foundation

class User {
    
    let email: String
    let age: Int
    let fullname: String
    let nickname: String
    let gender: String
    let occupation: String
    
    init(email user: String, a: Int, f: String, n: String, g: String, o: String) {
        self.email = user
        age = a
        fullname = f
        nickname = n
        gender = g
        occupation = o
    }
}
