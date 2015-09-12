//
//  YTVideoListCell.swift
//  Gamers
//
//  Created by 虚空之翼 on 15/9/11.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

import UIKit

class YTVideoListCell: UITableViewCell {
    
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
    
    func setVideo(video: YTVideo) {
        videoChannel.text = video.channelTitle
        videoTitle.text = video.title
        //videoViews.text = BasicFunction.formatViewsTotal(0) + "  •  " + BasicFunction.formatDateString(video.publishedAt)
        videoViews.text = BasicFunction.formatDateString(video.publishedAt)
        
        let imageUrl = video.thumbnailMedium.stringByReplacingOccurrencesOfString(" ", withString: "%20", options: NSStringCompareOptions.LiteralSearch, range: nil)
        videoImage.hnk_setImageFromURL(NSURL(string: imageUrl)!, placeholder: UIImage(named: "placeholder.png"))
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        videoImage.hnk_cancelSetImage()
        videoImage.image = nil
    }
    
    
}
