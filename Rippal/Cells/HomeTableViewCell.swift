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
    
    func displayContent(profilePhoto: UIImage) {
        userPhoto.image = profilePhoto
        userPhoto.layer.cornerRadius = userPhoto.frame.height / 2
        userPhoto.layer.masksToBounds = false
        userPhoto.clipsToBounds = true
        
        
    }
    
}
