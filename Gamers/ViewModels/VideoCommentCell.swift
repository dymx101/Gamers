//
//  VideoCommentCell.swift
//  Gamers
//
//  Created by 虚空之翼 on 15/8/3.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

import UIKit

class VideoCommentCell: UITableViewCell {
    
    @IBOutlet weak var userNameAndComment: UILabel!
    //@IBOutlet weak var commentFloor: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setComment(commentData: YTVComment) {
        //self.userNameAndComment.text = commentData.userName + ": " + commentData.content
        let dateString = BasicFunction.formatDateString(commentData.publishedAt)
        let contentString: NSMutableAttributedString = NSMutableAttributedString(string: "[" + dateString + "]" + commentData.authorDisplayName + ": " + BasicFunction.filterHTML(commentData.textDisplay))
        let fontRange: NSRange = NSMakeRange(NSString(string: dateString).length + 2, NSString(string: commentData.authorDisplayName).length + 2)
        // 名字随机颜色
//        let color = CGFloat(CGFloat(random())/CGFloat(RAND_MAX))
//        let color1 = CGFloat(CGFloat(random())/CGFloat(RAND_MAX))
//        let color2 = CGFloat(CGFloat(random())/CGFloat(RAND_MAX))
//        let color3 = CGFloat(CGFloat(random())/CGFloat(RAND_MAX))
//        contentString.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: color, green: color1, blue: color2, alpha: 1), range: fontRange)
        let fontRange2: NSRange = NSMakeRange(0, NSString(string: dateString).length + 2)
        contentString.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 0, green: 0, blue: 0, alpha: 0.5), range: fontRange2)
        contentString.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 20/255.0, green: 155/255.0, blue: 213/255.0, alpha: 1), range: fontRange) //暂定谈蓝色
        
        userNameAndComment.attributedText = contentString
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // 重写cell高度
    override func sizeThatFits(size: CGSize) -> CGSize {
        var totalHeight: CGFloat = 0
        totalHeight += self.userNameAndComment.sizeThatFits(size).height
        totalHeight += 22
        return CGSizeMake(size.width, totalHeight)
    }

    
}
