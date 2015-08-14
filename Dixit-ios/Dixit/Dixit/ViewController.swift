//
//  ViewController.swift
//  Dixit
//
//  Created by Tien Dat Tran on 8/13/15.
//  Copyright (c) 2015 Keyboard and Mouse. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    @IBOutlet weak var playButton: UIButton!
    
    var network : SFNetwork
    
    required init(coder aDecoder: NSCoder)
    {
        network = SFNetwork.sharedInstance
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Menu"        
        
        network.start({
            (result:Result) -> () in
                self.network.connect(nil)
        })
    }
    
    func connect(sender : UIButton)
    {
        network.connect({
            (result : Result) -> () in
                println("sdfdsfdsf")
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

