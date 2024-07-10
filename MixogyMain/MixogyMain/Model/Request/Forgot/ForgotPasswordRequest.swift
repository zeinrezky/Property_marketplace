//
//  ForgotPasswordRequest.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 23/04/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import Alamofire

struct ForgotPasswordRequest: URLRequestConvertible, GeneralRequest {
    
    var method = HTTPMethod.post
    var headers: [String : String]? = GeneralRequestHeaderType.json.heeaderValue
    var path = Constants.Endpoint + "forgot/reset-password"
    
    var parameters: [String : Any]? {
        return [
            "code_phone": codePhone,
            "phone_number": phoneNumber,
            "token": token,
            "password": password,
            "verify_password": password
        ]
    }
    
    var codePhone: String
    var phoneNumber: String
    var token: String
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
