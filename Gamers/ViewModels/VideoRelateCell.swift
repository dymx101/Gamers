//
//  VideoRelateCell.swift
//  Gamers
//
//  Created by 虚空之翼 on 15/8/3.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

import UIKit

class VideoRelateCell: UITableViewCell {
    
    
    @IBOutlet weak var videoImage: UIImageView!
    @IBOutlet weak var videoTitle: UILabel!
    @IBOutlet weak var videoViews: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()

        // 视频标题自动换行以及超出省略号
        videoTitle.numberOfLines = 0
        videoTitle.lineBreakMode = NSLineBreakMode.ByCharWrapping
        videoTitle.lineBreakMode = NSLineBreakMode.ByTruncatingTail
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
