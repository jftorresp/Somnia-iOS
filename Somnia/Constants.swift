//
//  Contants.swift
//  Somnia
//
//  Created by Juan Felipe Torres on 12/10/20.
//

struct K {
    
    static let homeVC = "HomeVC"
    static let signUpVC = "SignUpVC"
    static let tabBar = "tabBar"
    static let loginVC = "LoginVC"
    static let cellIdentifier = "alarmCell"
    static let cellNibName = "AlarmCell"
    
    struct BrandColors {
        static let darkBlue = "Darkblue"
        static let blue = "Blue"
        static let darkGreen = "Darkgreen"
        static let green = "Green"
        static let midBlue = "MidBlue"
    }
    
    struct FStore {
        static let usersCollection = "users"
        static let alarmsCollection = "alarms"
        static let userKey = "email"
        static let lat = "lat"
        static let lon = "lon"
        static let dateField = "alarm_date"
        static let createdByField = "createdBy"
    }
    
    struct Segues {
        static let registerToMenu = "RegisterToMenu"
        static let signUpComplete = "SignUpComplete"
    }
    
    
}
