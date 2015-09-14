//
//  BasicFunction.swift
//  Gamers
//  系统自定义的基本方法
//
//  Created by 虚空之翼 on 15/9/11.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

import Foundation


struct BasicFunction {
    
    // 数量格式化
    static func formatViewsTotal(theTotal: Int) -> String {
        var totalString = ""
        
        if theTotal < 1_000 {
            totalString = "\(theTotal)次觀看"
        } else if theTotal < 10_000 {
            totalString = "\(theTotal / 1_000)千次觀看"
        } else {
            totalString = "\(theTotal / 10_000)万次觀看"
        }
        
        return totalString
    }
    
    // 时间格式化
    static func formatDateString(theDate: String) -> String {
        let DATE_TIME_MINUTEX = 60
        let DATE_TIME_HOURS = 60 * 60
        let DATE_TIME_DAYTIME = 60 * 60 * 24
        let DATE_TIME_WEEK = 60 * 60 * 24 * 7
        let DATE_TIME_MONTH = 60 * 60 * 24 * 30
        let DATE_TIME_YEAR = 60 * 60 * 24 * 365
        let DATE_ONETHOUSAND = 1000
        
        var dataString = ""
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        dateFormatter.timeZone = NSTimeZone(name: "GMT")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        
        if dateFormatter.dateFromString(theDate) == nil {
            return ""
        }
        
        let dateValue = dateFormatter.dateFromString(theDate)!.timeIntervalSince1970
        let timeZoneOffset = NSTimeZone.systemTimeZone().secondsFromGMT
        var now = NSDate().dateByAddingTimeInterval(0).timeIntervalSince1970
        
        var cha = Int(now - dateValue)
        
        if cha / DATE_TIME_MINUTEX < 1 {
            dataString = "\(cha / DATE_TIME_MINUTEX)秒前"
        } else if cha / DATE_TIME_HOURS < 1 {
            dataString = "\(cha / DATE_TIME_MINUTEX)分鐘前"
        } else if cha / DATE_TIME_DAYTIME < 1 {
            dataString = "\(cha / DATE_TIME_HOURS)小時前"
        } else if cha / DATE_TIME_WEEK < 1 {
            dataString = "\(cha / DATE_TIME_DAYTIME)天前"
        } else if cha / DATE_TIME_MONTH < 1 {
            dataString = "\(cha / DATE_TIME_WEEK)週前"
        } else if cha / DATE_TIME_YEAR < 1 {
            dataString = "\(cha / DATE_TIME_MONTH)個月前"
        } else {
            dataString = "\(cha / DATE_TIME_YEAR)年前"
        }
        
        return dataString
        
    }
    
    // 过滤HTML标签
    static func filterHTML(html: String) -> String {
        let newHtml = html.stringByDecodingHTMLEntities
        let regex:NSRegularExpression  = NSRegularExpression(pattern: "<.*?>", options: NSRegularExpressionOptions.CaseInsensitive, error: nil)!
        let range = NSMakeRange(0, count(newHtml))
        let htmlLessString :String = regex.stringByReplacingMatchesInString(newHtml, options: NSMatchingOptions.allZeros, range:range, withTemplate: "")
        
        return htmlLessString
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
