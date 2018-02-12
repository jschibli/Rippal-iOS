//
//  LoginViewController.swift
//  Rippal
//
//  Created by Tao Wang on 1/25/18.
//  Copyright © 2018 Rippal. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet var btnSignInLinkedIn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        performSegue(withIdentifier: "sw_login_tab", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnSignInLinkedInPressed(_ sender: Any) {
        LinkedInHelper.sharedInstance.newSession(successBlock: { returnState in
            let session = LISDKSessionManager.sharedInstance().session!
            UserHelper.sharedInstance.setLoggedIn(loggedIn: true)
            LinkedInHelper.sharedInstance.setSessionAccessToken(accessToken: session.accessToken)
            
            // TODO: communicate with server whether to create a new user or update existing one
            
            // Segue into the tabs
            self.performSegue(withIdentifier: "sw_login_tab", sender: sender)
        }, errorBlock: { error in
            var actions: [UIAlertAction] = [];
            actions.append(UIAlertAction(title: "OK", style: .`default`, handler: nil))
            guard let err = error else {
                // TODO: use localized strings
                NotificationHelper.sharedInstance.showAlert(title: "Error Signing In", message: "Encountered an unknown error", actions: actions, context: self)
                return
            }
            
            let error = err as NSError
            NSLog("Sign in error: %@", error)
            switch error.code {
            case LISDKErrorCode.NETWORK_UNAVAILABLE.hashValue:
                NotificationHelper.sharedInstance.showAlert(title: "Network Unavailable", message: "Encountered error with Internet connection", actions: actions, context: self)
                break
            case LISDKErrorCode.USER_CANCELLED.hashValue, LISDKErrorCode.LINKEDIN_APP_NOT_FOUND.hashValue:
                // Do nothing
                break
            default:
                break
            }
        })
    }
}


