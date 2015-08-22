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
    
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupEvent()
        setupBarButtons()
        setupTable()

        refreshTable()
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
        network.incomingData.append({ (taskType, data) -> () in
            
            switch taskType
            {
            case TaskType.UserEnterRoom:
                self.refreshTable()
                break
            case TaskType.UserExitRoom:
                self.refreshTable()
                break
            default:
                break
            }
        })
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