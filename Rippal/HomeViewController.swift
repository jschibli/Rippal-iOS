//
//  HomeViewController.swift
//  Rippal
//
//  Created by Tao Wang on 1/23/18.
//  Copyright © 2018 Rippal. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {

    // Mark: Controls
    @IBOutlet weak var cityImage: UIImageView!
    @IBOutlet weak var cityName: UITextView!
    @IBOutlet weak var stackViewContainer: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    let store = DataStore.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCityName()
        
        setupFilterStackView()
        
        tableView.dataSource = self
        tableView.delegate = self
        store.connections.append(Connection(profilePhoto: #imageLiteral(resourceName: "pf_generic_avatar"), linkedInId: "XPDyOJeDY2", email: "peterwangtao0@hotmail.com", lat: 122.4194, lng: 37.7749, company: "Rippal LLC", location: "Glens Falls, New York", name: "Tao Peter Wang"))
        store.loadConnections {
            self.tableView.reloadData()
        }
                
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tapGestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGestureRecognizer)
        
        // TODO: remove
        NSLog("HomeView Loaded")
    }

    func setupCityName() {
        let parentViewController: TabBarController = parent as! TabBarController
        cityName.text = parentViewController.location!
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO:
        NSLog("Selected: \(indexPath.row)")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return store.connections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "connectionCell", for: indexPath) as! HomeTableViewCell
        
        let connection = store.connections[indexPath.row]
        cell.displayContent(profilePhoto: connection.profilePhoto, name: connection.name, location: connection.location, company: connection.company, email: connection.email, id: connection.linkedInId)
        
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

