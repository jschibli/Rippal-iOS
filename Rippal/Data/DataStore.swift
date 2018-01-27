//
//  DataStore.swift
//  Rippal
//
//  Created by Tao Wang on 1/26/18.
//  Copyright © 2018 Rippal. All rights reserved.
//

import Foundation
import UIKit

final class DataStore {
    
    static let sharedInstance = DataStore()
    fileprivate init() {}
    
    var cities: [City] = []
    // TODO: same thing for connections
    
    // Pulls from local and updates
    func loadCities(completion: @escaping () -> Void) {
        // TODO: pull up locally saved cities
        
        // TODO: check for current location if permission given, and refresh city list
        
        
        completion()
    }
}
