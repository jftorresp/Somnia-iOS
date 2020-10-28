//
//  Alarm.swift
//  Somnia
//
//  Created by Juan Felipe Torres on 17/10/20.
//

import Foundation

struct Alarm {
    
    let alarm_date: Date
    let createdBy: String
    let description: String
    let exact: Bool
    let repeat_day: [String: Bool]
    
    func getRepeatDays() -> String{
        var string = ""
        if repeat_day["1"] == true && repeat_day["2"] == true && repeat_day["3"] == true && repeat_day["4"] == true && repeat_day["5"] == true && repeat_day["6"] == true && repeat_day["7"] == true  {
            string = "Every day"
        }
        else {
            if repeat_day["6"] == true && repeat_day["7"] == true {
                string = "On weekend"
            } else if repeat_day["1"] == true && repeat_day["2"] == true && repeat_day["3"] == true && repeat_day["4"] == true && repeat_day["5"] == true{
                string = "On weekdays"
            } else {
                
                if repeat_day["1"] == true {
                    string += "Monday, "
                }
                if repeat_day["2"] == true {
                    string += "Tuesday, "
                }
                if repeat_day["3"] == true {
                    string += "Wednesday, "
                }
                if repeat_day["4"] == true {
                    string += "Thursday, "
                }
                if repeat_day["5"] == true {
                    string += "Friday,"
                }
                if repeat_day["6"] == true {
                    string += "Saturday, "
                }
                if repeat_day["7"] == true {
                    string += "Sunday"
                }
            }
        }
        return string
    }
    
}
