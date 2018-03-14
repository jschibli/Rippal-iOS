//
//  LoginViewController.swift
//  Rippal
//
//  Created by Tao Wang on 3/14/18.
//  Copyright © 2018 Rippal. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var txtFld_email: UITextField!
    @IBOutlet weak var txtFld_password: UITextField!
    @IBOutlet weak var btn_login: UIButton!
    @IBOutlet weak var btn_back: UIButton!
    
    @IBAction func btnLogInPressed(_ sender: Any) {
        // TODO: use localised strings
        var actions: [UIAlertAction] = [];
        actions.append(UIAlertAction(title: "OK", style: .`default`, handler: nil))
        
        if !txtFld_email.hasText || !StringHelper.sharedInstance.isValidEmail(testStr: txtFld_email.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)) {
            // TODO: use localised strings
            NotificationHelper.sharedInstance.showAlert(title: "Incorrect email format", message: "Please fix email field before logging in", actions: actions, context: self)
            return
        }
        let email = txtFld_email.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let password = PasswordHelper.sharedInstance.md5(raw: txtFld_password.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))
        
        NetworkHelper.sharedInstance.logIn(email: email, password: password!) { response in
            if response.response?.statusCode == 200 {
                let json = String(data: response.data!, encoding: .utf8)
                NSLog("Data: \(json!)")
//                self.performSegue(withIdentifier: "sw_login_tab", sender: sender)
            } else {
                let json = String(data: response.data!, encoding: .utf8)
                NotificationHelper.sharedInstance.showAlert(title: "Encountered error", message: StringHelper.sharedInstance.jsonStringToDict(input: json!)!["error"] as! String, actions: actions, context: self)
            }
        }
    }
    
    @IBAction func btnBackPressed(_ sender: Any) {
        performSegue(withIdentifier: "sw_login_entry", sender: sender)
    }
}
