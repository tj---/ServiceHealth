//
//  Service.swift
//  HealthStatus
//
//  Created by Trilok Jain on 12/6/14.
//  Copyright (c) 2014 Trilok Jain. All rights reserved.
//

import Foundation

class Service: NSObject, NSCoding
{
    init(sName: NSString)
    {
        serviceName = sName
    }
    required init(coder aDecoder: NSCoder)
    {
        self.serviceId  = aDecoder.decodeObjectForKey("serviceId") as NSString
        self.serviceName  = aDecoder.decodeObjectForKey("serviceName") as NSString
        self.enabled  = aDecoder.decodeObjectForKey("enabled") as Bool
    }
    func encodeWithCoder(aCoder: NSCoder)
    {
        aCoder.encodeObject(serviceId, forKey: "serviceId")
        aCoder.encodeObject(serviceName, forKey: "serviceName")
        aCoder.encodeObject(enabled, forKey: "enabled")
    }
    
    var serviceId: NSString!
    var serviceName: NSString
    var enabled: Bool = true
}