//
//  LiveLargeCell.swift
//  Gamers
//
//  Created by 虚空之翼 on 15/8/12.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

import UIKit

class LiveLargeCell: UITableViewCell {

    @IBOutlet weak var videoImage: UIImageView!
    @IBOutlet weak var videoViews: UILabel!
    @IBOutlet weak var videoChannel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setLiveData(liveData: Live) {
        videoChannel.text = liveData.user.userName
        videoViews.text = liveData.stream.steamDescription
        
        let imageUrl = liveData.stream.thumbnail.large.stringByReplacingOccurrencesOfString(" ", withString: "%20", options: NSStringCompareOptions.LiteralSearch, range: nil)
        videoImage.hnk_setImageFromURL(NSURL(string: imageUrl)!)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        videoImage.hnk_cancelSetImage()
        videoImage.image = nil
    }
    
}
