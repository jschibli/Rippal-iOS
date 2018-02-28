//
//  ProfileViewController.swift
//  Rippal
//
//  Created by Tao Wang on 1/24/18.
//  Copyright © 2018 Rippal. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var img_city: UIImageView!
    @IBOutlet weak var img_user_avatar: UIImageView!
    @IBOutlet weak var txt_fld_name: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        img_user_avatar.layer.cornerRadius = img_user_avatar.frame.height / 2
        img_user_avatar.layer.masksToBounds = false
        img_user_avatar.clipsToBounds = true
        loadProfilePicture()
        
        let parentViewController: TabBarController = parent as! TabBarController
        txt_fld_name.text = parentViewController.firstName! + " " + parentViewController.lastName!
        
        // TODO: remove
        NSLog("ProfileView Loaded")
    }
    
    /* Async */
    func loadProfilePicture() {
        if !UserHelper.sharedInstance.isLoggedIn() {
            return
        }
        
        UserHelper.sharedInstance.fetchAvatar { image in
            self.img_user_avatar.image = image
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


