//
//  ResultViewController.swift
//  Dixit
//
//  Created by Tien Dat Tran on 8/22/15.
//  Copyright (c) 2015 Keyboard and Mouse. All rights reserved.
//

import Foundation
import UIKit

class ResultViewController : MWPhotoBrowser
{
    var network : SFNetwork
    var selectedCard: Card?
    var selectedCards: [Card] = [Card]()
    var decidedUsers: [User] = [User]()
    var users: [User] = [User]()
    
    var _shouldGo: Bool = false;
    var shouldGo: Bool {
        get { return _shouldGo }
        set
        {
            _shouldGo = newValue
            if _shouldGo
            {
                self.performSegueWithIdentifier("scoreSegue", sender: self)
            }
        }
    }

    
    lazy var photoSource : MyPhotoDelegate = { return MyPhotoDelegate() }()
    
    required init(coder aDecoder: NSCoder)
    {
        network = SFNetwork.sharedInstance
        users = UserInfo.sharedInstance.currentRoom?.userList() as! [User]
        super.init(coder: aDecoder)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewDidLoad()
    {
        self.delegate = photoSource
        self.zoomPhotosToFill = false
        self.enableGrid = true
        self.startOnGrid = true
        self.alwaysShowControls = true
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("onOtherPlayersGuessedCards:"), name: "guest_guess_card", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("onGetSelectedCards:"), name: "selected_card", object: nil)
        
        getAllSelectedCards()
    }
    
    func getAllSelectedCards()
    {
        if network.me.id() == UserInfo.sharedInstance.currentHostId
        {
            network.sendExtension("selected_card", data: SFSObject(), room: nil, callback: nil);
        }
    }
    
    func guessCard(card: Card?)
    {
        if network.me.id() != UserInfo.sharedInstance.currentHostId
        {
            if let c = card
            {
                var cardIdDictionary = ["cardId": c.cardId]
                let jsonData = NSJSONSerialization.dataWithJSONObject(cardIdDictionary, options: NSJSONWritingOptions(0), error: nil)
                let jsonString = NSString(data: jsonData!, encoding: NSUTF8StringEncoding) as! String
                
                var data = SFSObject()
                data.putUtfString("request", value: jsonString)

                network.sendExtension("guest_guess_card", data: data, room: nil) { (data, result) -> () in
                    
                }
            }
        }
    }
    
    func onGetSelectedCards(notification: NSNotification)
    {
        if let userInfo = notification.userInfo
        {
            let cards = userInfo["cards"] as! Array<NSDictionary>
            
            for c in cards
            {
                let id = c["id"] as! String
                let url = c["url"] as! String
                selectedCards.append(Card(id: id, url: url))
            }
            photoSource.setItemsSource(selectedCards)
            self.reloadData()
        }
    }
    
    func getUserById(userId: Int) -> User?
    {
        for u in users
        {
            if u.id() == userId
            {
                return u
            }
        }
        return nil
    }
    
    func onOtherPlayersGuessedCards(notification: NSNotification)
    {
        if let userInfo = notification.userInfo
        {
            let senderId = userInfo["playerId"] as! Int
            
            if let sender = getUserById(senderId)
            {
                decidedUsers.append(sender)
            }
            if (users.count - 1) == decidedUsers.count
            {
                shouldGo = true
            }
        }
    }
    @IBAction func guessCard(sender: AnyObject) {
        selectedCard = selectedCards[0]
        guessCard(selectedCard)
    }
}