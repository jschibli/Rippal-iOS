//
//  SignupViewController.swift
//  Rippal
//
//  Created by Tao Wang on 2/14/18.
//  Copyright © 2018 Rippal. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController {
    
    @IBOutlet weak var txtFld_email: UITextField!
    @IBOutlet weak var txtFld_firstName: UITextField!
    @IBOutlet weak var txtFld_lastName: UITextField!
    @IBOutlet weak var txtFld_password: UITextField!
    @IBOutlet weak var txtFld_passwordConfirm: UITextField!
    @IBOutlet weak var btn_signup: UIButton!
    @IBOutlet weak var btn_back: UIButton!
    
    @IBOutlet weak var passwordFieldTopConstraint: NSLayoutConstraint!
    
    var continueSignUp: Bool = false;
    var email: String?
    var password: String?
    var firstName: String?
    var lastName: String?
    var id: String?
    var location: String?
    var position: String?
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if continueSignUp {
            txtFld_email.isHidden = true
            txtFld_firstName.isHidden = true
            txtFld_lastName.isHidden = true
            
            btn_signup.setTitle("Finish Sign Up", for: .normal)
            
            passwordFieldTopConstraint.constant = -80           // TODO: Localise for different screens?
            view.layoutIfNeeded()
        }
        
        // Keyboard show or hide notification
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard)))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func btnSignUpPressed(_ sender: Any) {
        // TODO: use localised strings
        var actions: [UIAlertAction] = [];
        actions.append(UIAlertAction(title: "OK", style: .`default`, handler: nil))
        
        if !continueSignUp {
            if !txtFld_email.hasText || !StringHelper.sharedInstance.isValidEmail(testStr: txtFld_email.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)) {
                // TODO: use localised strings
                NotificationHelper.sharedInstance.showAlert(title: "Incorrect email format", message: "Please fix email field before signing up", actions: actions, context: self)
                return
            }
            email = txtFld_email.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            
            if !txtFld_lastName.hasText {
                // TODO: use localised strings
                NotificationHelper.sharedInstance.showAlert(title: "Missing last name", message: "Please put in last name before signing up", actions: actions, context: self)
                return
            }
            lastName = txtFld_lastName.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            lastName?.capitalizeFirstLetter()
            
            if !txtFld_firstName.hasText {
                // TODO: use localised strings
                NotificationHelper.sharedInstance.showAlert(title: "Missing first name", message: "Please put in first name before signing up", actions: actions, context: self)
                return
            }
            firstName = txtFld_firstName.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            firstName?.capitalizeFirstLetter()
        }
        // Check if passwords match
        if !txtFld_password.hasText || !txtFld_passwordConfirm.hasText {
            NotificationHelper.sharedInstance.showAlert(title: "No password", message: "Please set password", actions: actions, context: self)
            return
        }
        if txtFld_password.text!.count < 6 {
            NotificationHelper.sharedInstance.showAlert(title: "Password too short", message: "Password should be at least 6 characters long", actions: actions, context: self)
            return
        }
        if txtFld_password.text! != txtFld_passwordConfirm.text! {
            NotificationHelper.sharedInstance.showAlert(title: "Passwords do not match", message: "Please check again", actions: actions, context: self)
            return
        }
        
        // Hash password
        password = PasswordHelper.sharedInstance.md5(raw: txtFld_password.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))
        
        // If id is empty
        if (id ?? "").isEmpty {
            id = "null"
        }
        
        NetworkHelper.sharedInstance.signUp(email: email!, password: password!, firstName: firstName!, lastName: lastName!, id: id!) { response in
            if response.response?.statusCode == 200 {
                self.performSegue(withIdentifier: "sw_signup_tab", sender: sender)
            } else {
                let json = String(data: response.data!, encoding: .utf8)
                NotificationHelper.sharedInstance.showAlert(title: "Encountered error", message: StringHelper.sharedInstance.jsonStringToDict(input: json!)!["error"] as! String, actions: actions, context: self)
            }
        }
    }
    
    @IBAction func btnBackPressed(_ sender: Any) {
        performSegue(withIdentifier: "sw_signup_entry", sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        NSLog("Preparing segue...")
        switch segue.identifier! {
        case "sw_signup_tab":
            let destinationVC = segue.destination as! TabBarController
            destinationVC.email = email
            destinationVC.lastName = lastName
            destinationVC.firstName = firstName
            destinationVC.id = id
            destinationVC.location = location
            destinationVC.position = position
            break
        default:
            break
        }
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if view.frame.origin.y == 0 {
                view.frame.origin.y -= (keyboardSize.height + 42) / 3           // No idea why
            }
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        view.frame.origin.y = 0
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
