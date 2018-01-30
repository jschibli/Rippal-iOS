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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            // Not determined
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted, .denied:
            // Restricted
            locationManager.requestWhenInUseAuthorization()
            // TODO: disable other operations until user allows location permission
            break
        case .authorizedWhenInUse:
            // When in use
            determineToEscalatePermission()
            break
        default:    // .authorizedAlways
            // Always
            break
        }
    }
    
    func determineToEscalatePermission() {
        // TODO: check if asked already
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            NSLog("Authorized when in use")
            NSLog(UserDefaults.standard.bool(forKey: "userdefaults_asked_always").description)
            if UserDefaults.standard.bool(forKey: StringHelper.sharedInstance.getKey(key: "userdefaults_asked_always")!) {
                var actions: [UIAlertAction] = [];
                // TODO: localization for the notification
                actions.append(UIAlertAction(title: "Got it", style: .`default`, handler: nil))
                actions.append(UIAlertAction(title: "Settings", style: .`default`) { (_) -> Void in
                    guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                        return
                    }
                    
                    if UIApplication.shared.canOpenURL(settingsUrl) {
                        UIApplication.shared.open(settingsUrl, options: [:], completionHandler: nil)
                    }
                })
                NotificationHelper.sharedInstance.showAlert(title: "Need location permission", message: "Please enable location permission in 'Settings', or Rippal cannot function properly", actions: actions, context: self.selectedViewController!)
            } else {
                locationManager.requestAlwaysAuthorization()
                UserDefaults.standard.set(true, forKey: StringHelper.sharedInstance.getKey(key: 
                    "userdefaults_asked_always")!)        // Already asked
            }
        }
    }
    
}
