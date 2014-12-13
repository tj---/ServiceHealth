//
//  PopView.swift
//  HealthStatus
//
//  Created by Trilok Jain on 11/29/14.
//  Copyright (c) 2014 Trilok Jain. All rights reserved.
//

import Foundation
import Cocoa

class PopViewController: NSViewController
{
    let oldest_date = NSDate(timeIntervalSince1970: 5)
    let env_status_heading = "  Environment Status"
    let settings_heading = "  Settings"
    
    let y_max: Int = 2000
    let x_max: Int = 500
    
    @IBOutlet weak var settings: NSButton!
    @IBOutlet var mainScreen: NSView!
    @IBOutlet weak var heading: NSTextField!
    @IBOutlet weak var displayArea: NSScrollView!
    
    var contentView: NSClipView!
    var loadingMsg: NSTextField!
    
    var settingsEnabled: Bool = false
    var envFetcher: EnvStatusFetcher!
    var settFetcher: SettingsFetcher!
    var dateFormatter: NSDateFormatter = NSDateFormatter()
    
    var timer = NSTimer()
    
    override init?(nibName: String?, bundle: NSBundle?)
    {
        super.init(nibName: nibName, bundle: bundle)
    }
    
    required init?(coder: NSCoder)
    {
        super.init(coder: coder)
    }
    
    override func awakeFromNib()
    {
        setupContentView()
        settFetcher = SettingsFetcher(self.paintScreen)
        envFetcher = EnvStatusFetcher(callBack: self.paintScreen,settingsFetcher: settFetcher)
        self.paintScreen()
        timer = NSTimer.scheduledTimerWithTimeInterval(10, target:self, selector: "updatePanel", userInfo: nil, repeats: true)
        dateFormatter.dateFormat = "dd-MMM HH:mm:ss"
    }
    func setupContentView()
    {
        self.contentView = NSClipView(frame: NSRect(x:0, y: 0, width: x_max, height: y_max))
        self.contentView.backgroundColor = NSColor.clearColor()
        self.contentView.drawsBackground = false
        self.displayArea.documentView = contentView
        
        self.loadingMsg = NSTextField(frame: NSRect(x: 10, y: y_max - 40, width: 100, height: 30))
        self.loadingMsg.stringValue = "Loading..."
        self.loadingMsg.backgroundColor = NSColor.clearColor()
        self.loadingMsg.bordered = false
        
    }
    func updatePanel()
    {
        println("Updating panel")
        envFetcher.updateData()    }
    
    @IBAction func settingsAction(sender: NSButton)
    {
        println("Settings Action")
        settingsEnabled = !settingsEnabled
        self.paintScreen()
    }
    func paintScreen()
    {
        self.clearScreen()
        if(settingsEnabled)
        {
            self.formSettingsPane()
        }
        else
        {
            self.formResponseScreen()
        }
        // Scroll to Top Left
        var point = NSMakePoint(0, CGFloat(y_max) - CGFloat(self.displayArea.bounds.height))
        self.displayArea.contentView.scrollToPoint(point)
    }
    
    // This might lead to memory leaks - keep a tab on this
    func clearScreen()
    {
        if(nil != self.contentView)
        {
            self.contentView.subviews = []
        }
    }
    func formResponseScreen()
    {
        self.heading.stringValue = env_status_heading
        if(self.envFetcher.data == nil && self.envFetcher.errorMsg == nil)
        {
            self.contentView.addSubview(loadingMsg)
        }
        else
        {
            // If there is error, show the error message
            var curr = y_max
            if(self.envFetcher.errorMsg != nil)
            {
                curr = curr - 20
                formTextView(10, y: curr, w: x_max, h: 20, text: self.envFetcher.errorMsg!)
            }
            // Show the Last Updated ts
            curr = curr - 20
            formTextView(0, y: curr, w: x_max, h: 20, text: "Last Updated : " + (oldest_date.compare(self.envFetcher.lastSuccess) == NSComparisonResult.OrderedDescending ? "Never :(" : dateFormatter.stringFromDate(self.envFetcher.lastSuccess)))
            // Show the Data
            
            if(nil != self.envFetcher.data && self.envFetcher.data?.services.count > 0)
            {
                var services: [ServiceResponse]! = self.envFetcher.data?.services
                curr = curr - 20
                for serviceResponse in services
                {
                    var col = 10
                    formTextView(0, y: curr, w: x_max, h: 20, text: serviceResponse.serviceName)
                    curr = curr - 20
                    for status in serviceResponse.statuses
                    {
                        var iView: NSImageView = NSImageView(frame: NSRect(x: col, y: curr, width: 20, height: 20))
                        switch status.code
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
                        var toolTip: NSString? = status.message ?? status.error
                        iView.toolTip = toolTip
                        formTextView(col, y: curr - 20, w: 100, h: 20, text: status.env).toolTip = toolTip
                        col = col + 80
                    }
                    curr = curr - 40
                }
            }
        }
    }
    func formTextView(x: Int, y: Int, w: Int, h: Int, text: NSString, bgColor: NSColor = NSColor.clearColor()) -> NSView
    {
        var view: NSTextField = NSTextField(frame: NSRect(x: x, y: y, width: w, height: h))
        view.stringValue = text
        view.backgroundColor = bgColor
        view.bordered = false
        self.contentView.addSubview(view)
        return view
    }
    func formSettingsPane()
    {
        self.heading.stringValue = settings_heading
        var currSettings = settFetcher.settings
        
        if(currSettings.providers.isEmpty)
        {
            self.contentView.addSubview(loadingMsg)
        }
        else
        {
            for index in 0...(currSettings.providers.count - 1)
            {
                var checkBox = NSButton(frame: NSRect(x:10, y: y_max - (index + 1)*20, width: 120, height: 20))
                checkBox.setButtonType(NSButtonType.SwitchButton)
                checkBox.title = "\(currSettings.providers[index].serviceName)"
                checkBox.target = self
                checkBox.action = Selector("updateSettings:")  // On any change in the settings
                checkBox.state = currSettings.providers[index].enabled ? 1 : 0
                self.contentView.addSubview(checkBox)
            }
        }
    }
    // Right now, a save is attempted on each update to the checkBox, however, that should not be the case
    func updateSettings(sender: NSButton)
    {
        for provider in settFetcher.settings.providers
        {
            if(provider.serviceName == sender.title)
            {
                println("action received from button \(sender.title) and state \(sender.state)")
                provider.enabled = sender.state == 0 ? false : true
            }
        }
        // Now persist the updated values
        settFetcher.writePreferences()
    }
}