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
        let contentString: NSMutableAttributedString = NSMutableAttributedString(string: "[" + FormatDate(commentData.publishedAt) + "]" + commentData.authorDisplayName + ": " + filterHTML(commentData.textDisplay))
        let fontRange: NSRange = NSMakeRange(12, NSString(string: commentData.authorDisplayName).length + 2)
        // 名字随机颜色
        let color = CGFloat(CGFloat(random())/CGFloat(RAND_MAX))
        let color1 = CGFloat(CGFloat(random())/CGFloat(RAND_MAX))
        let color2 = CGFloat(CGFloat(random())/CGFloat(RAND_MAX))
        let color3 = CGFloat(CGFloat(random())/CGFloat(RAND_MAX))
        contentString.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: color, green: color1, blue: color2, alpha: 1), range: fontRange)
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
    
    // 过滤HTML标签
    func filterHTML(html: String) -> String {
        let newHtml = html.stringByDecodingHTMLEntities
        let regex:NSRegularExpression  = NSRegularExpression(
            pattern: "<.*?>",
            options: NSRegularExpressionOptions.CaseInsensitive,
            error: nil)!
        
        
        let range = NSMakeRange(0, count(newHtml))
        let htmlLessString :String = regex.stringByReplacingMatchesInString(newHtml,
            options: NSMatchingOptions.allZeros,
            range:range ,
            withTemplate: "")
        
        return htmlLessString
    }
    
    // 格式化时间，暂时取前10
    func FormatDate(theDate: String) -> String {
        return (theDate as NSString).substringToIndex(10)
    }
    
    
    
    
    
    
    
}

private let characterEntities : [ String : Character ] = [
    // XML predefined entities:
    "&quot;"    : "\"",
    "&amp;"     : "&",
    "&apos;"    : "'",
    "&lt;"      : "<",
    "&gt;"      : ">",
    
    // HTML character entity references:
    "&nbsp;"    : "\u{00a0}",
    // ...
    "&diams;"   : "♦",
]

extension String {
    
    /// Returns a new string made by replacing in the `String`
    /// all HTML character entity references with the corresponding
    /// character.
    var stringByDecodingHTMLEntities : String {
        
        // ===== Utility functions =====
        
        // Convert the number in the string to the corresponding
        // Unicode character, e.g.
        //    decodeNumeric("64", 10)   --> "@"
        //    decodeNumeric("20ac", 16) --> "€"
        func decodeNumeric(string : String, base : Int32) -> Character? {
            let code = UInt32(strtoul(string, nil, base))
            return Character(UnicodeScalar(code))
        }
        
        // Decode the HTML character entity to the corresponding
        // Unicode character, return `nil` for invalid input.
        //     decode("&#64;")    --> "@"
        //     decode("&#x20ac;") --> "€"
        //     decode("&lt;")     --> "<"
        //     decode("&foo;")    --> nil
        func decode(entity : String) -> Character? {
            
            if entity.hasPrefix("&#x") || entity.hasPrefix("&#X"){
                return decodeNumeric(entity.substringFromIndex(advance(entity.startIndex, 3)), 16)
            } else if entity.hasPrefix("&#") {
                return decodeNumeric(entity.substringFromIndex(advance(entity.startIndex, 2)), 10)
            } else {
                return characterEntities[entity]
            }
        }
        
        // ===== Method starts here =====
        
        var result = ""
        var position = startIndex
        
        // Find the next '&' and copy the characters preceding it to `result`:
        while let ampRange = self.rangeOfString("&", range: position ..< endIndex) {
            result.extend(self[position ..< ampRange.startIndex])
            position = ampRange.startIndex
            
            // Find the next ';' and copy everything from '&' to ';' into `entity`
            if let semiRange = self.rangeOfString(";", range: position ..< endIndex) {
                let entity = self[position ..< semiRange.endIndex]
                position = semiRange.endIndex
                
                if let decoded = decode(entity) {
                    // Replace by decoded character:
                    result.append(decoded)
                } else {
                    // Invalid entity, copy verbatim:
                    result.extend(entity)
                }
            } else {
                // No matching ';'.
                break
            }
        }
        // Copy remaining characters to `result`:
        result.extend(self[position ..< endIndex])
        return result
    }
}
