//
//  SeachCell.swift
//  Gamers
//
//  Created by 虚空之翼 on 15/7/27.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

import UIKit

class SearchCell: UITableViewCell {
    
    @IBOutlet weak var videoImage: UIImageView!
    @IBOutlet weak var videoTitle: UILabel!
    @IBOutlet weak var videoChannel: UILabel!
    @IBOutlet weak var videoViews: UILabel!
    
    @IBAction func clickShare(sender: AnyObject) {
        self.delegate.clickCellButton!(self)
    }
    
    
    var delegate: MyCellDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setVideo(video: Video) {
        videoChannel.text = video.owner
        videoTitle.text = video.videoTitle
        //videoViews.text = String(video.views) + " 次"
        videoViews.text = FormatTotal(video.views) + "  •  " + FormatDate(video.publishedAt)
        
        let imageUrl = video.imageSource.stringByReplacingOccurrencesOfString(" ", withString: "%20", options: NSStringCompareOptions.LiteralSearch, range: nil)
        videoImage.hnk_setImageFromURL(NSURL(string: imageUrl)!)
    }

    override func setHighlighted(highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        
        if highlighted {
            self.delegate.hideKeyboard!(self)
        }

    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        videoImage.hnk_cancelSetImage()
        videoImage.image = nil
    }
    
    // 数量格式化
    func FormatTotal(theTotal: Int) -> String {
        var totalString = ""
        
        if theTotal < 1_000 {
            totalString = "\(theTotal)次观看"
        } else if theTotal < 10_000 {
            totalString = "\(theTotal / 1_000)千次观看"
        } else {
            totalString = "\(theTotal / 10_000)万次观看"
        }
        
        return totalString
    }
    
    // 时间格式化
    func FormatDate(theDate: String) -> String {
        let DATE_TIME_MINUTEX = 60
        let DATE_TIME_HOURS = 60 * 60
        let DATE_TIME_DAYTIME = 60 * 60 * 24
        let DATE_TIME_WEEK = 60 * 60 * 24 * 7
        let DATE_TIME_MONTH = 60 * 60 * 24 * 30
        let DATE_TIME_YEAR = 60 * 60 * 24 * 365
        let DATE_ONETHOUSAND = 1000
        
        var dataString = ""
        
        let dateFormatter = NSDateFormatter()
        //        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        //        dateFormatter.timeZone = NSTimeZone(name: "GMT")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        
        if dateFormatter.dateFromString(theDate) == nil {
            return ""
        }
        
        let dateValue = dateFormatter.dateFromString(theDate)!.timeIntervalSince1970
        var now = NSDate().dateByAddingTimeInterval(0).timeIntervalSince1970
        
        var cha = Int(now - dateValue)
        
        
        if cha / DATE_TIME_HOURS < 1 {
            dataString = "\(cha / DATE_TIME_MINUTEX)分钟前"
        } else if cha / DATE_TIME_DAYTIME < 1 {
            dataString = "\(cha / DATE_TIME_HOURS)小时前"
        } else if cha / DATE_TIME_WEEK < 1 {
            dataString = "\(cha / DATE_TIME_DAYTIME)天前"
        } else if cha / DATE_TIME_MONTH < 1 {
            dataString = "\(cha / DATE_TIME_WEEK)周前"
        } else if cha / DATE_TIME_YEAR < 1 {
            dataString = "\(cha / DATE_TIME_MONTH)个月前"
        } else {
            dataString = "\(cha / DATE_TIME_YEAR)年前"
        }
        
        return dataString
        
    }
}
