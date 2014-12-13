//
//  SettingsFetcher.swift
//  HealthStatus
//
//  Created by Trilok Jain on 12/6/14.
//  Copyright (c) 2014 Trilok Jain. All rights reserved.
//

import Foundation

@objc class SettingsFetcher: Fetcher
{
    let env_settings_url = "http://demo5972920.mockable.io/settings"
    let settings_storage = "._env_health_check.plist"
    
    var settings: Settings
    
    init(callBack: (() -> Void))
    {
        settings = Settings()
        super.init(callBack: callBack, fetchUrl: env_settings_url);
    }
    
    func readPreferences() -> Settings
    {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
        let documentsDirectory = paths.objectAtIndex(0) as NSString
        let path = documentsDirectory.stringByAppendingPathComponent(settings_storage)
        
        let fileManager = NSFileManager.defaultManager()

        var localSettings = Settings()
        if(fileManager.fileExistsAtPath(path))
        {
            if let rawData = NSData(contentsOfFile: path)
            {
                // Try loading the file, if it is corrupt, ignore the exceptions and start from scratch
                SwiftTryCatch.try({ () -> Void in
                    var data: AnyObject? = NSKeyedUnarchiver.unarchiveObjectWithData(rawData);
                    localSettings = data as Settings
                }, catch: nil , finally: nil)
            }
        }
        return localSettings
    }
    
    func writePreferences()
    {
        // find the save directory our app has permission to use, and save the serialized version of self.scores - the HighScores array.
        let data = NSKeyedArchiver.archivedDataWithRootObject(self.settings);
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray;
        let documentsDirectory = paths.objectAtIndex(0) as NSString;
        let path = documentsDirectory.stringByAppendingPathComponent(settings_storage);
        data.writeToFile(path, atomically: true);
    }
    
    func syncPreferences()
    {
        var localSettings = readPreferences()
        
        if(self.settings.providers.count == 0)
        {
            self.settings = localSettings
        }
        else if(localSettings.providers.count > 0)
        {
            for fProvider in settings.providers
            {
                for lProvider in localSettings.providers
                {
                    if(lProvider.serviceName == fProvider.serviceName)
                    {
                        fProvider.enabled = lProvider.enabled
                    }
                }
            }
        }
    }
    
    override func doOnSuccess(jsonResult: Dictionary<String, AnyObject>!)
    {
        self.settings = (nil != jsonResult) ? self.parseJson(jsonResult) : Settings()
        self.syncPreferences()
        super.updateCallBack()
    }
    
    func parseJson(json: Dictionary<String, AnyObject>) -> Settings
    {
        var settings = Settings()
        var services = json["services"] as Array<Dictionary<String, AnyObject>>
        for service in services
        {
            var serviceSetting = Service(sName: service["serviceName"] as NSString!)
            serviceSetting.serviceId = service["serviceId"] as NSString!
            settings.addProvider(serviceSetting)
        }
        return settings
    }
}