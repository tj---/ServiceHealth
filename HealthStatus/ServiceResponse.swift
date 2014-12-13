//
//  ServiceResponse.swift
//  HealthStatus
//
//  Created by Trilok Jain on 12/2/14.
//  Copyright (c) 2014 Trilok Jain. All rights reserved.
//

import Foundation

class ServiceResponse: Service
{
    override init(sName: NSString)
    {
        statuses = []
        super.init(sName: sName)
    }
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    var statuses: [EnvStatus]!
}