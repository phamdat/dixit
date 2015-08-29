//
//  GameViewController.swift
//  Dixit
//
//  Created by Tien Dat Tran on 8/22/15.
//  Copyright (c) 2015 Keyboard and Mouse. All rights reserved.
//

import Foundation
import UIKit

class Card
{
    var cardId: String = ""
    var cardUrl: String = ""
    
    convenience init(id: String, url: String)
    {
        self.init()
        cardId = id
        cardUrl = url
    }
    
     init()
    {
        
    }
}

class Player: SFSObject
{
    private var user: User?
    
    var name: String? { get { return self.user?.name() } }
    var id: Int? { get { return self.user?.id() } }
    var playerId: Int? { get { return self.user?.playerId() } }
    
    init(u: User)
    {
        user = u
    }
}

class GameViewController : MWPhotoBrowser
{
    @IBOutlet weak var selectBarButton: UIBarButtonItem!
    @IBOutlet weak var chatBarButton: UIBarButtonItem!
    
    var decidedUsers: [User] = [User]()
    
    var _shouldGo: Bool = false;
    var shouldGo: Bool {
        get { return _shouldGo }
        set
        {
            _shouldGo = newValue
            if _shouldGo
            {
                self.performSegueWithIdentifier("showResultSegue", sender: self)
            }
        }
    }
    
    
    
    var network : SFNetwork
    var myCards = [Card]()
    var selectedCard = Card()
    var _userCanSelectCard: Bool = false
    var userCanSelectCard: Bool {
        get { return _userCanSelectCard }
        set
        {
            _userCanSelectCard = newValue
            if _userCanSelectCard
            {
                selectBarButton.enabled = true
            }
            else
            {
                selectBarButton.enabled = false
            }
        }
    }
    
    
    lazy var photoSource : MyPhotoDelegate = { return MyPhotoDelegate() }()
    
    required init(coder aDecoder: NSCoder)
    {
        network = SFNetwork.sharedInstance

        super.init(coder: aDecoder)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("otherUserSelectCard:"), name: TaskType.UserSelectCard.description, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("onDrawCard:"), name: "draw_card", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("onHostSelectedCard:"), name: "host_select_card", object: nil)
    }
    
    override func viewDidLoad()
    {
        // MWPhotoBrowser do something before calling super viewdidload, otherwise it does not work
        self.delegate = photoSource
        self.zoomPhotosToFill = false
        self.enableGrid = true
        self.startOnGrid = true
        self.alwaysShowControls = true
        
        self.showNextPhotoAnimated(true)
        self.showPreviousPhotoAnimated(true)
        
        super.viewDidLoad()
        
        userCanSelectCard = false
        
//        self.navigationItem.hidesBackButton = true
       
        drawCard()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func drawCard()
    {
        let me = network.smartFox.mySelf
        if me.id() == UserInfo.sharedInstance.currentHostId
        {
            network.drawCard({ (data, result) -> () in
                self.userCanSelectCard = true
            })
        }
    }
    
    func selectedCard(card: Card)
    {
        var cardIdDictionary = ["cardId": card.cardId]
        let jsonData = NSJSONSerialization.dataWithJSONObject(cardIdDictionary, options: NSJSONWritingOptions(0), error: nil)
        let jsonString = NSString(data: jsonData!, encoding: NSUTF8StringEncoding) as! String
        
        var data = SFSObject()
        data.putUtfString("request", value: jsonString)
        
        if network.me.id() == UserInfo.sharedInstance.currentHostId
        {
            network.sendExtension("host_select_card", data: data, room: nil) { (data, result) -> () in
                self.userCanSelectCard = false
                self.network.sendPublicMessage(TaskType.UserSelectCard.description, data: nil)
            }
        }
        else
        {
            network.sendExtension("guest_select_card", data: data, room: nil) { (data, result) -> () in
                self.userCanSelectCard = false
                self.network.sendPublicMessage(TaskType.UserSelectCard.description, data: nil)
            }
        }
    }
    
    func onHostSelectedCard(notification: NSNotification)
    {
        if let userInfo = notification.userInfo
        {
            if network.me.id() != UserInfo.sharedInstance.currentHostId
            {
                userCanSelectCard = true
            }
        }
    }
    
    func onDrawCard(notification: NSNotification)
    {
        if let userInfo = notification.userInfo
        {
            let cards = userInfo["cards"] as! Array<NSDictionary>
            
            for c in cards
            {
                let id = c["id"] as! String
                let url = c["url"] as! String
                myCards.append(Card(id: id, url: url))
            }
            photoSource.setItemsSource(myCards)
            self.reloadData()
            
        }
    }
    
    func otherUserSelectCard(notification: NSNotification)
    {
        if let userInfo = notification.userInfo
        {
            let sender = userInfo["sender"] as! User
            decidedUsers.append(sender)
            let room = userInfo["room"] as! Room
            if room.userCount() == decidedUsers.count
            {
                shouldGo = true
            }
        }
    }
    
    //MARK: - UI Action
    @IBAction func selectCard(sender: AnyObject) {
        self.selectedCard(myCards[0])
    }
}

//MARK: - DixitImage class
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

//MARK: - MWPhotoBrowserDelegate
class MyPhotoDelegate : NSObject, MWPhotoBrowserDelegate
{
    var images : [DixitImage] = [DixitImage]()
    
    override init ()
    {
    }
    
    func setItemsSource(cards: [Card])
    {
        for c in cards
        {
            images.append(DixitImage(url: c.cardUrl))
        }
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