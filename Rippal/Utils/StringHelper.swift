//
//  StringHelper.swift
//  Rippal
//
//  Created by Tao Wang on 1/27/18.
//  Copyright © 2018 Rippal. All rights reserved.
//

import Foundation

final class StringHelper {
    
    static let sharedInstance = StringHelper()
    let keys: Dictionary<String, String>
    
    private init() {
        var dict:NSDictionary?
        if let path = Bundle.main.path(forResource: "keys", ofType: "plist") {
            dict = NSDictionary(contentsOfFile: path)
        }
        keys = dict as! Dictionary<String, String>
    }
    
    func getKey(key: String) -> String? {
        return keys[key]
    }
}

