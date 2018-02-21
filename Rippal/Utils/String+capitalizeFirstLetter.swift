//
//  String+capitalizeFirstLetter.swift
//  Rippal
//
//  Created by Tao Wang on 2/20/18.
//  Copyright © 2018 Rippal. All rights reserved.
//

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
