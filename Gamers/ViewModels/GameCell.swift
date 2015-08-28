//
//  GameCell.swift
//  Gamers
//
//  Created by 虚空之翼 on 15/7/20.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

import UIKit

class GameCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textLabel: UILabel!
    

    
    override func prepareForReuse() {
        imageView.hnk_cancelSetImage()
        imageView.image = nil
    }
    
    
    
}

