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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // 设置边框及颜色
        imageView.layer.borderWidth = 0.4
        imageView.layer.borderColor = UIColor.lightGrayColor().CGColor
        
    }
    
    func setGameData(gameData: Game) {
        let imageUrl = gameData.imageSource.stringByReplacingOccurrencesOfString(" ", withString: "%20", options: NSStringCompareOptions.LiteralSearch, range: nil)
        imageView.hnk_setImageFromURL(NSURL(string: imageUrl)!, placeholder: UIImage(named: "game-front-cover.png"))
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.hnk_cancelSetImage()
        imageView.image = nil
    }

}

