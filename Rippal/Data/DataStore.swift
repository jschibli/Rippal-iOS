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
    var connections: [Connection] = []
    
    // Pulls from saved connections and updates
    func loadCities(completion: @escaping () -> Void) {
        // TODO: pull up locally saved cities
        
        // TODO: check for current location if permission given, and refresh city list
        
        
        completion()
    }
    
    // Pulls from saved connections and updates
    func loadConnections(completion: @escaping () -> Void) {
        // TODO: pull up locally saved connections
        
        // TODO: check for current location if permission given and refresh city list
    }
}
