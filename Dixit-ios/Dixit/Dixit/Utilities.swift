//
//  Utilities.swift
//  Dixit
//
//  Created by Tien Dat Tran on 8/26/15.
//  Copyright (c) 2015 Keyboard and Mouse. All rights reserved.
//

import Foundation

class Utilities
{
    
    required init()
    {
        
    }
    
    static func parseJSON(text: String) -> NSDictionary
    {
        var error: NSError?
        let jsonData: NSData = text.dataUsingEncoding(NSUTF8StringEncoding)!
        let jsonDict = (try! NSJSONSerialization.JSONObjectWithData(jsonData, options: [])) as! NSDictionary
        return jsonDict
    }
    
    static func GetDeviceSize() -> CGSize
    {
        return UIScreen.mainScreen().bounds.size
    }
    
    static func GetBannerHeight() -> CGFloat
    {
        let height = GetDeviceSize().height
        
        if height < 400
        {
            return 32
        }
        else if height >= 400 && height <= 700
        {
            return 50
        }
        else if height > 700
        {
            return 90
        }
        
        return 90
    }
    
}