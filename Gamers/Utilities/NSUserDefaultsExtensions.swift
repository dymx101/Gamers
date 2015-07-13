//
//  NSUserDefaultsExtensions.swift
//  Gamers
//
//  Created by 虚空之翼 on 15/7/13.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

import Foundation


extension NSUserDefaults {
    
    func searchHistories() -> [String] {
        if let histories = arrayForKey("searchHistories") as? [String] {
            return histories
        }
        
        return [String]()
    }
    
    func addSearchHistory(query: String?) {
        if let query = query {
            var histories = searchHistories()
            
            if !contains(histories, query) {
                histories.append(query)
            } else {
                // TODO: Re-sorting
            }
            
            setObject(histories, forKey: "searchHistories")
            synchronize()
        }
    }
    
    func clearSearchHistories() {
        removeObjectForKey("searchHistories")
        synchronize()
    }
}
