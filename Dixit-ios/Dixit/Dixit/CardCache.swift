//
//  CardCache.swift
//  Dixit
//
//  Created by Tien Dat Tran on 9/20/15.
//  Copyright © 2015 Keyboard and Mouse. All rights reserved.
//

//import Foundation
//
//class CardCache
//{
//    static let Instance = CardCache()
//    
//    var cardInfos: Dictionary<String, Card>
//    
//    init()
//    {
//        cardInfos = Dictionary<String, Card>()
//    }
//    
//    func addCard(card: Card)
//    {
//        if let _ = cardInfos[card.cardId]
//        {
//            print("Card already existed")
//        }
//        
//        cardInfos[card.cardUrl] = card
//    }
//    
//    func getCard(key: String) -> Card?
//    {
//        if let _ = cardInfos[key]
//        {
//            return cardInfos[key]!
//        }
//        else
//        {
//            let card = Card(id: "f75b5d9f119f76cbd1fb0432d99d69e8", url: "https://raw.githubusercontent.com/phamdat/dixit/develop/Dixit-document/Dixit/f75b5d9f119f76cbd1fb0432d99d69e8.jpg")
//            return card
//        }
//    }
//}