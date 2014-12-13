//
//  Responses.swift
//  HealthStatus
//
//  Created by Trilok Jain on 12/2/14.
//  Copyright (c) 2014 Trilok Jain. All rights reserved.
//

import Foundation

class Response
{
    init()
    {
        code = StatusCode.GRAY
        error = ""
        services = []
    }
    var code: StatusCode
    var services: [ServiceResponse]
    var error: NSString
}