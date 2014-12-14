//
//  StatusView.swift
//  HealthStatus
//
//  Created by Trilok Jain on 11/29/14.
//  Copyright (c) 2014 Trilok Jain. All rights reserved.
//

import Foundation
import Cocoa

class StatusView : NSView, NSMenuDelegate
{
    var imageView: NSImageView!
    
    var popover: NSPopover!
    var popController: PopViewController!
    
    required init? (coder: NSCoder)
    {
        super.init(coder: coder)
    }
    override init(frame frameRect: NSRect)
    {
        var height = NSStatusBar.systemStatusBar().thickness
        imageView = NSImageView(frame: NSMakeRect(0, 0, CGFloat(height), CGFloat(height)))
        
        super.init(frame: frameRect)
        
        imageView.image = NSImage(named: "pulse.png")
        self.addSubview(imageView)
        
        popover = NSPopover()
        popover.behavior = NSPopoverBehavior.Transient
        popController = PopViewController(nibName: "PopViewController", bundle: nil)
        popover.contentViewController = popController
    }
    
    override func mouseDown(theEvent: NSEvent)
    {
        if(popover.shown)
        {
            // Pause the timer
            popController.stopTimer()
            popover.close()
        }
        else
        {
            popover.showRelativeToRect(self.frame, ofView: self, preferredEdge: NSMinYEdge)
            popController.startTimer()
        }
    }
}