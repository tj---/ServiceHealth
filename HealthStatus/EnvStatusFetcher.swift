//
//  Fetcher.swift
//  HealthStatus
//
//  Created by Trilok Jain on 12/2/14.
//  Copyright (c) 2014 Trilok Jain. All rights reserved.
//

import Foundation

class EnvStatusFetcher: Fetcher
{
    private var _data: Response?
    var data: Response?
    {
        get {
            return self._data
        }
    }
    
    private var _lastSuccess: NSDate
    var lastSuccess: NSDate
    {
        get {
            return self._lastSuccess
        }
    }
    
    private var _errorMsg: NSString?
    var errorMsg: NSString?
    {
        get {
            return self._errorMsg
        }
    }
    
    private var settingsFetcher: SettingsFetcher
    
    init(callBack: (() -> Void), fUrl: NSString, settingsFetcher: SettingsFetcher)
    {
        _lastSuccess = NSDate(timeIntervalSince1970: 0)
        self.settingsFetcher = settingsFetcher
        super.init(callBack: callBack, fetchUrl: fUrl);
        self.updateData()
    }
    
    override func prepareFetchUrl() -> NSString
    {
        var qParams: NSString = ""
        for provider in settingsFetcher.settings.providers
        {
            if(provider.enabled)
            {
                qParams = qParams + provider.serviceId + ","
            }
        }
        return self.fetchUrl + "?qP=" + qParams
    }
    
    override func doOnSuccess(jsonResult: Dictionary<String, AnyObject>!)
    {
        self._data = Response()
        if(nil != jsonResult)
        {
            _lastSuccess = NSDate()
            _errorMsg = nil
            self._data = self.parseJson(jsonResult)
        }
        super.updateCallBack()
    }
    
    override func doOnError(errMsg: NSString = "")
    {
        _errorMsg = errMsg
        super.updateCallBack()
    }
    
    func parseJson(json: Dictionary<String, AnyObject>) -> Response
    {
        var response = Response()
        response.code = StatusCode(rawValue: json["code"] as NSString)!
        response.error = json["error"] as NSString
        let services = json["services"] as Array<Dictionary<String, AnyObject>>
        var serviceResponses: [ServiceResponse] = []
        for service in services
        {
            var serviceResponse = ServiceResponse(sName: service["serviceName"] as NSString!)
            serviceResponse.serviceId = service["serviceId"] as NSString!
            let statuses = service["statuses"] as Array<Dictionary<String, NSString>>
            var envStatuses: [EnvStatus] = []
            for status in statuses
            {
                var envStatus = EnvStatus(sCode: StatusCode(rawValue: status["code"]! as NSString)!, sEnv: status["env"] as NSString!)
                envStatus.message = status["message"] as NSString!
                envStatus.error = status["error"] as NSString!
                envStatuses.append(envStatus)
            }
            serviceResponse.statuses = envStatuses
            serviceResponses.append(serviceResponse)
        }
        response.services = serviceResponses
        return response
    }
}