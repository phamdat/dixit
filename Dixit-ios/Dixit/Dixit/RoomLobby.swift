//
//  RoomLobby.swift
//  Dixit
//
//  Created by Tien Dat Tran on 8/15/15.
//  Copyright (c) 2015 Keyboard and Mouse. All rights reserved.
//

import Foundation
import UIKit

class RoomLobbyViewController : BaseViewController
{
    @IBOutlet weak var roomTable: UITableView!
    @IBOutlet weak var addRoomBarButton: UIBarButtonItem!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBAction func back(sender: AnyObject) {
        network.logout({result -> () in
            self.navigationController?.popViewControllerAnimated(true)
        })
    }
    
    lazy var tableDataSource : RoomTableDataSource = {
        return RoomTableDataSource(controller: self)
    }()
    
    override func viewDidLoad() {
        self.screenName = "Room Lobby Screen"
        super.viewDidLoad()        
        
        setupEvent()
        setupBarButtons()
        setupTableView()
    }
    
    override func viewWillAppear(animated: Bool)
    {
        if let rooms = network.rooms
        {
            self.tableDataSource.rooms = rooms
            roomTable.reloadData()
        }
    }
    
    func setupEvent()
    {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("onRoomAdd:"), name: TaskType.RoomAdd.description, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("onRoomRemove:"), name: TaskType.RoomRemove.description, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("onUserCountChange:"), name: TaskType.UserCountChange.description, object: nil)
//        network.addHandler(TaskType.RoomAdd, callback: EventHandlerWrapper(e: onRoomAdd))
//        network.addHandler(TaskType.RoomRemove, callback: EventHandlerWrapper(e: onRoomRemove))
    }
    
    func onRoomAdd(notification: NSNotification)
    {
        if let userInfo = notification.userInfo
        {
            let room = userInfo["room"] as! Room
            self.tableDataSource.rooms.append(room)
            self.roomTable.reloadData()
        }
    }
    
    func onRoomRemove(notification: NSNotification)
    {
        if let userInfo = notification.userInfo
        {
            let room = userInfo["room"] as! Room
            for var i = 0; i < self.tableDataSource.rooms.count; i++
            {
                let r = self.tableDataSource.rooms[i]
                
                if r.id() == room.id()
                {
                    self.tableDataSource.rooms.removeAtIndex(i)
                    break
                }
            }
            self.roomTable.reloadData()
        }
    }
    
    func onUserCountChange(notification: NSNotification)
    {
        if let userInfo = notification.userInfo
        {
            let room = userInfo["room"] as! Room
            tableDataSource.onRoomDataChange(room)
            roomTable.reloadData()
        }
    }
    
    func setupTableView()
    {
        roomTable.dataSource = tableDataSource
        roomTable.delegate = tableDataSource
        roomTable.separatorColor = UIColor.clearColor()
        roomTable.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        roomTable.backgroundColor = UIColor(red: 40, green: 40, blue: 40, alpha: 1)
        roomTable.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        roomTable.scrollIndicatorInsets = roomTable!.contentInset
        
        
        
//        roomTable.estimatedRowHeight = 44
//        roomTable.rowHeight = UITableViewAutomaticDimension
    }
    
    func setupBarButtons()
    {
        FontHelper.ApplyFont(addRoomBarButton, fontName: "streamline-24px", fontCharacter: "\u{e2ab}", size: 16)
        FontHelper.ApplyFont(backButton, fontName: "streamline-24px", fontCharacter: "\u{e62b}", size: 16)
    }
    
    func joinRoom(room : Room)
    {
        network.joinRoom(room, callback: {
            (result : Result) -> () in
            UserInfo.sharedInstance.currentRoom = room
            self.performSegueWithIdentifier("joinRoomSegue", sender: self)
        })
    }
    
}

class RoomTableDataSource : NSObject, UITableViewDataSource, UITableViewDelegate
{
    let simpleTableIdentifier = "simpleTableIdentifier"
    
    var rooms : [Room] = [Room]()
    
    var controller : RoomLobbyViewController?
    
    init(controller : RoomLobbyViewController)
    {
        self.controller = controller
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return rooms.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 95.0
    }
    
    func onRoomDataChange(room: Room)
    {
        
    }
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell = tableView.dequeueReusableCellWithIdentifier(simpleTableIdentifier) as UITableViewCell?
        if cell == nil
        {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: simpleTableIdentifier)
        }
        
        let room = rooms[indexPath.row] as Room
        let roomName = cell?.viewWithTag(1) as! UILabel
        let hostName = cell?.viewWithTag(2) as! UILabel
        let quota = cell?.viewWithTag(3) as! UILabel

        let users = room.userList() as? [User]
        let host = users?.filter { u in u.playerId() == 1 }
                        .first as User?

        roomName.text = room.name()
        quota.text = "\(room.userCount()) / \(room.maxUsers())"
        hostName.text = "\(host?.name())"
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        controller?.joinRoom(rooms[indexPath.row])

    }
}