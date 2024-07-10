//
//  RegisterValidateRequest.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 08/03/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import Alamofire

struct RegisterValidateRequest: URLRequestConvertible, GeneralRequest {
    
    var path = Constants.Endpoint + "register/validate"
    var method = HTTPMethod.post
    var parameters: [String : Any]? {
        return [
            "code_phone": countryCode,
            "phone_number": phoneNumber,
            "email": email
        ]
    }
    
    var headers: [String : String]? = GeneralRequestHeaderType.json.heeaderValue
    var countryCode: String
    var phoneNumber: String
    var name: String
    var email: String
    
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
