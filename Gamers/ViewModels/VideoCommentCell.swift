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
        let dateString = FormatDate(commentData.publishedAt)
        let contentString: NSMutableAttributedString = NSMutableAttributedString(string: "[" + dateString + "]" + commentData.authorDisplayName + ": " + filterHTML(commentData.textDisplay))
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
    
    // 过滤HTML标签
    func filterHTML(html: String) -> String {
        let newHtml = html.stringByDecodingHTMLEntities
        let regex:NSRegularExpression  = NSRegularExpression(pattern: "<.*?>", options: NSRegularExpressionOptions.CaseInsensitive, error: nil)!
        let range = NSMakeRange(0, count(newHtml))
        let htmlLessString :String = regex.stringByReplacingMatchesInString(newHtml, options: NSMatchingOptions.allZeros, range:range, withTemplate: "")
        
        return htmlLessString
    }
    
    // 格式化时间，暂时取前10
    func FormatDate(theDate: String) -> String {
        let DATE_TIME_MINUTEX = 60
        let DATE_TIME_HOURS = 60 * 60
        let DATE_TIME_DAYTIME = 60 * 60 * 24
        let DATE_TIME_WEEK = 60 * 60 * 24 * 7
        let DATE_TIME_MONTH = 60 * 60 * 24 * 30
        let DATE_TIME_YEAR = 60 * 60 * 24 * 365
        let DATE_ONETHOUSAND = 1000
        
        var dataString = ""
        
        let dateFormatter = NSDateFormatter()
        //        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        //        dateFormatter.timeZone = NSTimeZone(name: "GMT")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        
        if dateFormatter.dateFromString(theDate) == nil {
            return ""
        }
        
        let dateValue = dateFormatter.dateFromString(theDate)!.timeIntervalSince1970
        var now = NSDate().dateByAddingTimeInterval(0).timeIntervalSince1970
        
        var cha = Int(now - dateValue)

        if cha / DATE_TIME_HOURS < 1 {
            dataString = "\(cha / DATE_TIME_MINUTEX)分钟前"
        } else if cha / DATE_TIME_DAYTIME < 1 {
            dataString = "\(cha / DATE_TIME_HOURS)小时前"
        } else if cha / DATE_TIME_WEEK < 1 {
            dataString = "\(cha / DATE_TIME_DAYTIME)天前"
        } else if cha / DATE_TIME_MONTH < 1 {
            dataString = "\(cha / DATE_TIME_WEEK)周前"
        } else if cha / DATE_TIME_YEAR < 1 {
            dataString = "\(cha / DATE_TIME_MONTH)月前"
        } else {
            dataString = "\(cha / DATE_TIME_YEAR)年前"
        }
        
        return dataString

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
// HTML字符串过滤
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
