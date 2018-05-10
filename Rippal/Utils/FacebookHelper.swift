//
//  FacebookHelper.swift
//  Rippal
//
//  Created by Tao Wang on 4/9/18.
//  Copyright © 2018 Rippal. All rights reserved.
//

import Foundation
import FacebookCore
import FacebookLogin

final class FacebookHelper {
    
    static let sharedInstance = FacebookHelper()
    
    private init() {}
    
    func disconnect() {
        AccessToken.current = nil
    }
    
    func isConnectedWithFacebook() -> Bool {
        return AccessToken.current != nil
    }
    
    func connectWithFacebook(vc: UIViewController) {
        let loginManager = LoginManager()
        loginManager.logIn(readPermissions: [ .email, .userFriends, .userBirthday ], viewController: vc, completion: { loginResult in
            switch loginResult {
            case .failed(let error):
                NSLog("Facebook login failed: \(error)")
            case .cancelled:
                NSLog("Facebook login cancelled")
            case .success(grantedPermissions: _, declinedPermissions: _, token: _):
                NSLog("Facebook logged in")
            }
        })
    }
    
    func retrieveAllFriendsOnRippal(successBlock: @escaping ([String:Any]) -> Void) {
        let params = ["fields": "id, first_name, last_name, middle_name, name, email, picture"]
        let request = GraphRequest(graphPath: "me/friends", parameters: params)
        request.start { (response, result) in
            switch result {
            case .failed(let error):
                NSLog("FB friends result error: \(error)")
            case .success(let graphResponse):
                if let responseDictionary = graphResponse.dictionaryValue {
                    successBlock(responseDictionary)
                }
            }
        }
    }
    
}
