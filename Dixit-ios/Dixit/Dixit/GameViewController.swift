//
//  GameViewController.swift
//  Dixit
//
//  Created by Tien Dat Tran on 8/22/15.
//  Copyright (c) 2015 Keyboard and Mouse. All rights reserved.
//

import Foundation
import UIKit

class GameViewController : MWPhotoBrowser
{
    var network : SFNetwork
    
    lazy var photoSource : MyPhotoDelegate = { return MyPhotoDelegate() }()
    
    required init(coder aDecoder: NSCoder)
    {
        network = SFNetwork.sharedInstance
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad()
    {
        // do something before calling super viewdidload otherwise, it does not work
        self.delegate = photoSource
        self.zoomPhotosToFill = false
        self.enableGrid = true
        self.startOnGrid = true
        self.alwaysShowControls = true
        
        self.showNextPhotoAnimated(true)
        self.showPreviousPhotoAnimated(true)
        
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("onDrawCard:"), name: "draw_card", object: nil)
        
        drawCard()
    }
    
    func drawCard()
    {
        let me = network.smartFox.mySelf
        if me.id() == UserInfo.sharedInstance.currentHostId
        {
            network.drawCard({ (obj, Result) -> () in
                println("draw xong ne")
            })
        }
        
    }
    
    func onDrawCard(notification: NSNotification)
    {
        if let userInfo = notification.userInfo
        {
            let cards = userInfo["cards"] as! Array<NSDictionary>
            let cardId = cards[0]["id"] as! String
            println("sdfasdf")
        }
    }
}

class DixitImage
{
    var image : MWPhoto?
    var selected : Bool
    
    init (url : String)
    {
        self.selected = false
        image = MWPhoto(URL: NSURL(string: url))
    }
}

class MyPhotoDelegate : NSObject, MWPhotoBrowserDelegate
{
    var images : [DixitImage] = [DixitImage]()
    
    override init ()
    {
        images.append(DixitImage(url: "https://raw.githubusercontent.com/phamdat/dixit/develop/Dixit-document/Dixit/007bd36fb40ef301270636206036e3ec.jpg"))
        images.append(DixitImage(url: "https://raw.githubusercontent.com/phamdat/dixit/develop/Dixit-document/Dixit/00af48eb28586e61cdb75ebe551e425c.jpg"))
        images.append(DixitImage(url: "https://raw.githubusercontent.com/phamdat/dixit/develop/Dixit-document/Dixit/00e8d86482f6501a0a1fadb439422f7f.jpg"))
        images.append(DixitImage(url: "https://raw.githubusercontent.com/phamdat/dixit/develop/Dixit-document/Dixit/044960ab45ba9ec1cd53c490bb376982.jpg"))
        images.append(DixitImage(url: "https://raw.githubusercontent.com/phamdat/dixit/develop/Dixit-document/Dixit/04f27ba3c5767dab25068eb958fd50c6.jpg"))
        images.append(DixitImage(url: "https://raw.githubusercontent.com/phamdat/dixit/develop/Dixit-document/Dixit/08dccafe2fbce3e9a2f37910ad693be8.jpg"))
    }
    
    func numberOfPhotosInPhotoBrowser(photoBrowser: MWPhotoBrowser!) -> UInt {
        return UInt(images.count)
    }
    
    func photoBrowser(photoBrowser: MWPhotoBrowser!, photoAtIndex index: UInt) -> MWPhotoProtocol! {
        return self.images[Int(index)].image
    }
    
    func photoBrowser(photoBrowser: MWPhotoBrowser!, thumbPhotoAtIndex index: UInt) -> MWPhotoProtocol! {
        return self.images[Int(index)].image
    }
    
    
}