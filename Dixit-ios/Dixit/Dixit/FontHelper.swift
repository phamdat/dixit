//
//  FontHelper.swift
//  Dixit
//
//  Created by Tien Dat Tran on 8/15/15.
//  Copyright (c) 2015 Keyboard and Mouse. All rights reserved.
//

import Foundation
import UIKit

class FontHelper
{
    init()
    {
        
    }
    
    static func ApplyFont(barbutton : UIBarButtonItem, fontName : String, fontCharacter : UniChar, size : CGFloat)
    {
        if let font = UIFont(name: fontName, size: size)
        {
            barbutton.setTitleTextAttributes([NSFontAttributeName : font], forState: UIControlState.Normal)
            barbutton.title = String(format: "%C", fontCharacter)
        }
    }
}

