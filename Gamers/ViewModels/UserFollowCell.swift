//
//  UserFollowCell.swift
//  Gamers
//
//  Created by 虚空之翼 on 15/8/31.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

import UIKit

class UserFollowCell: UITableViewCell {

    @IBOutlet weak var channelImage: UIImageView!
    @IBOutlet weak var channelName: UILabel!
    
    @IBAction func clickUnFollow(sender: AnyObject) {
        self.delegate.clickCellUnFollow!(self)
    }
    
    var delegate: ChannelCellDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //设置圆角
        channelImage.clipsToBounds = true
        channelImage.layer.cornerRadius = 10
        //边框
        channelImage.layer.borderWidth = 1
        channelImage.layer.borderColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.7).CGColor
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setUserData(userData: User) {
        channelName.text = userData.userName
        
        let imageUrl = userData.avatar.stringByReplacingOccurrencesOfString(" ", withString: "%20", options: NSStringCompareOptions.LiteralSearch, range: nil)
        channelImage.hnk_setImageFromURL(NSURL(string: imageUrl)!, placeholder: UIImage(named: "placeholder.png"))
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        channelImage.hnk_cancelSetImage()
        channelImage.image = nil
    }
    
}
