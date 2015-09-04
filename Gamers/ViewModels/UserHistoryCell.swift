//
//  PlayHistoryCell.swift
//  Gamers
//
//  Created by 虚空之翼 on 15/8/26.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

import UIKit

class UserHistoryCell: UITableViewCell {
    
    @IBOutlet weak var videoImage: UIImageView!
    @IBOutlet weak var videoTitle: UILabel!
    @IBOutlet weak var videoChannel: UILabel!
    @IBOutlet weak var videoPlayDate: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // 视频标题自动换行以及超出省略号
        videoTitle.numberOfLines = 0
        videoTitle.lineBreakMode = NSLineBreakMode.ByCharWrapping
        videoTitle.lineBreakMode = NSLineBreakMode.ByTruncatingTail
    }
    
    func setVideo(videoData: Video) {
        videoChannel.text = videoData.owner
        videoTitle.text = videoData.videoTitle
        //videoPlayDate.text = "在 " + video.playDate.date + " 播放"
        var dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US") // zh_CN  en_US
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        videoPlayDate.text = "在 " + dateFormatter.stringFromDate(videoData.playDate) + " 播放"

        let imageUrl = videoData.imageSource.stringByReplacingOccurrencesOfString(" ", withString: "%20", options: NSStringCompareOptions.LiteralSearch, range: nil)
        videoImage.hnk_setImageFromURL(NSURL(string: imageUrl)!)
    }
    

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        videoImage.hnk_cancelSetImage()
        videoImage.image = nil
    }


}
