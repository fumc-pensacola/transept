//
//  Witness.swift
//  FUMCApp
//
//  Created by Andrew Branch on 10/30/14.
//  Copyright (c) 2014 FUMC Pensacola. All rights reserved.
//

import UIKit

class Witness: NSObject {
    
    var id: String
    var from: Date
    var to: Date
    var file: String
    var volume: Int
    var issue: Int
    var visible: Bool
    
    init(jsonDictionary: NSDictionary, dateFormatter: DateFormatter) {
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        let attrs = jsonDictionary["attributes"] as! NSDictionary
        self.id = jsonDictionary["id"] as! String
        
        self.from = dateFormatter.date(from: attrs["from"] as! String)!
        self.to = dateFormatter.date(from: attrs["to"] as! String)!
        self.volume = attrs["volume"] as! Int
        self.issue = attrs["issue"] as! Int
        self.file = attrs["file"] as! String
        self.visible = attrs["visible"] as! Bool
    }
}
