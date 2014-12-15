//
//  AvailabilityUtil.swift
//  ServiceHealth
//
//  Created by Trilok Jain on 12/15/14.
//  Copyright (c) 2014 Trilok Jain. All rights reserved.
//

import Foundation

// Copied from http://stackoverflow.com/a/26953667/174184
// Utility to check and add the ServiceHealth app to the startup items
class AvailabilityUtil
{
    class func itemReferencesInLoginItems() -> (existingReference: LSSharedFileListItemRef?, lastReference: LSSharedFileListItemRef?)
    {
        var itemUrl : UnsafeMutablePointer<Unmanaged<CFURL>?> = UnsafeMutablePointer<Unmanaged<CFURL>?>.alloc(1)
        if let appUrl : NSURL = NSURL.fileURLWithPath(NSBundle.mainBundle().bundlePath)
        {
            let loginItemsRef = LSSharedFileListCreate(
                nil, kLSSharedFileListSessionLoginItems.takeRetainedValue(), nil).takeRetainedValue() as LSSharedFileListRef?
            if loginItemsRef != nil
            {
                let loginItems: NSArray = LSSharedFileListCopySnapshot(loginItemsRef, nil).takeRetainedValue() as NSArray
                let lastItemRef: LSSharedFileListItemRef = loginItems.lastObject as LSSharedFileListItemRef
                for index in 0...(loginItems.count - 1)
                {
                    let currentItemRef: LSSharedFileListItemRef = loginItems.objectAtIndex(index) as LSSharedFileListItemRef
                    if LSSharedFileListItemResolve(currentItemRef, 0, itemUrl, nil) == noErr
                    {
                        if let urlRef: NSURL =  itemUrl.memory?.takeRetainedValue()
                        {
                            if urlRef.isEqual(appUrl)
                            {
                                return (currentItemRef, lastItemRef)
                            }
                        }
                    }
                }
                //The application was not found in the startup list
                return (nil, lastItemRef)
            }
        }
        return (nil, nil)
    }
    
    class func isStartupLaunchEnabled() -> Bool
    {
        return itemReferencesInLoginItems().existingReference != nil
    }
    
    class func launchOnStartup(enable: Bool)
    {
        let itemReferences = itemReferencesInLoginItems()
        let loginItemsRef = LSSharedFileListCreate(nil, kLSSharedFileListSessionLoginItems.takeRetainedValue(), nil).takeRetainedValue() as LSSharedFileListRef?
        if loginItemsRef != nil
        {
            if(!isStartupLaunchEnabled() && enable)
            {
                if let appUrl : CFURLRef = NSURL.fileURLWithPath(NSBundle.mainBundle().bundlePath)
                {
                    LSSharedFileListInsertItemURL(loginItemsRef, itemReferences.lastReference, nil, nil, appUrl, nil, nil)
                }
            }
            else if(isStartupLaunchEnabled() && !enable)
            {
                if let itemRef = itemReferences.existingReference
                {
                    LSSharedFileListItemRemove(loginItemsRef,itemRef);
                }
            }
        }
    }
}