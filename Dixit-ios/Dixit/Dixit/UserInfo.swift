//
//  UserInfo.swift
//  Dixit
//
//  Created by Tien Dat Tran on 8/15/15.
//  Copyright (c) 2015 Keyboard and Mouse. All rights reserved.
//

import Foundation
import UIKit

class UserInfo
{
    static let sharedInstance = UserInfo()
    
    var currentRoom : Room?
    var currentUser : User?
    var currentHostId : Int = -1
    
    required init()
    {
        
    }
    
    func leaveRoom()
    {
        currentRoom = nil
    }
}