//
//  NetworkHelper.swift
//  Rippal
//
//  Created by Tao Wang on 2/12/18.
//  Copyright © 2018 Rippal. All rights reserved.
//

import Foundation
import Alamofire

final class NetworkHelper {
    
    static let sharedInstance = NetworkHelper()
    private init() {}
    
    func signUpWithEmail(email: String) {
        Alamofire.request(Constants.paths.base_url + Constants.paths.login, method: .get, parameters: nil, encoding: URLEncoding.default)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .response { result in
                // TODO: handle response
            }
    }
    
}
