//
//  Alarm.swift
//  Somnia
//
//  Created by Juan Felipe Torres on 17/10/20.
//

import Foundation

struct Alarm: Codable {
    
    let alarm_date: Date?
    let createdBy: String?
    let description: String?
    let exact: Bool?
    let repeat_day: [Int: Bool]?
    
}
