//
//  SvcStatusViewHelper.swift
//  ServiceHealth
//
//  Created by Trilok Jain on 12/17/14.
//  Copyright (c) 2014 Trilok Jain. All rights reserved.
//

import Foundation
import Cocoa

class SvcStatusViewHelper: ViewHelper
{
    var envFetcher: EnvStatusFetcher!
    var dateFormatter: NSDateFormatter = NSDateFormatter()
    var updateTimer: NSTimer = NSTimer()
    
    init(cView: NSView, headingView: NSTextField, envFetcher: EnvStatusFetcher, interval: Int)
    {
        self.envFetcher = envFetcher
        dateFormatter.dateFormat = Resources.std_date_fmt
        super.init(cView: cView, hView: headingView)
        
        var interval: NSTimeInterval = NSTimeInterval(interval)
        updateTimer = NSTimer.scheduledTimerWithTimeInterval(interval, target:self, selector: "updatePanel", userInfo: nil, repeats: true)
    }
    
    @objc func updatePanel()
    {
        envFetcher.updateData()
    }
    
    func formResponseScreen()
    {
        self.heading.stringValue = Resources.getLString(Resources.env_status_heading)
        if(self.envFetcher.data == nil && self.envFetcher.errorMsg == nil)
        {
            formTextView(0, y: Resources.y_max - Resources.std_height, w: Resources.x_max, h: Resources.std_height, text: Resources.getLString(Resources.res_loading))
        }
        else
        {
            // 1. If there is error, show the error message
            var row = Resources.y_max
            if(self.envFetcher.errorMsg != nil)
            {
                row = row - 2*Resources.std_height
                var errMsg: NSString = "\(self.envFetcher.errorMsg!) Next update will be attempted at : \(dateFormatter.stringFromDate(self.updateTimer.fireDate))"
                formTextView(0, y: row, w: Resources.x_max, h: 40, text: self.envFetcher.errorMsg!, bgColor: NSColor(red: 1.0, green: 0.9, blue: 0.9, alpha:1.0))
            }
            // 2. Show the Last Updated ts
            row = row - Resources.std_height
            var lastUpated: NSString = (Resources.oldest_date.compare(self.envFetcher.lastSuccess) == NSComparisonResult.OrderedDescending ? "Never :(" : dateFormatter.stringFromDate(self.envFetcher.lastSuccess))
            var updateMsg: NSString = "Last Updated at: \(lastUpated). Next Attempt at: \(dateFormatter.stringFromDate(self.updateTimer.fireDate))"
            formTextView(0, y: row, w: Resources.x_max, h: Resources.std_height, text: updateMsg, bgColor: NSColor(red: 0.92, green: 1.0, blue: 1.0, alpha:1.0))
            
            // 3. Show the Data
            paintServiceStatusView(row)
        }
    }
    
    func paintServiceStatusView(initRow: Int)
    {
        if(nil != self.envFetcher.data && self.envFetcher.data?.services.count > 0)
        {
            var services: [ServiceResponse]! = self.envFetcher.data?.services
            var row: Int = initRow - Resources.std_height
            for serviceResponse in services
            {
                var col = 0
                formTextView(0, y: row, w: Resources.x_max, h: Resources.std_height, text: serviceResponse.serviceName)
                row = row - Resources.std_height
                for status in serviceResponse.statuses
                {
                    formEnvInfoView(status, col: col, row: row)
                    col = col + 4 * Resources.std_height
                }
                row = row - 2 * Resources.std_height
            }
        }
    }
    
    func formEnvInfoView(envStatus: EnvStatus, col: Int, row: Int)
    {
        var iView: NSImageView = NSImageView(frame: NSRect(x: col, y: row, width: Resources.std_height, height: Resources.std_height))
        switch envStatus.code
        {
            case StatusCode.GREEN:
                iView.image = NSImage(named: "ic_green.png")
            case StatusCode.RED:
                iView.image = NSImage(named: "ic_red.png")
            case StatusCode.YELLOW:
                iView.image = NSImage(named: "ic_yellow.png")
            default:
                iView.image = NSImage(named: "ic_pause.png")
        }
        self.contentView.addSubview(iView)
        var toolTip: NSString? = envStatus.message ?? envStatus.error
        iView.toolTip = toolTip
        formTextView(col, y: row - Resources.std_height, w: Resources.x_max, h: Resources.std_height, text: envStatus.env).toolTip = toolTip
    }
}