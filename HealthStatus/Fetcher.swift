//
//  Fetcher.swift
//  HealthStatus
//
//  Created by Trilok Jain on 12/8/14.
//  Copyright (c) 2014 Trilok Jain. All rights reserved.
//

import Foundation

class Fetcher
{
    var request : NSMutableURLRequest = NSMutableURLRequest()
    var updateCallBack: (() -> Void)
    var fetchUrl: NSString!
    
    init(callBack: (() -> Void), fetchUrl: NSString)
    {   
        self.updateCallBack = callBack
        request.HTTPMethod = "GET"
        self.fetchUrl = fetchUrl
        self.updateData()
    }
    
    func prepareFetchUrl() -> NSString
    {
        return self.fetchUrl
    }
    
    func updateData()
    {
        request.URL = NSURL(string: prepareFetchUrl())
        println("The fetchUrl is : \(request.URL)")
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue(), completionHandler: {(response:NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            if(nil == error)
            {
                var error: AutoreleasingUnsafeMutablePointer<NSError?> = nil
                let jsonResult: Dictionary<String, AnyObject>! = NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions.MutableContainers, error: error) as Dictionary<String, AnyObject>
                if(nil == error)
                {
                    self.doOnSuccess(jsonResult)
                }
                else
                {
                    self.doOnError(errMsg: "Failed to parse the response - \(error.debugDescription)")
                }
            }
            else
            {
                self.doOnError(errMsg: "Failed to receive a response - \(error.localizedDescription)")
            }
        })
    }
    
    func doOnSuccess(jsonResult: Dictionary<String, AnyObject>!) {
        self.updateCallBack()
    }
    func doOnError(errMsg: NSString = "") {
        self.updateCallBack()
    }
}