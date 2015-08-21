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
    
    func setComment(commentData: Comment) {
        self.userNameAndComment.text = commentData.userName + ": " + commentData.content
        //self.commentFloor.text = "1楼"

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
