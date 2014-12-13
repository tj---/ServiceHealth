//
//  AppDelegate.swift
//  HealthStatus
//
//  Created by Trilok Jain on 11/28/14.
//  Copyright (c) 2014 Trilok Jain. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate
{
    var statusItem: NSStatusItem!
    var statusView : StatusView!
    
    func applicationDidFinishLaunching(aNotification: NSNotification)
    {
        var height = NSStatusBar.systemStatusBar().thickness
        statusView = StatusView(frame: NSMakeRect(0, 0, CGFloat(height), CGFloat(height)))
        statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-1)
        statusItem.view = statusView
        statusItem.menu = nil
        statusItem.target = self
    }
}

