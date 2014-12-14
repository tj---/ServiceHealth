//
//  Utils.swift
//  ServiceHealth
//
//  Created by Trilok Jain on 12/14/14.
//  Copyright (c) 2014 Trilok Jain. All rights reserved.
//

import Foundation

class Utils
{
    class func readFromFile<T: NSObject>(fileName: NSString) -> T
    {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
        let documentsDirectory = paths.objectAtIndex(0) as NSString
        let path = documentsDirectory.stringByAppendingPathComponent(fileName)
        
        let fileManager = NSFileManager.defaultManager()
        
        var obj = T()
        if(fileManager.fileExistsAtPath(path))
        {
            if let rawData = NSData(contentsOfFile: path)
            {
                // Try loading the file, if it is corrupt, ignore the exceptions and start from scratch
                SwiftTryCatch.try({ () -> Void in
                    var data: AnyObject? = NSKeyedUnarchiver.unarchiveObjectWithData(rawData);
                    obj = data as T
                }, catch: nil , finally: nil)
            }
        }
        return obj
    }
    
    class func writeToFile<T: NSObject>(obj: T, fileName: NSString)
    {
        SwiftTryCatch.try({ () -> Void in
            let data = NSKeyedArchiver.archivedDataWithRootObject(obj);
            let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray;
            let documentsDirectory = paths.objectAtIndex(0) as NSString;
            let path = documentsDirectory.stringByAppendingPathComponent(fileName);
            data.writeToFile(path, atomically: true);
        }, catch: nil , finally: nil)
    }
}