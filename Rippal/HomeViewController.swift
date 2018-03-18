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
    @IBOutlet weak var stackViewContainer: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCityName()
        
        setupFilterStackView()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tapGestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGestureRecognizer)
        
        // TODO: remove
        NSLog("HomeView Loaded")
    }
    
    func setupFilterStackView() {
        let width = CGFloat(0.5)
        
        // Add a bottom border
        let bottomBorder = CALayer()
        bottomBorder.borderColor = UIColor.black.cgColor
        bottomBorder.frame = CGRect(x: 0, y: stackViewContainer.frame.size.height - width, width: stackViewContainer.frame.size.width, height: stackViewContainer.frame.size.height)
        bottomBorder.borderWidth = width
        stackViewContainer.layer.addSublayer(bottomBorder)
        
        let topBorder = CALayer()
        topBorder.borderColor = UIColor.black.cgColor
        topBorder.frame = CGRect(x: 0, y: 0, width: stackViewContainer.frame.width, height: width)
        topBorder.borderWidth = width
        stackViewContainer.layer.addSublayer(topBorder)
        
        cityName.layer.masksToBounds = true
    }

    func setupCityName() {
        let parentViewController: TabBarController = parent as! TabBarController
        cityName.text = parentViewController.location!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

