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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        guard let accessToken = LinkedInHelper.sharedInstance.getAccessToken() else {
            // TODO: prompt to refresh token
            return
        }
        LinkedInHelper.sharedInstance.resumeSession(accessToken)
        NSLog("Access token: %@", accessToken)
        
        NetworkHelper.sharedInstance.checkServerRunning { response in
            if response.response?.statusCode == 200 {
                serverRunning = true
                NSLog("Server is running")
            } else {
                serverRunning = false
                NSLog("Server is NOT running")
                // TODO: use localised strings instead
                var actions: [UIAlertAction] = [];
                actions.append(UIAlertAction(title: "OK", style: .`default`, handler: nil))
                NotificationHelper.sharedInstance.showAlert(title: "Server Is Down", message: "Cannot connect to Rippal server, some functionalities might be limited", actions: actions, context: self)
            }
        }
    }
    
    func checkLocationPermission() {
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            // Not determined
            locationManager.requestWhenInUseAuthorization()     // when I know enough about iOS, I'll be able to remove this branch
            break
        case .restricted, .denied:
            // Restricted
            locationManager.requestWhenInUseAuthorization()
            determineToEscalateLocationPermission()
            // TODO: disable other operations until user allows location permission
            break
        case .authorizedWhenInUse:
            // When in use
            determineToEscalateLocationPermission()
            break
        default:    // .authorizedAlways
            // Always
            break
        }
    }
    
    func determineToEscalateLocationPermission() {
        // No location permission given
        if CLLocationManager.authorizationStatus() == .restricted || CLLocationManager.authorizationStatus() == .denied {
            var actions: [UIAlertAction] = [];
            // TODO: localization for the notification
            actions.append(UIAlertAction(title: "Go to Settings", style: .`default`) { (_) -> Void in
                guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                    return
                }
                
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, options: [:], completionHandler: { (_) in
                        // Exit application
                        NotificationHelper.sharedInstance.showAlert(title: "Need location permission", message: "Please enable location permission for basic Rippal functionalities", actions: actions, context: self.selectedViewController!)
                        // Stop all functionalities
                        UIApplication.shared.beginIgnoringInteractionEvents()
                    })
                }
            })
            NotificationHelper.sharedInstance.showAlert(title: "Need location permission", message: "Please enable location permission for basic Rippal functionalities", actions: actions, context: self.selectedViewController!)
        }
        
        // Already granted "When In Use" permission
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            if UserDefaults.standard.bool(forKey: StringHelper.sharedInstance.getKey(key: "userdefaults_asked_always")!) &&
                !UserDefaults.standard.bool(forKey: StringHelper.sharedInstance.getKey(key: "userdefaults_notified_always")!) {
                // Have asked but have not notified
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
                UserDefaults.standard.set(true, forKey: StringHelper.sharedInstance.getKey(key: "userdefaults_notified_always")!)    // Already notified
            } else {
                locationManager.requestAlwaysAuthorization()
                UserDefaults.standard.set(true, forKey: StringHelper.sharedInstance.getKey(key: 
                    "userdefaults_asked_always")!)        // Already asked
            }
        }
    }
    
}
