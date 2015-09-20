//
//  SelectionResultCell.swift
//  Dixit
//
//  Created by Tien Dat Tran on 9/20/15.
//  Copyright © 2015 Keyboard and Mouse. All rights reserved.
//

import Foundation

class SelectionResultCell : UITableViewCell
{
    @IBOutlet var ImageView: UIImageView!
    @IBOutlet var ownerName: UILabel!
    @IBOutlet var selectorNames: UITextView!
    
    var downloadImageManager: SDWebImageManager
    
    var _imageUrl: String
    var imageUrl: String {
        get { return _imageUrl }
        set
        {
            _imageUrl = newValue
            loadImage(_imageUrl)
        }
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        _imageUrl = ""
        downloadImageManager = SDWebImageManager.sharedManager()
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        _imageUrl = ""
        downloadImageManager = SDWebImageManager.sharedManager()
        super.init(coder: aDecoder)
    }
    
    func loadImage(url: String)
    {
        downloadImageManager.downloadImageWithURL(NSURL(string: url), options: .HighPriority, progress: { (receivedSize, expectedSize) in
            
            }, completed: {(image, error, cacheType, finished, url) in
                dispatch_async(dispatch_get_main_queue()){
                    self.ImageView.image = image
                }
        })
    }
    
}