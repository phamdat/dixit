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
                self.performSegueWithIdentifier("showGuessCardSegue", sender: self)
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
    
    required init?(coder aDecoder: NSCoder)
    {
        network = SFNetwork.sharedInstance

        super.init(coder: aDecoder)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("otherUserSelectCard:"), name: TaskType.UserSelectCard.description, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("onHostSendQuestion:"), name: TaskType.Question.description, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("onDrawCard:"), name: "draw_card", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("onDrawCard:"), name: "draw_new_card", object: nil)        
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
        
        self.screenName = "Game Screen"
        
        super.viewDidLoad()
        
        userCanSelectCard = false
        
//        self.navigationItem.hidesBackButton = true
       
        drawCard()
    }
    
    override func viewDidDisappear(animated: Bool)
    {
        super.viewDidDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func drawCard()
    {
        if network.isHost && !UserInfo.sharedInstance.isInitialized
        {
            UserInfo.sharedInstance.isInitialized = true
            
            network.drawCard({ (data, result) -> () in
                self.userCanSelectCard = true
            })
        }
        else if UserInfo.sharedInstance.isInitialized
        {
            network.drawNewCard({ (data, result) -> () in
                self.userCanSelectCard = true
            })
        }
    }
    
    func selectedCard(card: Card)
    {
        if network.isHost
        {
            var cardDescription: UITextField = UITextField()
            
            let alert = UIAlertController(title: "Question", message: "", preferredStyle: .Alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            let selectAction = UIAlertAction(title: "Select", style: .Default, handler: { action in
                let des = cardDescription.text!
                self.sendCard(card, description: des)
            })
            alert.addTextFieldWithConfigurationHandler { (textField) -> Void in
                textField.placeholder = "Description for your card"
                cardDescription = textField
            }
            alert.addAction(cancelAction)
            alert.addAction(selectAction)
            
            self.presentViewController(alert, animated: true, completion: nil)
        }
        else
        {
            self.sendCard(card, description: "")
        }
//        CardCache.Instance.addCard(card)
    }
    
    func sendCard(card: Card, description: String)
    {
        let cardIdDictionary = ["cardId": card.cardId]
        let jsonData = try? NSJSONSerialization.dataWithJSONObject(cardIdDictionary, options: NSJSONWritingOptions(rawValue: 0))
        let jsonString = NSString(data: jsonData!, encoding: NSUTF8StringEncoding) as! String
        
        let data = SFSObject()
        data.putUtfString("request", value: jsonString)
        
        if network.isHost
        {
            network.sendExtension("host_select_card", data: data, room: nil) { (data, result) -> () in
                self.userCanSelectCard = false
                let question = SFSObject()
                question.putUtfString("question", value: description)
                self.network.sendPublicMessage(TaskType.Question.description, data: question)
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
        if let _ = notification.userInfo
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
    
    func onHostSendQuestion(notification: NSNotification)
    {
        if network.isHost
        {
            return;
        }
        
        if let userInfo = notification.userInfo
        {
            if let data = userInfo["data"] as? SFSObject
            {
                let description = data.getUtfString("question")
                showDescription(description)
            }
        }
    }
    
    func showDescription(description: String)
    {
        let alert = UIAlertController(title: "Question", message: description, preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
        alert.addAction(cancelAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    //MARK: - UI Action
    @IBAction func selectCard(sender: AnyObject)
    {
        let idx = Int(self.currentIndex)
        self.selectedCard(myCards[idx])
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