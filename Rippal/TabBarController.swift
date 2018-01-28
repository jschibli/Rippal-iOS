//
//  TabBarController.swift
//  Rippal
//
//  Created by Tao Wang on 1/27/18.
//  Copyright © 2018 Rippal. All rights reserved.
//

import CoreLocation
import UIKit

class TabBarController: UITabBarController, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            NSLog("Not determined")
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted, .denied:
            NSLog("Restricted")
            locationManager.requestWhenInUseAuthorization()
            // TODO: disable other operations until user allows location permission
            break
        case .authorizedWhenInUse:
            NSLog("When in use")
            determineToEscalatePermission()
            break
        default:    // .authorizedAlways
            NSLog("Always")
            break
        }
        
        
//        locationManager.requestAlwaysAuthorization()
        
        NSLog("Tab bar controller loaded")
    }
    
    func determineToEscalatePermission() {
        // TODO: check if asked already
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            if UserDefaults.standard.bool(forKey: StringHelper.sharedInstance.getKey(key: "userdefaults_asked_always")!) {
                // TODO: pop up a window to remind user to go to settings to turn on locations permission
            } else {
                locationManager.requestAlwaysAuthorization()
                UserDefaults.standard.set(true, forKey: "userdefaults_asked_always")        // Already asked
            }
        }
    }
    
}
