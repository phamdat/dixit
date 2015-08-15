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
    
    lazy var tableDataSource : RoomTableDataSource = {
        return RoomTableDataSource(controller: self)
    }()
    
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupEvent()
        setupBarButtons()
        setupTableView()
    }
    
    override func viewWillAppear(animated: Bool) {
        if let rooms = network.rooms as? [Room]
        {
            self.tableDataSource.rooms = rooms
            roomTable.reloadData()
        }
    }
    
    func setupEvent()
    {
        network.incomingData = { (taskType : TaskType, data : AnyObject?) -> () in
            
            switch taskType
            {
            case TaskType.RoomAdd:
                if let room = data as? Room
                {
                    self.tableDataSource.rooms.append(room)
                    self.roomTable.reloadData()
                }
                break
            case TaskType.RoomRemove:
                if let room = data as? Room
                {
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
                break
            default:
                break
            }
        }
    }
    
    func setupTableView()
    {
        roomTable.dataSource = tableDataSource
        roomTable.delegate = tableDataSource
        roomTable.separatorColor = UIColor.clearColor()
        roomTable.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
        roomTable.backgroundColor = UIColor(red: 40, green: 40, blue: 40, alpha: 1)
        roomTable.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        roomTable.scrollIndicatorInsets = roomTable!.contentInset
        
        
        
//        roomTable.estimatedRowHeight = 44
//        roomTable.rowHeight = UITableViewAutomaticDimension
    }
    
    func setupBarButtons()
    {
        FontHelper.ApplyFont(addRoomBarButton, fontName: "streamline-24px", fontCharacter: UniChar(0xe2ab), size: 16)
        addRoomBarButton.target = self
        addRoomBarButton.action = Selector("addRoom:")
    }
    
    func addRoom(sender : UIBarButtonItem) -> ()
    {
        println("add room")
        network.createRoom({ result -> () in
            println("tao xong roi ne, join ne")
            switch result
            {
            case Result.Success(let room):
                UserInfo.sharedInstance.currentRoom = room as? Room
                self.performSegueWithIdentifier("joinRoomSegue", sender: self)
                break
            default:
                break
            }
        })
        
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
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell = tableView.dequeueReusableCellWithIdentifier(simpleTableIdentifier) as? UITableViewCell
        if cell == nil
        {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: simpleTableIdentifier)
        }
        
        let room = rooms[indexPath.row] as Room
        let roomName = cell?.viewWithTag(1) as! UILabel
        roomName.text = room.name()
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        UserInfo.sharedInstance.currentRoom = rooms[indexPath.row]
        controller?.joinRoom(rooms[indexPath.row])

    }
}