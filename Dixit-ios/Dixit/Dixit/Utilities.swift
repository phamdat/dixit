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
        var jsonData: NSData = text.dataUsingEncoding(NSUTF8StringEncoding)!
        let jsonDict = NSJSONSerialization.JSONObjectWithData(jsonData, options: nil, error: &error) as! NSDictionary
        return jsonDict
    }    
    
}