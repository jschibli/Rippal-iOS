//
//  HomeViewController.swift
//  Rippal
//
//  Created by Tao Wang on 1/23/18.
//  Copyright © 2018 Rippal. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    // Mark: Controls
    @IBOutlet weak var cityImage: UIImageView!
    @IBOutlet weak var cityName: UITextView!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCityName()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tapGestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGestureRecognizer)
        
        // TODO: remove
        NSLog("HomeView Loaded")
    }

    func setupCityName() {
        let parentViewController: TabBarController = parent as! TabBarController
        cityName.text = parentViewController.location!
        
        // Add a bottom border
        let border = CALayer()
        let width = CGFloat(0.5)
        border.borderColor = UIColor.black.cgColor
        border.frame = CGRect(x: 0, y: cityName.frame.size.height - width, width: cityName.frame.size.width, height: cityName.frame.size.height)
        border.borderWidth = width
        cityName.layer.addSublayer(border)
        cityName.layer.masksToBounds = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

