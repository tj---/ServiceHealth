//
//  SingleResponse.swift
//  HealthStatus
//
//  Created by Trilok Jain on 12/2/14.
//  Copyright (c) 2014 Trilok Jain. All rights reserved.
//

import Foundation

class EnvStatus
{
    init(sCode: StatusCode, sEnv: NSString)
    {
        env = sEnv
        code = sCode
    }
    
    var endPoint: NSString!
    var env: NSString
    var code: StatusCode
    var message: NSString!
    var error: NSString!
}

enum StatusCode: String
{
    case GREEN = "GREEN", YELLOW = "YELLOW"
    case RED = "RED", GRAY = "GRAY"
}