//
//  LinkedInHelper.swift
//  Rippal
//
//  Created by Tao Wang on 2/12/18.
//  Copyright © 2018 Rippal. All rights reserved.
//

import Foundation

import Alamofire
import AlamofireImage

final class UserHelper {
    
    static let sharedInstance = UserHelper()
    
    private init() {}
    
    func isLoggedIn() -> Bool {
        return UserDefaults.standard.bool(forKey: StringHelper.sharedInstance.getKey(key: "userdefaults_logged_in")!)
    }
    
    func setLoggedIn(loggedIn: Bool) {
        UserDefaults.standard.set(loggedIn, forKey: StringHelper.sharedInstance.getKey(key: "userdefaults_logged_in")!)
        if !loggedIn {
            UserDefaults.standard.bool(forKey: StringHelper.sharedInstance.getKey(key: "userdefaults_has_cached_avatar")!)
        }
    }
    
    func hasCachedAvatar() -> Bool {
        return UserDefaults.standard.bool(forKey: StringHelper.sharedInstance.getKey(key: "userdefaults_has_cached_avatar")!)
    }
    
    func loadCachedAvatar() -> UIImage {
        NSLog("Loading avatar from cache...")
        let data: Data = UserDefaults.standard.data(forKey: StringHelper.sharedInstance.getKey(key: "userdefaults_cached_avatar")!)!
        return UIImage(data: data)!
    }
    
    func saveAvatarCache(_ image: UIImage) {
        let data: Data = UIImageJPEGRepresentation(image, 1.0)!
        UserDefaults.standard.set(data, forKey: StringHelper.sharedInstance.getKey(key: "userdefaults_cached_avatar")!)
        UserDefaults.standard.set(true, forKey: StringHelper.sharedInstance.getKey(key: "userdefaults_has_cached_avatar")!)
    }
    
    /* Async */
    func fetchAvatar(callback: @escaping (UIImage) -> Void) {
        if hasCachedAvatar() {
            callback(loadCachedAvatar())
        } else {
            LinkedInHelper.sharedInstance.getProfilePictureUrl(successBlock: { response in
                if response?.statusCode == 200 {
                    
                    let rawArray = StringHelper.sharedInstance.jsonStringToDict(input: response!.data)!["values"]
                    var url = rawArray.map({ item -> String in
                        return String(describing: item)
                    })
                    url = url!.replacingOccurrences(of: "\"", with: "")
                    url = url!.replacingOccurrences(of: "(", with: "")
                    url = url!.replacingOccurrences(of: ")", with: "")
                    url = url!.replacingOccurrences(of: "\n", with: "")
                    url = url!.trimmingCharacters(in: .whitespaces)
                    
                    Alamofire.request(url!).responseImage { response in
                        if let image = response.result.value {
                            callback(image)
                            self.saveAvatarCache(image)
                        }
                    }
                }
            }) { error in
                // Do nothing
            }
        }
    }
}
