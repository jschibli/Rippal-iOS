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
        
        store.cities.append(City(imageUrl: "123", cityName: "City1"))
        store.cities.append(City(imageUrl: "123", cityName: "City2"))
        store.cities.append(City(imageUrl: "123", cityName: "City3"))
        store.cities.append(City(imageUrl: "123", cityName: "City4"))
        store.cities.append(City(imageUrl: "123", cityName: "City5"))
        store.cities.append(City(imageUrl: "123", cityName: "City6"))
        store.cities.append(City(imageUrl: "123", cityName: "City7"))
        store.cities.append(City(imageUrl: "123", cityName: "City8"))
        
        store.loadCities {
            self.collectionView.reloadSections(IndexSet(integer: 0))
        }
        
        // TODO: remove
        NSLog("ExploreView Loaded")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return store.cities.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "exploreCollectionViewCell", for: indexPath) as! ExploreCollectionViewCell
        
        let city = store.cities[indexPath.row]
        cell.displayContent(cityImage: city.imageUrl, cityName: city.cityName)
        
        return cell;
    }
}

