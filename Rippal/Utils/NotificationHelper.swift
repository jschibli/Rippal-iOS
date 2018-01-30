//
//  NotificationHelper.swift
//  Rippal
//
//  Created by Tao Wang on 1/27/18.
//  Copyright © 2018 Rippal. All rights reserved.
//

import UIKit

final class NotificationHelper {
    
    static let sharedInstance = NotificationHelper()
    private init() {}
    
    func showAlert(title: String, message: String, actions: [UIAlertAction], context: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for action in actions {
            alert.addAction(action);
        }
        context.present(alert, animated: true, completion: nil)
    }
    
}
