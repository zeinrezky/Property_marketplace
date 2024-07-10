//
//  CategoryAddRequest.swift
//  MixogyAdmin
//
//  Created by ABDUL AZIS H on 25/01/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import Alamofire

struct CategoryAddRequest: URLRequestConvertible, GeneralRequest {
    
    var path = Constants.Endpoint + "master-data/category"
    var method = HTTPMethod.post
    var parameters: [String : Any]? {
        return [
            "name": name,
            "level_id": levelId,
            "grace_period_type": gracePeriodType,
            "grace_period_value": gracePeriodValue,
            "active": active,
            "password": password
        ]
    }
    
    var headers: [String : String]? = GeneralRequestHeaderType.general.heeaderValue
    var name: String
    var levelId: Int
    var gracePeriodType: String
    var gracePeriodValue: Int
    var active: String
    var password: String
    
    func asURLRequest() throws -> URLRequest {
        let url = URL(string: path)!
        var urlRequest = URLRequest(url: url)
        urlRequest.allHTTPHeaderFields = headers
        urlRequest.method = method
        urlRequest.timeoutInterval = 120
        if let parameters = parameters {
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
            } catch {
                throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
            }
        }
        return urlRequest;
    }
}
