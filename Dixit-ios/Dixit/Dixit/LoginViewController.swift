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
        let name = nameText.text!
        if network.isConnected
        {
            loginNetwork(name)
        }
        else
        {
            network.start({
                result -> () in
                self.network.connect({ result1 -> () in
                    self.loginNetwork(name)
                })
            })
        }
    }
    
    private func loginNetwork(name: String)
    {
        self.network.login(name, password: "", callback: { result2 -> () in
            print("login roi ne hehe")
            switch result2
            {
            case Result.Success(let user):
                UserInfo.sharedInstance.currentUser = user as? User
                self.performSegueWithIdentifier("roomLobbySegue", sender: self)
                break
            case Result.Failure(let message):
                print("login fail roi ne: \(message)")
                break
            default:
                break
            }
        })
    }
}
