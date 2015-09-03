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
    required init()
    {
        
    }
    
    static func ApplyFont(barbutton : UIBarButtonItem, fontName : String, fontCharacter : String, size : CGFloat)
    {
        if let font = UIFont(name: fontName, size: size)
        {
            barbutton.setTitleTextAttributes([NSFontAttributeName : font/*, NSForegroundColorAttributeName: UIColor.blackColor()*/], forState: UIControlState.Normal)
            barbutton.title = fontCharacter
        }
    }
}

