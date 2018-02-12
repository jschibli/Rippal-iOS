//
//  LinkedInHelper.swift
//  Rippal
//
//  Created by Tao Wang on 2/12/18.
//  Copyright © 2018 Rippal. All rights reserved.
//

import Foundation

final class UserHelper {
    
    static let sharedInstance = UserHelper()
    
    private init() {}
    
    func isLoggedIn() -> Bool {
        return UserDefaults.standard.bool(forKey: StringHelper.sharedInstance.getKey(key: "userdefaults_logged_in")!)
    }
    
    func setLoggedIn(loggedIn: Bool) {
        UserDefaults.standard.set(loggedIn, forKey: StringHelper.sharedInstance.getKey(key: "userdefaults_logged_in")!)
    }
}
