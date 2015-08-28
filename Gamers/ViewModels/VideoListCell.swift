//
//  VideoListCell.swift
//  Gamers
//
//  Created by 虚空之翼 on 15/7/27.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

import UIKit

class VideoListCell: UITableViewCell {

    @IBOutlet weak var videoImage: UIImageView!
    @IBOutlet weak var videoTitle: UILabel!
    @IBOutlet weak var videoChannel: UILabel!
    @IBOutlet weak var videoViews: UILabel!
    
    var delegate: MyCellDelegate!
    
    @IBAction func clickShare(sender: AnyObject) {
        self.delegate.clickCellButton!(self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // 视频标题自动换行以及超出省略号
        videoTitle.numberOfLines = 0
        videoTitle.lineBreakMode = NSLineBreakMode.ByCharWrapping
        videoTitle.lineBreakMode = NSLineBreakMode.ByTruncatingTail
    }
    
    func setVideo(video: Video) {
        videoChannel.text = video.owner
        videoTitle.text = video.videoTitle
        videoViews.text = String(video.views) + " 次"
        
        let imageUrl = video.imageSource.stringByReplacingOccurrencesOfString(" ", withString: "%20", options: NSStringCompareOptions.LiteralSearch, range: nil)
        videoImage.hnk_setImageFromURL(NSURL(string: imageUrl)!, placeholder: UIImage(named: "placeholder.png"))

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
