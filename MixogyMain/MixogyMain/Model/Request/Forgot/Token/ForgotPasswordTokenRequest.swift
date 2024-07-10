//
//  ForgotPasswordTokenRequest.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 23/04/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import Alamofire

struct ForgotPasswordTokenRequest: URLRequestConvertible, GeneralRequest {
    
    var method = HTTPMethod.post
    var headers: [String : String]? = GeneralRequestHeaderType.json.heeaderValue
    var path = Constants.Endpoint + "forgot/generate-token"
    
    var parameters: [String : Any]? {
        return [
            "code_phone": codePhone,
            "phone_number": phoneNumber
        ]
    }
    
    var codePhone: String
    var phoneNumber: String
    
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
