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
    let settings_storage = "._service_health_preferences.plist"
    
    var settings: Settings = Settings()
    
    init(callBack: (() -> Void), fUrl: NSString)
    {
        super.init(callBack: callBack, fetchUrl: fUrl);
        settings = Utils.readFromFile(self.settings_storage)
    }
    
    func writePreferences()
    {
        Utils.writeToFile(settings, fileName: settings_storage)
    }
    
    func syncPreferences()
    {
        var localSettings = Utils.readFromFile(self.settings_storage) as Settings
        
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