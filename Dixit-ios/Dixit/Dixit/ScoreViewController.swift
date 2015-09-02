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
    
    @IBOutlet weak var scoreTable: UITableView!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    var users: [User] = [User]()
    
    lazy var scoreSource : ScoreDataSource = {
        return ScoreDataSource()
        }()
    
    required init(coder aDecoder: NSCoder)
    {
        users = UserInfo.sharedInstance.currentRoom?.userList() as! [User]
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupEvent()
        setupTable()
        getScore()
//        refreshTable()
    }
    
    func getUserById(userId: NSString) -> User?
    {
        for u in users
        {
            if u.id() == (userId as? String)?.toInt()
            {
                return u
            }
        }
        return nil
    }
    
    private func setupEvent()
    {
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("onStartGame:"), name: "start_game", object: nil)
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("onUserExitRoom:"), name: TaskType.UserExitRoom.description, object: nil)
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("onUserEnterRoom:"), name: TaskType.UserEnterRoom.description, object: nil)
    }
    
    private func setupTable()
    {
        scoreTable.delegate = scoreSource
        scoreTable.dataSource = scoreSource
        scoreTable.separatorColor = UIColor.clearColor()
    }
    
    func getScore()
    {
        network.sendExtension("scoring", data: SFSObject(), room: nil) { (rawData, result) -> () in
            println("hjello")
            if let data = rawData as? Dictionary<NSObject, AnyObject>
            {
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
    
    @IBAction func doneClick(sender: AnyObject) {
        println("restart")
    }
}

class ScoreDataSource : NSObject, UITableViewDataSource, UITableViewDelegate
{
    let scoreCell = "scoreCell"
    var scores : Array<(User, CLong)> = Array<(User, CLong)>()
    
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
        var cell = tableView.dequeueReusableCellWithIdentifier(scoreCell) as? UITableViewCell
        if cell == nil
        {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: scoreCell)
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