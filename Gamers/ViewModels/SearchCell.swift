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
        videoViews.text = BasicFunction.formatViewsTotal(video.views) + "  •  " + BasicFunction.formatDateString(video.publishedAt)
        
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
    
    
    
}
