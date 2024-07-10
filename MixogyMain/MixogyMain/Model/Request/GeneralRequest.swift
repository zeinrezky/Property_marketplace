//
//  GeneralRequest.swift
//  Mixogy
//
//  Created by ABDUL AZIS H on 13/12/19.
//  Copyright © 2019 Mixogy. All rights reserved.
//

import Alamofire

protocol GeneralRequest {
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: [String: Any]? { get }
    var headers: [String: String]? { get }
}

enum GeneralRequestHeaderType {
    case general
    case json
    case upload
    
    var heeaderValue: [String: String]? {
        var header: [String: String]?
        switch self {
        case .general:
            if let auth = Preference.auth {
                header = [
                    "Content-Type": "application/json",
                    "Accept": "application/json",
                    "Authorization": auth.token
                ]
            }
            
        case .upload:
            if let auth = Preference.auth {
                header = [
                    "Content-Type": "multipart/form-data",
                    "Authorization": auth.token
                ]
            }
            
        default:
            header = [
                "Content-Type": "application/json",
                "Accept": "application/json",
            ]
        }
        
        return header
    }
}
