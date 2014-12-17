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
    let config_storage = "._service_health_config.plist"
    
    @IBOutlet weak var settings: NSButton!
    @IBOutlet var mainScreen: NSView!
    @IBOutlet weak var heading: NSTextField!
    @IBOutlet weak var displayArea: NSScrollView!
    
    var contentView: NSClipView!
    
    var settingsEnabled: Bool = false
    var envFetcher: EnvStatusFetcher!
    var settFetcher: SettingsFetcher!
    
    var config: Config = Config()
    
    var settingsViewHelper: SettingsViewHelper!
    var svcStatusViewHelper: SvcStatusViewHelper!
    
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
        // Read the config file, overwrite it so that it is no more corrupt even if it was
        config = Utils.readFromFile(config_storage) as Config
        if(!config.launchPrefUpdated)
        {
            AvailabilityUtil.launchOnStartup(true)
            config.launchPrefUpdated = true
        }
        Utils.writeToFile(config, fileName: config_storage)
        
        settFetcher = SettingsFetcher(callBack: self.paintScreen, fUrl: config.settingsUrl)
        envFetcher = EnvStatusFetcher(callBack: self.paintScreen, fUrl: config.statsUrl, settingsFetcher: settFetcher)
        
        settingsViewHelper = SettingsViewHelper(cView: self.contentView, headingView: heading, settFetcher: settFetcher)
        svcStatusViewHelper = SvcStatusViewHelper(cView: self.contentView, headingView: heading, envFetcher: envFetcher, interval: config.updateInterval)
        
        self.paintScreen()
    }
    func setupContentView()
    {
        self.contentView = NSClipView(frame: NSRect(x:0, y: 0, width: Resources.x_max, height: Resources.y_max))
        self.contentView.backgroundColor = NSColor.clearColor()
        self.contentView.drawsBackground = false
        self.displayArea.documentView = contentView
    }
    
    @IBAction func settingsAction(sender: NSButton)
    {
        settingsEnabled = !settingsEnabled
        self.paintScreen()
    }
    func paintScreen()
    {
        settingsViewHelper.clearScreen()
        if(settingsEnabled)
        {
            settingsViewHelper.formSettingsPane()
        }
        else
        {
            svcStatusViewHelper.formResponseScreen()
        }
        // Scroll to Top Left
        var point = NSMakePoint(0, CGFloat(Resources.y_max) - CGFloat(self.displayArea.bounds.height))
        self.displayArea.contentView.scrollToPoint(point)
    }
}