//
//  RoomDetailViewController.swift
//  Dixit
//
//  Created by Tien Dat Tran on 8/15/15.
//  Copyright (c) 2015 Keyboard and Mouse. All rights reserved.
//

import Foundation
import UIKit

class RoomDetailViewController : BaseViewController
{
    @IBOutlet weak var participantTable: UITableView!    
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var quitBarButton: UIBarButtonItem!
    @IBOutlet weak var startBarButton: UIBarButtonItem!
    
    lazy var playerSource : ParticipantTableSource = {
        return ParticipantTableSource()
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupEvent()
        setupBarButtons()
        setupTable()

        refreshTable()
    }
    
    override func viewDidDisappear(animated: Bool)
    {
        super.viewDidDisappear(animated)

        NSNotificationCenter.defaultCenter().removeObserver(self)
    }   
    
    private func refreshTable()
    {
        if let players = self.getCurrentPlayers()
        {
            playerSource.players = players
            participantTable.reloadData()
        }
    }
    
    private func setupEvent()
    {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("onStartGame:"), name: "start_game", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("onUserExitRoom:"), name: TaskType.UserExitRoom.description, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("onUserEnterRoom:"), name: TaskType.UserEnterRoom.description, object: nil)
    }
    
    func onStartGame(notification: NSNotification)
    {
        if let userInfo = notification.userInfo
        {
            UserInfo.sharedInstance.currentHostId = userInfo["hostId"] as! Int
            self.performSegueWithIdentifier("startSegue", sender: self)
        }
    }
    
    func onUserEnterRoom(notification: NSNotification)
    {
        self.refreshTable()
    }

    func onUserExitRoom(notification: NSNotification)
    {
        self.refreshTable()
    }

    private func setupTable()
    {
        participantTable.delegate = playerSource
        participantTable.dataSource = playerSource
        participantTable.separatorColor = UIColor.clearColor()
    }
    
    private func setupBarButtons()
    {
        quitBarButton.target = self
        quitBarButton.action = Selector("quitRoom:")
        
        startBarButton.target = self
        startBarButton.action = Selector("startGame:")
    }
    
    private func getCurrentPlayers() -> [User]?
    {
        return network.getUsers()
    }
    
    func startGame(sender : UIBarButtonItem) -> ()
    {
        println("start game")
        let obj = SFSObject()
        network.sendExtension("start_game", data: obj, room: UserInfo.sharedInstance.currentRoom, callback: nil)

    }
    
    func quitRoom(sender : UIBarButtonItem) -> ()
    {
        println("request leave room")
        network.leaveRoom({ (result : Result) -> () in
            println("leave room success")
        })
        
        for controller in self.navigationController!.viewControllers
        {
            if controller is RoomLobbyViewController
            {
                self.navigationController?.popToViewController(controller as! UIViewController, animated: true)
            }
        }
    }
}

class ParticipantTableSource : NSObject, UITableViewDataSource, UITableViewDelegate
{
    let participantCell = "participantCell"
    var players : [User] = [User]()    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44.0
    }
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell = tableView.dequeueReusableCellWithIdentifier(participantCell) as? UITableViewCell
        if cell == nil
        {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: participantCell)
        }
        
        let rowIdx = indexPath.row
        let player = players[rowIdx]
        let avatar = cell!.viewWithTag(1)
        let playerName = cell!.viewWithTag(2) as! UILabel
        
        playerName.text = player.name()
        
        return cell!
    }
}