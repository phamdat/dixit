//
//  GAService.swift
//  Dixit
//
//  Created by Tien Dat Tran on 9/21/15.
//  Copyright © 2015 Keyboard and Mouse. All rights reserved.
//

import Foundation

protocol TrackerService
{
    func SendEvent(category: String, action: String, label: String, value: Int)
    func SendException(exceptionMessage: String)
}

class GAService : TrackerService
{
    var _tracker: GAITracker
    static let sharedInstance = GAService()
    
    init()
    {
        _tracker = GAI.sharedInstance().defaultTracker
    }
    
    func SendEvent(category: String, action: String, label: String, value: Int)
    {
        let data = GAIDictionaryBuilder.createEventWithCategory(category, action: action, label: label, value: value).build()
        _tracker.send(data as [NSObject : AnyObject])
    }
    
    func SendException(exceptionMessage: String)
    {
        GAIDictionaryBuilder.createExceptionWithDescription(exceptionMessage, withFatal: true)
    }
}