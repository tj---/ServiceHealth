//
//  Service.swift
//  HealthStatus
//
//  Created by Trilok Jain on 12/6/14.
//  Copyright (c) 2014 Trilok Jain. All rights reserved.
//

import Foundation


class Settings: NSObject, NSCoding
{
    override init()
    {
        _providers = []
        super.init()
    }
    required init(coder aDecoder: NSCoder) {
        self._providers  = aDecoder.decodeObjectForKey("_providers") as [Service]!
    }
    func encodeWithCoder(aCoder: NSCoder)
    {
        aCoder.encodeObject(_providers, forKey: "_providers")
    }
    
    private var _providers: [Service]
    var providers: [Service]
    {
        get
        {
            return self._providers
        }
    }
    func addProvider(service: Service)
    {
        _providers.append(service)
    }
}