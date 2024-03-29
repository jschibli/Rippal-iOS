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
    
    var email: String?
    var firstName: String?
    var lastName: String?
    var id: String?
    var location: String?
    var position: String?
    var needCacheInfo: Bool = false
    
    var locationManager: CLLocationManager!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        
        UserHelper.sharedInstance.setLoggedIn(loggedIn: true)
        
        if needCacheInfo {
            UserHelper.sharedInstance.cacheUserInfo(email: email!, firstName: firstName!, lastName: lastName!, id: id!, location: location, position: position)
        } else {
            let infoArr: [String] = UserHelper.sharedInstance.loadUserInfo()
            email = infoArr[0]
            firstName = infoArr[1]
            lastName = infoArr[2]
            id = infoArr[3]
            location = infoArr[4]
            position = infoArr[5]
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        if !LinkedInHelper.sharedInstance.hasSession() {
//            // TODO: use localised strings instead
//            var actions: [UIAlertAction] = []
//            actions.append(UIAlertAction(title: "OK", style: .`default`, handler: nil))
//            actions.append(UIAlertAction(title: "Refresh", style: .`default`, handler: { action in
//                DispatchQueue.main.async {
//                    LinkedInHelper.sharedInstance.newSession(successBlock: { returnState in
//                        let session = LISDKSessionManager.sharedInstance().session!
//                        LinkedInHelper.sharedInstance.setSessionAccessToken(accessToken: session.accessToken)
//                    }, errorBlock: { error in
//                        // Do nothing
//                    })
//                }
//            }))
//            NotificationHelper.sharedInstance.showAlert(title: "LinkedIn not connected", message: "You need to connect to your LinkedIn profile to use Rippal", actions: actions, context: self)
//            selectedIndex = 3
//            if let items = self.tabBarController?.tabBar.items {
//                for i in 0 ..< items.count {
//                    let itemToDisable = items[i]
//                    itemToDisable.isEnabled = false
//                }
//            }
//            return
//        }
        
        if !FacebookHelper.sharedInstance.isConnectedWithFacebook() {
            // TODO: use localised strings instead
            var actions: [UIAlertAction] = []
            actions.append(UIAlertAction(title: "OK", style: .`default`, handler: nil))
            actions.append(UIAlertAction(title: "Connect", style: .`default`, handler: { actions in
                DispatchQueue.main.async {
                    FacebookHelper.sharedInstance.connectWithFacebook(vc: self)
                }
            }))
            NotificationHelper.sharedInstance.showAlert(title: "Facebook not connected", message: "You need to connect to your Facebook account to use Rippal", actions: actions, context: self)
            selectedIndex = 3
            if let items = self.tabBarController?.tabBar.items {
                for i in 0 ..< items.count {
                    let itemToDisable = items[i]
                    itemToDisable.isEnabled = false
                }
            }
            return
        }
        
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
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                    return
                }
                
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: { (_) in
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
                    guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                        return
                    }
                    
                    if UIApplication.shared.canOpenURL(settingsUrl) {
                        UIApplication.shared.open(settingsUrl, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
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

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
