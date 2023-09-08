//
//  AlamofireHandler.swift
//  Pitaya
//
//  Created by Eric Lin on 2022/05/05.
//  Copyright © 2022 Eric Lin. All rights reserved.
//

import Alamofire //(4.9.1)
import SwiftyJSON
import Foundation

class AlamofireHandler {
    static func request(url: URLConvertible, parameters: Dictionary<String, String>? = nil, method: HTTPMethod = .get, encoding: ParameterEncoding? = nil, completion: @escaping (DataResponse<Any>)->()) {
      
        let manager = Alamofire.SessionManager.default //prod
//        let manager =  SecurityCertificateManager.sharedInstance.defaultManager
        
        manager.session.configuration.timeoutIntervalForRequest = 30
                
        let encodingType: ParameterEncoding = {
            if encoding != nil {
                return encoding!
            }
            if method == .get {
                return URLEncoding.default
            } else {
                return JSONEncoding.default
            }
        }()
        manager.request(url, method: method, parameters: parameters, encoding: encodingType).validate().responseJSON { (response) in
            completion(response)
        }
        
    }
    
    static func requestString(url: String, parameters: Dictionary<String, String>? = nil, method: HTTPMethod = .get, encoding: ParameterEncoding? = nil, completion: @escaping (DataResponse<String>)->()) {
      
        let manager = Alamofire.SessionManager.default //prod
//        let manager =  SecurityCertificateManager.sharedInstance.defaultManager
        
        manager.session.configuration.timeoutIntervalForRequest = 30
                
        let encodingType: ParameterEncoding = {
            if encoding != nil {
                return encoding!
            }
            if method == .get {
                return URLEncoding.default
            } else {
                return JSONEncoding.default
            }
        }()
        manager.request(url, method: method, parameters: parameters, encoding: encodingType).validate().responseString { (response) in
            completion(response)
        }
        
    }

}

//https認證
//class SecurityCertificateManager {
//    static let sharedInstance = SecurityCertificateManager()
//
//    let defaultManager: Alamofire.SessionManager = {
//        let serverTrustPolicies: [String: ServerTrustPolicy] = [
//            <#"https://61.67.8.195"#>: .pinCertificates(
//                certificates: ServerTrustPolicy.certificates(),
//                validateCertificateChain: true,
//                validateHost: true),
//            <#"61.67.8.195"#>: .disableEvaluation
//        ]
//
//        let configuration = URLSessionConfiguration.default
//        configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
//
//        return Alamofire.SessionManager(
//            configuration: configuration,
//            serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies)
//        )
//    }()
//}



