//
//  GameHeaderCell.swift
//  Gamers
//
//  Created by 虚空之翼 on 15/8/10.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

import UIKit

class GameHeaderCell: UITableViewCell {

    @IBOutlet weak var gameImage: UIImageView!
    @IBOutlet weak var gameName: UILabel!
    @IBOutlet weak var gameDetail: UILabel!
 
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        gameImage.hnk_cancelSetImage()
        gameImage.image = nil
    }
    
}
