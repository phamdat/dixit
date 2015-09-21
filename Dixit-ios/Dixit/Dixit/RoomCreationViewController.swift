//
//  RoomCreationViewController.swift
//  Dixit
//
//  Created by Tien Dat Tran on 8/15/15.
//  Copyright (c) 2015 Keyboard and Mouse. All rights reserved.
//

import Foundation
import UIKit

class RoomCreationViewController : BaseViewController
{
    @IBOutlet weak var createBarButton: UIBarButtonItem!
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!
    @IBOutlet weak var nameText: UITextField!
    
    override func viewDidLoad()
    {
        self.screenName = "Room Create Screen"
        super.viewDidLoad()
    }
    
    @IBAction func createRoom(sender: UIBarButtonItem)
    {
        print("request create room")
        network.createRoom(nameText.text, callback: { result -> () in
            switch result
            {
            case Result.Success(let room):
                UserInfo.sharedInstance.currentRoom = room as? Room
                self.performSegueWithIdentifier("createRoomSegue", sender: self)
                break
            default:
                break
            }
        })
    }
    
    @IBAction func cancel(sender: UIBarButtonItem)
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
}