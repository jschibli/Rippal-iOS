//
//  LoginViewController.swift
//  Rippal
//
//  Created by Tao Wang on 1/25/18.
//  Copyright © 2018 Rippal. All rights reserved.
//

import UIKit
import Alamofire

class LoginViewController: UIViewController {
    
    @IBOutlet var btnSignInLinkedIn: UIButton!
    
    var email: String?
    var password: String?
    var firstName: String?
    var lastName: String?
    var id: String?
    
    var throughLinkedIn: Bool?           // Whether user signs up/logs in with LinkedIn or signs up from scratch
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnSignInLinkedInPressed(_ sender: Any) {
        throughLinkedIn = true
        LinkedInHelper.sharedInstance.newSession(successBlock: { returnState in
            let session = LISDKSessionManager.sharedInstance().session!
            UserHelper.sharedInstance.setLoggedIn(loggedIn: true)
            LinkedInHelper.sharedInstance.setSessionAccessToken(accessToken: session.accessToken)
            
            LinkedInHelper.sharedInstance.getUserInfo(successBlock: { response in
                let userInfo = StringHelper.sharedInstance.jsonStringToDict(input: (response?.data)!) as Dictionary!
                let email = userInfo!["emailAddress"] as! String
                let firstName = userInfo!["firstName"] as! String
                let lastName = userInfo!["lastName"] as! String
                let id = userInfo!["id"] as! String
                NetworkHelper.sharedInstance.checkUserExists(email: email, completionHandler: { response in
                    if response.response?.statusCode != 200 {       // User not found
                        NSLog("User not found")
                        self.performSegue(withIdentifier: "sw_login_signup", sender: sender)
//                        NetworkHelper.sharedInstance.signUp(email: email, password: "TODO:", firstName: firstName, lastName: lastName, id: id, completionHandler: { response in
//                            if response.response?.statusCode != 200 {
//                                // TODO: prompt to say something was wrong
//                            }
//                            // TODO:
//                        })
                    } else {        // Found user
                        NSLog("Found user")
                        NetworkHelper.sharedInstance.updateUserInfo(email: email, firstName: firstName, lastName: lastName, id: id, completionHandler: { response in
                            if response.response?.statusCode != 200 {
                                NSLog("Failed to update user info")
                            }
                        })
                        // Segue into the tabs
                        self.performSegue(withIdentifier: "sw_login_tab", sender: sender)
                    }
                })
            }, errorBlock: { error in
                
            })
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
    
    @IBAction func btnSignUpPressed(_ sender: Any) {
        throughLinkedIn = false
        performSegue(withIdentifier: "sw_login_signup", sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case "sw_login_signup":
            let destinationVC = segue.destination as! SignupViewController
            destinationVC.continueSignUp = throughLinkedIn              // Have LinkedIn data already
            NSLog("Preparing segue")
            break
        default:
            break
        }
    }
}



