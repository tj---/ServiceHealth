//
//  ViewHelper.swift
//  ServiceHealth
//
//  Created by Trilok Jain on 12/15/14.
//  Copyright (c) 2014 Trilok Jain. All rights reserved.
//

import Foundation
import Cocoa

class SettingsViewHelper: ViewHelper
{
    var settFetcher: SettingsFetcher
    
    init(cView: NSView, headingView: NSTextField, settFetcher: SettingsFetcher)
    {
        self.settFetcher = settFetcher
        super.init(cView: cView, hView: headingView)
    }
    func formSettingsPane()
    {
        // 1. Set the Heading
        self.heading.stringValue = Resources.getLString(Resources.settings_heading)
        var currSettings = settFetcher.settings
        
        var curr = Resources.y_max - Resources.std_height
        // 2. Set the Launch on Startup setting
        formCheckBox(0, y: curr, w: Resources.x_max, h: Resources.std_height, title: Resources.getLString(Resources.launch_on_startup), selector: "updateLaunchSettings:", enabled: AvailabilityUtil.isStartupLaunchEnabled())
        // 3. Set the services to receive updates from
        if(currSettings.providers.isEmpty)
        {
            // 3.a Set the Loading message
            formTextView(0, y: Resources.y_max - Resources.std_height, w: Resources.x_max, h: Resources.std_height, text: Resources.getLString(Resources.res_loading))
        }
        else
        {
            // 3.b Set the available services and their subscription status
            curr = curr - Resources.std_height
            formTextView(0, y: curr, w: Resources.x_max, h: Resources.std_height, text: Resources.getLString(Resources.sel_services_updt), bgColor: NSColor(red: 0.92, green: 1.0, blue: 1.0, alpha:1.0))
            for index in 0...(currSettings.providers.count - 1)
            {
                formCheckBox(0, y: curr - (index + 1)*Resources.std_height, w: 120, h: Resources.std_height, title:(currSettings.providers[index].serviceName),
                    selector: "updateSettings:", enabled: currSettings.providers[index].enabled)
            }
        }
    }
    @objc func updateLaunchSettings(sender: NSButton)
    {
        AvailabilityUtil.launchOnStartup(sender.state == 0 ? false : true)
    }
    // Right now, a save is attempted on each update to the checkBox, however, that should not be the case
    @objc func updateSettings(sender: NSButton)
    {
        for provider in settFetcher.settings.providers
        {
            if(provider.serviceName == sender.title)
            {
                provider.enabled = sender.state == 0 ? false : true
            }
        }
        // Now persist the updated values
        settFetcher.writePreferences()
    }
}
