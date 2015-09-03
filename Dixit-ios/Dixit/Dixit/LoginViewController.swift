//
//  LoginViewController.swift
//  Dixit
//
//  Created by Tien Dat Tran on 8/13/15.
//  Copyright (c) 2015 Keyboard and Mouse. All rights reserved.
//

import UIKit

class LoginViewController : BaseViewController
{
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var loginButton: UIButton!    
    
    override func viewDidLoad() {
        super.viewDidLoad()        
    }
    
    @IBAction func login(sender: UIButton) {
        let name = nameText.text
        network.start({
            result -> () in
            self.network.connect({ result1 -> () in
                self.network.login(name, password: "", callback: { result2 -> () in
                    println("login roi ne hehe")
                    switch result2
                    {
                    case Result.Success(let user):
                        UserInfo.sharedInstance.currentUser = user as? User
                        self.performSegueWithIdentifier("roomLobbySegue", sender: sender)
                        break
                    case Result.Failure(let message):
                        println("login fail roi ne")
                        break
                    default:
                        break
                    }
                })
            })
        })
    }
    
}
