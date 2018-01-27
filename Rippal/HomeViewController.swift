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
        
        // TODO: remove
        NSLog("HomeView Loaded")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

