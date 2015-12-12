//
//  BaseViewController.swift
//  Dixit
//
//  Created by Tien Dat Tran on 8/15/15.
//  Copyright (c) 2015 Keyboard and Mouse. All rights reserved.
//

import Foundation
import UIKit
import GoogleMobileAds

class BaseViewController : GAITrackedViewController
{
    var network : SFNetwork
    
    @IBOutlet weak var bannerView: GADBannerView!
    required init?(coder aDecoder: NSCoder)
    {
        network = SFNetwork.sharedInstance
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let adId = DixitConfig.adMobConfig.bannerId
        let posY = self.view.bounds.height - Utilities.GetBannerHeight()
        let bannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait, origin: CGPoint(x: 0, y: posY))
        bannerView.backgroundColor = UIColor.blueColor()
        self.view.addSubview(bannerView)
        
        bannerView.adUnitID = adId
        bannerView.rootViewController = self
        bannerView.loadRequest(GADRequest())
    }

}