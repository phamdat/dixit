//
//  ScoreViewController.swift
//  Dixit
//
//  Created by Tien Dat Tran on 8/22/15.
//  Copyright (c) 2015 Keyboard and Mouse. All rights reserved.
//

import Foundation
import UIKit

class ScoreViewController : BaseViewController
{    
    @IBOutlet weak var selectionResultTable: UITableView!
    @IBOutlet weak var scoreTable: UITableView!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    var users: [User] = [User]()
    var readyUsers: [User] = [User]()
    
    var _shouldGo: Bool = false;
    var shouldGo: Bool {
        get { return _shouldGo }
        set
        {
            _shouldGo = newValue
            if _shouldGo
            {
                restartGame()
            }
        }
    }

    
    lazy var scoreSource : ScoreDataSource = {
        return ScoreDataSource()
        }()
    
    lazy var selectionSource : SelectionDataSource = {
        return SelectionDataSource()
        }()
    
    required init(coder aDecoder: NSCoder)
    {
        users = UserInfo.sharedInstance.currentRoom?.userList() as! [User]
        super.init(coder: aDecoder)!
    }
    
    override func viewDidLoad() {
        self.screenName = "Score Screen"
        
        super.viewDidLoad()
        
        setupEvent()
        setupTable()
        getScore()
//        refreshTable()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func getUserById(userId: NSString) -> User?
    {
        for u in users
        {
            if u.id() == (Int)(userId as String)
            {
                return u
            }
        }
        return nil
    }
    
    private func setupEvent()
    {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("onStartGame:"), name: "start_game", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("onOtherReviewDone:"), name: TaskType.ReviewDone.description, object: nil)
    }
    
    func onOtherReviewDone(notification: NSNotification)
    {
        if let userInfo = notification.userInfo
        {
            let sender = userInfo["sender"] as! User
            readyUsers.append(sender)
            let room = userInfo["room"] as! Room
            if room.userCount() == readyUsers.count
            {
                shouldGo = true
            }
        }
    }
    
    func restartGame()
    {
        if network.me.id() == UserInfo.sharedInstance.currentHostId
        {
            network.sendExtension("start_game", data: SFSObject(), room: UserInfo.sharedInstance.currentRoom, callback: nil)
        }
    }
    
    func onStartGame(notification: NSNotification)
    {
        if let userInfo = notification.userInfo
        {
            UserInfo.sharedInstance.currentHostId = userInfo["hostId"] as! Int
            self.performSegueWithIdentifier("restartSegue", sender: self)
        }
    }
    
    private func setupTable()
    {
        scoreTable.delegate = scoreSource
        scoreTable.dataSource = scoreSource
        scoreTable.separatorColor = UIColor.clearColor()
        
        selectionResultTable.delegate = selectionSource
        selectionResultTable.dataSource = selectionSource
        selectionResultTable.separatorColor = UIColor.clearColor()
    }
    
    func getScore()
    {
        network.sendExtension("scoring", data: SFSObject(), room: nil) { (rawData, result) -> () in
            if let data = rawData as? Dictionary<NSObject, AnyObject>
            {
                var selections = Array<SelectionData>()
                
                if let cards = data["selectedCards"] as? Dictionary<NSObject, AnyObject>
                {
                    for (key, value) in cards
                    {
                        let card = Card(id: "", url: key as! String)
                        let u = self.network.getUser(Int(value as! NSNumber))
                        let selection = SelectionData(card_: card, owner_: u, selectors_: Array<User>())
                        selections.append(selection)
                    }
                }
                
                if let guessedCards = data["playerGuessedCard"] as? Dictionary<NSObject, AnyObject>
                {
                    for (key, value) in guessedCards
                    {
                        if let s = selections.filter({ i in i.card.cardUrl == (value as! String) }).first
                        {
                            let sss = (key as! String)

                            let u = self.network.getUser(Int(sss)!)
                            s.selectors.append(u)
                        }
                    }
                    self.selectionSource.items = selections
                    self.selectionResultTable.reloadData()
                }
                
                if let scores = data["playerScore"] as? Dictionary<NSObject, AnyObject>
                {
                    var source : Array<(User, CLong)> = Array<(User, CLong)>()
                    for (key, value) in scores
                    {
                        if let u = self.getUserById(key as! NSString)
                        {
                            source.append(u, ((value as! NSNumber) as Int))
                        }
                    }
                    self.scoreSource.scores = source
                    self.scoreTable.reloadData()
                }
            }
        }
    }
    
    @IBAction func doneClick(sender: AnyObject)
    {
        print("restart")
        network.sendPublicMessage(TaskType.ReviewDone.description, data: nil)
    }
}

class SelectionData
{
    var card: Card
    var owner: User
    var selectors: Array<User>
    
    init(card_: Card, owner_: User, selectors_: Array<User>)
    {
        card = card_
        owner = owner_
        selectors = selectors_
    }
}

class SelectionDataSource: NSObject, UITableViewDataSource, UITableViewDelegate
{
    let selectionCellId = "selectionCell"
    var items: [SelectionData] = []
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 124.0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(selectionCellId) as? SelectionResultCell
        if cell == nil
        {
            cell = SelectionResultCell(style: .Default, reuseIdentifier: selectionCellId)
        }
        
        let row = indexPath.row
        let data = items[row]
        cell?.imageUrl = data.card.cardUrl
        cell?.ownerName.text = data.owner.name()
        cell?.selectorNames.text = data.selectors.map({ u in u.name()}).joinWithSeparator("\n")

        if data.owner.id() == UserInfo.sharedInstance.currentHostId
        {
            cell?.ownerName.textColor = UIColor(red: 231.0 / 255.0, green: 76.0 / 255.0, blue: 60.0 / 255.0, alpha: 1.0)
        }

        return cell!
    }
}

class ScoreDataSource : NSObject, UITableViewDataSource, UITableViewDelegate
{
    let scoreCellId = "scoreCell"
    var scores : Array<(User, CLong)> = []
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scores.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44.0
    }
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell = tableView.dequeueReusableCellWithIdentifier(scoreCellId) as UITableViewCell?
        if cell == nil
        {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: scoreCellId)
        }
        
        let rowIdx = indexPath.row
        let score = scores[rowIdx]
        let playerName = cell!.viewWithTag(1) as! UILabel
        let scoreLabel = cell!.viewWithTag(2) as! UILabel
        
        playerName.text = score.0.name()
        scoreLabel.text = String(score.1)
        return cell!
    }
}