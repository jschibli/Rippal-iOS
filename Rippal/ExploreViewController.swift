//
//  ExploreViewController.swift
//  Rippal
//
//  Created by Tao Wang on 1/23/18.
//  Copyright © 2018 Rippal. All rights reserved.
//

import UIKit

class ExploreViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var dateShown: UITextView!
    
    let store = DataStore.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the date to today
        dateShown.text = DateHelper.sharedInstance.constructExploreDateString(date: Date())
        
        store.cities.append(City(image: #imageLiteral(resourceName: "ex_atlanta"), imageUrl: nil, cityName: "Atlanta"))
        store.cities.append(City(image: #imageLiteral(resourceName: "ex_boston"), imageUrl: nil, cityName: "Boston"))
        store.cities.append(City(image: #imageLiteral(resourceName: "ex_dallas"), imageUrl: nil, cityName: "Dallas"))
        store.cities.append(City(image: #imageLiteral(resourceName: "ex_denver"), imageUrl: nil, cityName: "Denver"))
        store.cities.append(City(image: #imageLiteral(resourceName: "ex_minneapolis"), imageUrl: nil, cityName: "Minneapolis"))
        store.cities.append(City(image: #imageLiteral(resourceName: "ex_philadelphia"), imageUrl: nil, cityName: "Philadelphia"))
        store.cities.append(City(image: #imageLiteral(resourceName: "ex_san_francisco"), imageUrl: nil, cityName: "San Francisco"))
        store.cities.append(City(image: #imageLiteral(resourceName: "ex_seattle"), imageUrl: nil, cityName: "Seattle"))
        
        store.loadCities {
            self.collectionView.reloadSections(IndexSet(integer: 0))
        }
        
        // TODO: remove
        NSLog("ExploreView Loaded")
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard)))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // TODO:
        NSLog("Selected: \(indexPath.row)")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return store.cities.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "exploreCollectionViewCell", for: indexPath) as! ExploreCollectionViewCell
        
        let city = store.cities[indexPath.row]
        cell.displayContent(cityImage: city.image, cityName: city.cityName)
        
        return cell;
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

