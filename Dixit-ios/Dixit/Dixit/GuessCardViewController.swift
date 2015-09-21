//
//  ResultViewController.swift
//  Dixit
//
//  Created by Tien Dat Tran on 8/22/15.
//  Copyright (c) 2015 Keyboard and Mouse. All rights reserved.
//

import Foundation
import UIKit

class GuessCardViewController : MWPhotoBrowser
{
    @IBOutlet weak var guessButton: UIBarButtonItem!
    
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
    
    required init?(coder aDecoder: NSCoder)
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

        self.screenName = "Guess Card Screen"
        
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("onOtherPlayersGuessedCards:"), name: "guest_guess_card", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("onGetSelectedCards:"), name: "selected_card", object: nil)
        
        if network.me.id() == UserInfo.sharedInstance.currentHostId
        {
            guessButton.enabled = false
        }
        
        getAllSelectedCards()
    }
    
    func getAllSelectedCards()
    {
        if network.isHost
        {
            network.sendExtension("selected_card", data: SFSObject(), room: nil, callback: nil);
        }
    }
    
    func sendGuessedCard(card: Card?)
    {
        if network.me.id() != UserInfo.sharedInstance.currentHostId
        {
            if let c = card
            {
                let cardIdDictionary = ["cardId": c.cardId]
                let jsonData = try? NSJSONSerialization.dataWithJSONObject(cardIdDictionary, options: NSJSONWritingOptions(rawValue: 0))
                let jsonString = NSString(data: jsonData!, encoding: NSUTF8StringEncoding) as! String
                
                let data = SFSObject()
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
        let idx = Int(self.currentIndex)
        sendGuessedCard(selectedCards[idx])
    }
}