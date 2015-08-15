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
    @IBOutlet weak var statusLabel: UILabel!
    
    var network : SFNetwork
    
    required init(coder aDecoder: NSCoder)
    {
        network = SFNetwork.sharedInstance
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = UIRectEdge.None
        
        self.title = "Menu"
        
//        var label = UILabel(frame: CGRect(x: 40, y: 100, width: 40, height: 40))
//        label.font = UIFont(name: "streamline-24px", size: 40)
//        let mychar : UniChar = 0xe2fe
//        label.text = String(format: "%C", mychar)
//        self.view.addSubview(label)
        
        let roomView = RoomItem(frame: CGRect(x: 0, y: 0, width: 395, height: 106))
        self.view.addSubview(roomView)
        
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
    
    @IBAction func playButtonPressed(sender: UIButton) {
        let title = sender.titleForState(.Normal)!
        let plainText = "\(title) button pressed"
        let styledText = NSMutableAttributedString(string: plainText)
        let attributes = [NSFontAttributeName : UIFont.boldSystemFontOfSize(20)]
        let nameRange = (plainText as NSString).rangeOfString(title)
        styledText.setAttributes(attributes, range: nameRange)
        statusLabel.attributedText = styledText 
    }
    
}

