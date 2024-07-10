//
//  LoginRequest.swift
//  Mixogy
//
//  Created by ABDUL AZIS H on 13/12/19.
//  Copyright © 2019 Mixogy. All rights reserved.
//

import Alamofire

struct LoginRequest: URLRequestConvertible, GeneralRequest {
    
    var path = Constants.Endpoint + "login"
    var method = HTTPMethod.post
    var parameters: [String : Any]? {
        return [
            "code_phone": countryCode,
            "phone_number": phone,
            "password": password,
            "device_token": deviceToken
        ]
    }
    
    var headers: [String : String]? = GeneralRequestHeaderType.json.heeaderValue
    var countryCode: String
    var phone: String
    var password: String
    var deviceToken: String
    
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
