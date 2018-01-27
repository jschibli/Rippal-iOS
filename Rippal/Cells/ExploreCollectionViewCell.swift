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
    
    func displayContent(cityImage: String, cityName: String) {
        // TODO: download image async
        cityImageView.image = UIImage(named: "tb_explore")
//        cityImageView.image = cityImage
        cityNameLabel.text = cityName
        // TODO:
    }
    
}
