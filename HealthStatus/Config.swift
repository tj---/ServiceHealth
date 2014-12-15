//
//  Config.swift
//  ServiceHealth
//
//  Created by Trilok Jain on 12/14/14.
//  Copyright (c) 2014 Trilok Jain. All rights reserved.
//

import Foundation

class Config: NSObject, NSCoding
{
    let min_update_interval = 3
    override init()
    {
        super.init()
    }
    required init(coder aDecoder: NSCoder)
    {
        self.updateInterval  = aDecoder.decodeObjectForKey("updateInterval") as NSInteger
        self.settingsUrl = aDecoder.decodeObjectForKey("settingsUrl") as NSString
        self.statsUrl = aDecoder.decodeObjectForKey("statsUrl") as NSString
        self.launchPrefUpdated = aDecoder.decodeObjectForKey("launchPrefUpdated") as Bool
        super.init()
        // Don't want to have the updateInterval too little
        if(self.updateInterval < min_update_interval)
        {
            self.updateInterval = min_update_interval
        }
    }
    func encodeWithCoder(aCoder: NSCoder)
    {
        aCoder.encodeObject(updateInterval, forKey: "updateInterval")
        aCoder.encodeObject(settingsUrl, forKey: "settingsUrl")
        aCoder.encodeObject(statsUrl, forKey: "statsUrl")
        aCoder.encodeObject(launchPrefUpdated, forKey: "launchPrefUpdated")
    }
    
    var updateInterval: NSInteger = 3 // Update interval in # of seconds
    var settingsUrl: NSString = "http://demo5972920.mockable.io/settings"
    var statsUrl: NSString = "http://demo5972920.mockable.io/status"
    var launchPrefUpdated: Bool = false
}