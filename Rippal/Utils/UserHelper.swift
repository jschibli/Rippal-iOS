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
    }
    
    func logout(currentVC: UIViewController, _ sender: Any) {
        setLoggedIn(loggedIn: false)
        UserDefaults.standard.set(nil, forKey: StringHelper.sharedInstance.getKey(key: "userdefaults_user_email")!)
        UserDefaults.standard.set(nil, forKey: StringHelper.sharedInstance.getKey(key: "userdefaults_user_first_name")!)
        UserDefaults.standard.set(nil, forKey: StringHelper.sharedInstance.getKey(key: "userdefaults_user_last_name")!)
        UserDefaults.standard.set(nil, forKey: StringHelper.sharedInstance.getKey(key: "userdefaults_user_id")!)
        UserDefaults.standard.set(nil, forKey: StringHelper.sharedInstance.getKey(key: "userdefaults_cached_avatar")!)  // Clear saved avatar
        
        currentVC.performSegue(withIdentifier: "sw_tab_entry", sender: sender)
    }
    
    func cacheUserInfo(email: String, firstName: String, lastName: String, id: String, location: String?, position: String?) {
        // Local
        UserDefaults.standard.set(email, forKey: StringHelper.sharedInstance.getKey(key: "userdefaults_user_email")!)
        UserDefaults.standard.set(firstName, forKey: StringHelper.sharedInstance.getKey(key: "userdefaults_user_first_name")!)
        UserDefaults.standard.set(lastName, forKey: StringHelper.sharedInstance.getKey(key: "userdefaults_user_last_name")!)
        UserDefaults.standard.set(id, forKey: StringHelper.sharedInstance.getKey(key: "userdefaults_user_id")!)
        UserDefaults.standard.set(location, forKey: StringHelper.sharedInstance.getKey(key: "userdefaults_user_location")!)
        UserDefaults.standard.set(position, forKey: StringHelper.sharedInstance.getKey(key: "userdefaults_user_position")!)
        
        // Linkedin
        LinkedInHelper.sharedInstance.clearSession()
        
        // Facebook
        FacebookHelper.sharedInstance.disconnect()
    }
    
    func loadUserInfo() -> [String] {
        // TODO: use localised strings instead
        var retArr: [String] = []
        retArr.append(UserDefaults.standard.string(forKey: StringHelper.sharedInstance.getKey(key: "userdefaults_user_email")!)!)
        retArr.append(UserDefaults.standard.string(forKey: StringHelper.sharedInstance.getKey(key: "userdefaults_user_first_name")!)!)
        retArr.append(UserDefaults.standard.string(forKey: StringHelper.sharedInstance.getKey(key: "userdefaults_user_last_name")!)!)
        retArr.append(UserDefaults.standard.string(forKey: StringHelper.sharedInstance.getKey(key: "userdefaults_user_id")!)!)
        retArr.append(UserDefaults.standard.string(forKey: StringHelper.sharedInstance.getKey(key: "userdefaults_user_location")!) ?? "Unknown Location")
        retArr.append(UserDefaults.standard.string(forKey: StringHelper.sharedInstance.getKey(key: "userdefaults_user_position")!) ?? "Unknown Position")
        return retArr
    }
    
    func hasCachedAvatar() -> Bool {
        return UserDefaults.standard.data(forKey: StringHelper.sharedInstance.getKey(key: "userdefaults_cached_avatar")!) != nil
    }
    
    func loadCachedAvatar() -> UIImage {
        NSLog("Loading avatar from cache...")
        let data: Data = UserDefaults.standard.data(forKey: StringHelper.sharedInstance.getKey(key: "userdefaults_cached_avatar")!)!
        return UIImage(data: data)!
    }
    
    func saveAvatarCache(_ image: UIImage) {
        let data: Data = UIImageJPEGRepresentation(image, 1.0)!
        UserDefaults.standard.set(data, forKey: StringHelper.sharedInstance.getKey(key: "userdefaults_cached_avatar")!)
    }
    
    /* Async */
    func fetchAvatar(callback: @escaping (UIImage) -> Void) {
        if hasCachedAvatar() {
            callback(loadCachedAvatar())
        } else {
            LinkedInHelper.sharedInstance.getProfilePictureUrl(successBlock: { response in
                if response?.statusCode == 200 {
                    if response!.data! == "null" {
                        NSLog("Did not return data")
                        return      // No url available
                    }
                    let url = StringHelper.sharedInstance.jsonStringToDict(input: response!.data)!["pictureUrl"] as! String
                    
                    Alamofire.request(url).responseImage { response in
                        if let image = response.result.value {
                            callback(image)
                            self.saveAvatarCache(image)
                        }
                    }
                }
            }) { error in
                // Do nothing
                NSLog("\(String(describing: error))")
            }
        }
    }
}
