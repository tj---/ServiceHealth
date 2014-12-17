//
//  Resources.swift
//  ServiceHealth
//
//  Created by Trilok Jain on 12/16/14.
//  Copyright (c) 2014 Trilok Jain. All rights reserved.
//

import Foundation

class Resources
{
    class var env_status_heading: NSString { return "env_status_heading" }
    class var settings_heading: NSString { return "settings_heading" }
    class var res_loading: NSString { return "res_loading" }
    class var launch_on_startup: NSString { return "launch_on_startup" }
    class var sel_services_updt: NSString { return "sel_services_updt" }
    class var std_date_fmt: NSString { return "dd-MMM-yyyy HH:mm:ss" }
    class var oldest_date:NSDate { return NSDate(timeIntervalSince1970: 5) }
    
    class var x_max: Int { return 595 }
    class var y_max: Int { return 2000 }
    class var std_height: Int { return 20 }
    
    // Get Localized String
    class func getLString(resName: NSString) -> NSString
    {
        return NSLocalizedString(resName, comment: "")
    }
}