//
//  ViewHelper.swift
//  ServiceHealth
//
//  Created by Trilok Jain on 12/16/14.
//  Copyright (c) 2014 Trilok Jain. All rights reserved.
//

import Foundation
import Cocoa

class ViewHelper
{
    var heading: NSTextField
    var contentView: NSView!
    
    init(cView: NSView, hView: NSTextField)
    {
        self.contentView = cView
        self.heading = hView
    }
    
    // This might lead to memory leaks - keep a tab on this
    func clearScreen()
    {
        if(nil != self.contentView)
        {
            self.contentView.subviews = []
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
    func formCheckBox(x: Int, y: Int, w: Int, h: Int, title: NSString, selector: NSString, enabled: Bool)
    {
        var checkBox = NSButton(frame: NSRect(x: x, y: y, width: w, height: h))
        checkBox.setButtonType(NSButtonType.SwitchButton)
        checkBox.title = title
        checkBox.target = self
        checkBox.action = Selector(selector) // For any change in the checkBox state
        checkBox.state = enabled ? 1 : 0
        self.contentView.addSubview(checkBox)
    }
}