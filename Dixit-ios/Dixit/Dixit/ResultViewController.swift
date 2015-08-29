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
    var cards: [Card] = [Card]()
    
    lazy var photoSource : MyPhotoDelegate = { return MyPhotoDelegate() }()
    
    required init(coder aDecoder: NSCoder)
    {
        network = SFNetwork.sharedInstance
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
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("onAllPlayersGuessedCards:"), name: TaskType.AllUserGuessedCards.description, object: nil)
    }
    
    func getSelectedCards()
    {
        network.sendExtension(TaskType.GetSelectedCards.description, data: nil, room: nil) { (data, result) -> () in
            self.photoSource.setItemsSource(self.cards)
            self.reloadData()
        }
    }
    
    func guessCard()
    {
        network.sendExtension("", data: nil, room: nil) { (data, result) -> () in
            
        }
    }
    
    func onAllPlayersGuessedCards(notification: NSNotification)
    {
        if let userInfo = notification.userInfo
        {
            self.performSegueWithIdentifier("scoreSegue", sender: self)
        }
    }
}