//
//  LinkedInHelper.swift
//  Rippal
//
//  Created by Tao Wang on 2/12/18.
//  Copyright © 2018 Rippal. All rights reserved.
//

import Foundation

final class LinkedInHelper {
    
    static let sharedInstance = LinkedInHelper()
    
    private init() {}
    
    func setSessionAccessToken(accessToken: LISDKAccessToken) {
        UserDefaults.standard.set(accessToken.accessTokenValue, forKey: StringHelper.sharedInstance.getKey(key: "userdefaults_session_access_token_value")!)
        UserDefaults.standard.set(accessToken.expiration, forKey: StringHelper.sharedInstance.getKey(key: "userdefaults_session_access_token_expiration")!)
    }
    
    func hasSession() -> Bool {
        return UserDefaults.standard.string(forKey: StringHelper.sharedInstance.getKey(key: "userdefaults_session_access_token_value")!) != nil
    }
    
    func sessionExpired() -> Bool {
        let expiration = UserDefaults.standard.object(forKey: StringHelper.sharedInstance.getKey(key: "userdefaults_session_access_token_expiration")!) as! Date
        return expiration < Date()
    }
    
    func getAccessToken() -> LISDKAccessToken? {
        guard let tokenValue = UserDefaults.standard.string(forKey: StringHelper.sharedInstance.getKey(key: "userdefaults_session_access_token_value")!) else {
            return nil
        }
        guard let expiration = UserDefaults.standard.object(forKey: StringHelper.sharedInstance.getKey(key: "userdefaults_session_access_token_expiration")!) else {
            return nil
        }
        let expirationDate = expiration as! Date
        return LISDKAccessToken(value: tokenValue, expiresOnMillis: Int64(expirationDate.timeIntervalSince1970) * 1000)
    }
    
    func newSession(successBlock: @escaping AuthSuccessBlock, errorBlock: @escaping AuthErrorBlock) {
        LISDKSessionManager.createSession(withAuth: [LISDK_BASIC_PROFILE_PERMISSION, LISDK_EMAILADDRESS_PERMISSION], state: nil, showGoToAppStoreDialog: true, successBlock: successBlock, errorBlock: errorBlock)
    }
    
    func resumeSession(_ accessToken: LISDKAccessToken) {
        return LISDKSessionManager.createSession(with: accessToken)
    }
    
    func getUserInfo(successBlock: @escaping (LISDKAPIResponse?) -> Void, errorBlock: @escaping (LISDKAPIError?) -> Void) {
        LISDKAPIHelper.sharedInstance().getRequest("https://api.linkedin.com/v1/people/~:(id,first-name,last-name,email-address)?format=json", success: successBlock, error: errorBlock)
    }
    
    func getProfilePictureUrl(successBlock: @escaping (LISDKAPIResponse?) -> Void, errorBlock: @escaping (LISDKAPIError?) -> Void) {
        LISDKAPIHelper.sharedInstance().getRequest("https://api.linkedin.com/v1/people/~/picture-urls::(original)", success: successBlock, error: errorBlock)
    }
}
