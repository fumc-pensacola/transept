//
//  CalendarEvent.swift
//  FUMCApp
//
//  Created by Andrew Branch on 11/10/14.
//  Copyright (c) 2014 FUMC Pensacola. All rights reserved.
//

import UIKit

class CalendarEvent: NSObject {
    
    var name: String
    var descript: String
    var from: NSDate
    var to: NSDate
    var location: String
    var calendar: String
    var calendarId: String
    
    init(jsonDictionary: NSDictionary, dateFormatter: NSDateFormatter) {
        
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        self.name = jsonDictionary["name"] as String
        self.from = dateFormatter.dateFromString(jsonDictionary["from"] as String)!
        self.to = dateFormatter.dateFromString(jsonDictionary["to"] as String)!
        self.descript = ""
        self.location = ""
        self.calendarId = jsonDictionary["calendarId"] as String
        self.calendar = jsonDictionary["calendar"] as String
        
        if let description: String = jsonDictionary["description"] as? String {
            self.descript = description
        }
        
        if let location: NSDictionary = jsonDictionary["location"] as? NSDictionary {
            self.location = location["name"] as String
        }
    }
   
}
