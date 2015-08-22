//
//  GameViewController.swift
//  Dixit
//
//  Created by Tien Dat Tran on 8/22/15.
//  Copyright (c) 2015 Keyboard and Mouse. All rights reserved.
//

import Foundation
import UIKit

class GameViewController : MWPhotoBrowser
{
    var network : SFNetwork
    
    lazy var photoSource : MyPhotoDelegate = { return MyPhotoDelegate() }()
    
    required init(coder aDecoder: NSCoder)
    {
        network = SFNetwork.sharedInstance
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        
        // do something before calling super viewdidload otherwise, it does not work
        self.delegate = photoSource
        self.zoomPhotosToFill = false
        self.enableGrid = true
        self.startOnGrid = true
        self.alwaysShowControls = true
        
        self.showNextPhotoAnimated(true)
        self.showPreviousPhotoAnimated(true)
        
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true
    }
}

class DixitImage
{
    var image : MWPhoto?
    var selected : Bool
    
    init (url : String)
    {
        self.selected = false
        image = MWPhoto(URL: NSURL(string: url))
    }
}

class MyPhotoDelegate : NSObject, MWPhotoBrowserDelegate
{
    var images : [DixitImage] = [DixitImage]()
    
    override init ()
    {
        images.append(DixitImage(url: "http://2.bp.blogspot.com/-dB8yXE-M0lo/T837tmd5MFI/AAAAAAAAGi8/OTWE3mZWqsE/s16000/001.png"))
        images.append(DixitImage(url: "http://2.bp.blogspot.com/-6rxIBTfCeDQ/T8371ssD4iI/AAAAAAAAGjM/PoTNvLJKyNY/s16000/003.png"))
        images.append(DixitImage(url: "http://2.bp.blogspot.com/-zFMt0OJDv3w/T837379VO4I/AAAAAAAAGjU/drRbJZm4gP4/s16000/004.png"))
        images.append(DixitImage(url: "http://2.bp.blogspot.com/-Ils1DsPv49E/T839tFJk5ZI/AAAAAAAAGoE/RePTngQiHB0/s16000/001.png"))
        images.append(DixitImage(url: "http://2.bp.blogspot.com/-QwuoKIFusF8/T83-lxWEl7I/AAAAAAAAGrA/oNIaKJ1puNE/s16000/024.png"))
        images.append(DixitImage(url: "http://2.bp.blogspot.com/-YiVIsCiFpl0/T83_HIIjrPI/AAAAAAAAGtM/DpvUlA_ImYU/s16000/040.png"))
    }
    
    func numberOfPhotosInPhotoBrowser(photoBrowser: MWPhotoBrowser!) -> UInt {
        return UInt(images.count)
    }
    
    func photoBrowser(photoBrowser: MWPhotoBrowser!, photoAtIndex index: UInt) -> MWPhotoProtocol! {
        return self.images[Int(index)].image
    }
    
    func photoBrowser(photoBrowser: MWPhotoBrowser!, thumbPhotoAtIndex index: UInt) -> MWPhotoProtocol! {
        return self.images[Int(index)].image
    }
    
//    func photoBrowser(photoBrowser: MWPhotoBrowser!, isPhotoSelectedAtIndex index: UInt) -> Bool {
//        return images[Int(index)].selected
//    }
//    
//    func photoBrowser(photoBrowser: MWPhotoBrowser!, photoAtIndex index: UInt, selectedChanged selected: Bool) {
//        selectAnImage(index, selected: selected)
//    }
//    
//    func selectAnImage(index : UInt, selected: Bool)
//    {
//        for var i = 0; i < images.count; i++
//        {
//            self.images[i].selected = false
//        }
//        images[Int(index)].selected = true
//    }
}