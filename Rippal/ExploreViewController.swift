//
//  ExploreViewController.swift
//  Rippal
//
//  Created by Tao Wang on 1/23/18.
//  Copyright © 2018 Rippal. All rights reserved.
//

import UIKit

class ExploreViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIGestureRecognizerDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var dateShown: UITextView!
    
    let store = DataStore.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the date to today
        dateShown.text = DateHelper.sharedInstance.constructExploreDateString(date: Date())
        
        store.cities.append(City(image: #imageLiteral(resourceName: "ex_atlanta"), imageUrl: nil, cityName: "Atlanta", lat: 84.3880, lng: 33.7490))
        store.cities.append(City(image: #imageLiteral(resourceName: "ex_boston"), imageUrl: nil, cityName: "Boston", lat: 71.0589, lng: 42.3601))
        store.cities.append(City(image: #imageLiteral(resourceName: "ex_dallas"), imageUrl: nil, cityName: "Dallas", lat: 96.7970, lng: 32.7767))
        store.cities.append(City(image: #imageLiteral(resourceName: "ex_denver"), imageUrl: nil, cityName: "Denver", lat: 104.9903, lng: 39.7392))
        store.cities.append(City(image: #imageLiteral(resourceName: "ex_minneapolis"), imageUrl: nil, cityName: "Minneapolis", lat: 93.2650, lng: 44.9778))
        store.cities.append(City(image: #imageLiteral(resourceName: "ex_philadelphia"), imageUrl: nil, cityName: "Philadelphia", lat: 75.1652, lng: 39.9526))
        store.cities.append(City(image: #imageLiteral(resourceName: "ex_san_francisco"), imageUrl: nil, cityName: "San Francisco", lat: 122.4194, lng: 37.7749))
        store.cities.append(City(image: #imageLiteral(resourceName: "ex_seattle"), imageUrl: nil, cityName: "Seattle", lat: 122.3321, lng: 47.6062))
        store.loadCities {
            self.collectionView.reloadSections(IndexSet(integer: 0))
        }
        
        // TODO: remove
        NSLog("ExploreView Loaded")
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tapGestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGestureRecognizer)
        
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

