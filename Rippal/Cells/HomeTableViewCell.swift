//
//  HomeTableViewCell.swift
//  Rippal
//
//  Created by Tao Wang on 3/18/18.
//  Copyright © 2018 Rippal. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userPhoto: UIImageView!
    @IBOutlet weak var sendEmail: UIImageView!
    @IBOutlet weak var openLinkedIn: UIImageView!
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userCompany: UILabel!
    @IBOutlet weak var userLocation: UILabel!
    
    var email: String = ""
    
    func displayContent(profilePhoto: UIImage, name: String, location: String, company: String, email: String) {
        // Profile image
        userPhoto.image = profilePhoto
        userPhoto.layer.cornerRadius = userPhoto.frame.height / 2
        userPhoto.layer.masksToBounds = false
        userPhoto.clipsToBounds = true
        
        // Professional Information
        userName.text = name
        userCompany.text = company
        userLocation.text = location
        
        // Email and LinkedIn buttons
        let sendEmailTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(HomeTableViewCell.sendEmailTapped))
        let openLinkedInTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(HomeTableViewCell.openLinkedInTapped))
        sendEmail.isUserInteractionEnabled = true
        openLinkedIn.isUserInteractionEnabled = true
        sendEmail.addGestureRecognizer(sendEmailTapGestureRecognizer)
        openLinkedIn.addGestureRecognizer(openLinkedInTapGestureRecognizer)
        
        self.email = email
    }
    
    @objc func sendEmailTapped() {
        if let url = URL(string: "mailto:\(self.email)") {
            UIApplication.shared.open(url)
        }
    }
    
    @objc func openLinkedInTapped() {
        // TODO:
        NSLog("Open linkedin")
    }
}
