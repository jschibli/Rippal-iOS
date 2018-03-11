//
//  ExploreCollectionViewCell.swift
//  Rippal
//
//  Created by Tao Wang on 1/26/18.
//  Copyright © 2018 Rippal. All rights reserved.
//

import UIKit

class ExploreCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cityImageView: UIImageView!
    @IBOutlet weak var cityNameLabel: UILabel!
    
    func displayContent(cityImage: UIImage, cityName: String) {
        // TODO: download image async
        cityImageView.image = cityImage
        cityImageView.layer.cornerRadius = cityImageView.frame.height / 2
        cityImageView.layer.masksToBounds = false
        cityImageView.clipsToBounds = true
        
        cityNameLabel.text = cityName
    }
    
}
