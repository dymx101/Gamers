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
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
