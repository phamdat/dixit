//
//  LoginViewController.swift
//  Dixit
//
//  Created by Tien Dat Tran on 8/13/15.
//  Copyright (c) 2015 Keyboard and Mouse. All rights reserved.
//

import UIKit

class LoginViewController : UIViewController
{
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    let network : SFNetwork
    
    required init(coder aDecoder: NSCoder)
    {
        network = SFNetwork.sharedInstance
        super.init(coder: aDecoder)
    }
    
    @IBAction func login(sender: UIButton) {
        let name = nameText.text
        network.login(name, password: "", callback: {
            (result : Result) -> () in
            println("login roi ne hehe")
        })
    }
}
