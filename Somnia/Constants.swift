//
//  Contants.swift
//  Somnia
//
//  Created by Juan Felipe Torres on 12/10/20.
//

struct K {
    
    static let homeVC = "HomeVC"
    static let signUpVC = "SignUpVC"
    static let alarmTriggered = "AlarmTriggeredViewController"
    static let tabBar = "tabBar"
    static let loginVC = "LoginVC"
    
    static let cellNibName = "AlarmCell"
    static let cellNibName2 = "SleepSoundCell"
    static let cellNibName3 = "StoriesCell"
    
    static let cellIdentifier = "alarmCell"
    static let sleepSoundcell = "SleepSoundCell"
    static let storiesCell = "StoryCell"
    
    static let feedbackVC = "FeedbackVC"
    static let sleepTwoVC = "SleepTwoViewController"
    
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
        static let analysisCollection = "analysis"
        static let soundsCollection = "sounds"
        static let storiesCollection = "stories"
        static let dreamLogCollection = "dreamlogs"
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
