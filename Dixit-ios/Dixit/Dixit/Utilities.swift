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
    
}