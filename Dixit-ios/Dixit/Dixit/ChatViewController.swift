//
//  ChatViewController.swift
//  Dixit
//
//  Created by Tien Dat Tran on 8/24/15.
//  Copyright (c) 2015 Keyboard and Mouse. All rights reserved.
//

import Foundation

class ChatViewController : JSQMessagesViewController
{
    var messages: Array<JSQMessage>
    var incomingBubbleImageData: JSQMessagesBubbleImage
    var outgoingBubbleImageData: JSQMessagesBubbleImage
    
    required init(coder aDecoder: NSCoder) {
        
        let bubbleFactory = JSQMessagesBubbleImageFactory()
        outgoingBubbleImageData = bubbleFactory.outgoingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleLightGrayColor())
        incomingBubbleImageData = bubbleFactory.incomingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleGreenColor())
        

        messages = [JSQMessage]()
        
        let msg = JSQMessage(senderId: "1", senderDisplayName: "Kem", date: NSDate.distantPast() as! NSDate, text: "test cai coi")

        let msg1 = JSQMessage(senderId: "2111", senderDisplayName: "Bill Gates", date: NSDate.distantPast() as! NSDate, text: "a duuuuu")
        
        messages.append(msg)
        messages.append(msg1)
        
        super.init(coder: aDecoder)
        
        self.senderId = "1"
        self.senderDisplayName = "Kem"
    }
    
    //MARK: - JSQMessagesViewController method overrides
    
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
        let msg = JSQMessage(senderId: senderId, senderDisplayName: senderDisplayName, date: date, text: text)
        self.messages.append(msg)
        self.finishSendingMessageAnimated(true)
    }
    
    //MARK: - JSQMessages CollectionView DataSource
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = messages[indexPath.item]
        if message.senderId == self.senderId
        {
            return self.outgoingBubbleImageData
        }
        else
        {
            return self.incomingBubbleImageData
        }
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForCellTopLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
        if indexPath.item % 3 == 0
        {
            let msg = self.messages[indexPath.item]
            return JSQMessagesTimestampFormatter.sharedFormatter().attributedTimestampForDate(msg.date)
        }
        
        return nil
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString!
    {        
        let msg = self.messages[indexPath.item]
        if msg.senderId == self.senderId
        {
            return nil
        }
        
        return NSAttributedString(string: msg.senderDisplayName)
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForCellBottomLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
        return nil
    }
    
    //MARK: - UICollectionView DataSource
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath) as! JSQMessagesCollectionViewCell
        let msg = self.messages[indexPath.item]
        
        if !msg.isMediaMessage
        {
            if msg.senderId == self.senderId
            {
                cell.textView.textColor = UIColor.blackColor()
            }
            else
            {
                cell.textView.textColor = UIColor.whiteColor()
            }
        }
        
        return cell
    }
}