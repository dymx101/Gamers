//
//  ChannelHeaderCell.swift
//  Gamers
//
//  Created by 虚空之翼 on 15/8/9.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

import UIKit

class ChannelHeaderCell: UITableViewCell {
    
    @IBOutlet weak var headerImage: UIImageView!
    @IBOutlet weak var hearderTitle: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
