//
//  PasswordHelper.swift
//  Rippal
//
//  Created by Tao Wang on 2/20/18.
//  Copyright © 2018 Rippal. All rights reserved.
//

import Foundation

final class PasswordHelper {
    
    static let sharedInstance = PasswordHelper()
    
    func md5(raw: String) -> String! {
        let passwdData = raw.data(using: .utf8)!
        var digestData = Data(count: Int(CC_MD5_DIGEST_LENGTH))
        
        _ = digestData.withUnsafeMutableBytes({ digestBytes in
            passwdData.withUnsafeBytes({ passwdBytes in
                CC_MD5(passwdBytes, CC_LONG(passwdData.count), digestBytes)
            })
        })
        
        return digestData.map { String(format: "%02hhx", $0) }.joined()
    }
}
