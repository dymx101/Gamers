//
//  HomeVideoCell.swift
//  Gamers
//
//  Created by 虚空之翼 on 15/8/9.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

import UIKit

class HomeVideoCell: UITableViewCell {

    @IBOutlet weak var videoImage: UIImageView!
    @IBOutlet weak var videoTitle: UILabel!
    @IBOutlet weak var channelName: UILabel!
    @IBOutlet weak var videoViews: UILabel!
    
    var delegate: MyCellDelegate!
    
    // 点击触发自己的代理方法
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
        channelName.text = video.owner
        videoTitle.text = video.videoTitle
        videoViews.text = BasicFunction.formatViewsTotal(video.views) + "  •  " + BasicFunction.formatDateString(video.publishedAt)
        
        let imageUrl = video.imageSource.stringByReplacingOccurrencesOfString(" ", withString: "%20", options: NSStringCompareOptions.LiteralSearch, range: nil)
        videoImage.hnk_setImageFromURL(NSURL(string: imageUrl)!)
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
