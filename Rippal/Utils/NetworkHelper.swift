//
//  NetworkHelper.swift
//  Rippal
//
//  Created by Tao Wang on 2/12/18.
//  Copyright © 2018 Rippal. All rights reserved.
//

import Foundation
import Alamofire

var serverRunning = false


final class NetworkHelper {
    
    static let sharedInstance = NetworkHelper()
    let manager: Alamofire.SessionManager
    
    private init() {
        manager = {
            let serverTrustPolicies: [String: ServerTrustPolicy] = [
                Constants.paths.domain: .disableEvaluation,     // TODO: leave only domain here
                "localhost": .disableEvaluation,
                "127.0.0.1": .disableEvaluation
//                "140.233.182.169": .disableEvaluation
            ]
            
            let configuration = URLSessionConfiguration.default
            configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
            
            return Alamofire.SessionManager(
                configuration: configuration,

                serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies)
            )
        }()
    }
    
    func checkServerRunning(completionHandler: @escaping (DefaultDataResponse) -> Void) {
        manager.request(Constants.paths.base_url + Constants.paths.status, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .response(completionHandler: completionHandler)
    }
    
    func checkUserExists(email: String, completionHandler: @escaping (DefaultDataResponse) -> Void) {
        manager.request(Constants.paths.base_url + Constants.paths.exists, method: .get, parameters: ["email": email], encoding: URLEncoding.default)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .response(completionHandler: completionHandler)
    }
    
    func signUp(email: String, firstName: String, lastName: String, id: String, completionHandler: @escaping (DefaultDataResponse) -> Void) {
        let params:[String: String] = [
            "email": email,
            "firstName": firstName,
            "lastName": lastName,
            "id": id
        ]
        manager.request(Constants.paths.base_url + Constants.paths.register, method: .post, parameters: params, encoding: URLEncoding.default)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .response(completionHandler: completionHandler)
    }
    
}
