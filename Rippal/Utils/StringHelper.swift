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
    
    func jsonStringToDict(input: String) -> Dictionary<String, Any>? {
        if let data = input.data(using: .utf8) {
            do {
                return (try JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any>)
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
}

