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
    
    @IBOutlet weak var passwordFieldTopConstraint: NSLayoutConstraint!
    
    var continueSignUp: Bool?
    var email: String?
    var password: String?
    var firstName: String?
    var lastName: String?
    var id: String?
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if continueSignUp! {
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
    
    @IBAction func signUp(_ sender: Any) {
        NSLog("Password %d", txtFld_password.hasText ? 1 : 0)
        NSLog("Confirm %d", txtFld_passwordConfirm.hasText ? 1 : 0)
    }

    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height / 3
            }
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height / 3
            }
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
