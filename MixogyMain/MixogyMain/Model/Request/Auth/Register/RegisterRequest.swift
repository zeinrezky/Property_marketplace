//
//  RegisterRequest.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 08/03/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import Alamofire

struct RegisterRequest: URLRequestConvertible, GeneralRequest {
    
    var path = Constants.Endpoint + "register"
    var method = HTTPMethod.post
    var parameters: [String : Any]? {
        var params: [String : Any] = [
            "code_phone": countryCode,
            "phone_number": phoneNumber,
            "name": name,
            "email": email,
            "is_seller": isSeller
        ]
        
        if let address = address {
            params["address"] = address
        }
        
        if let bank = bank {
            params["bank"] = bank
        }
        
        if let bankNumber = bankNumber {
            params["bank_number"] = bankNumber
        }
        
        if let ktpNumber = ktpNumber {
            params["ktp_number"] = ktpNumber
        }
        
        if let password = password {
            params["password"] = password
        }
        
        if let ktpImage = ktpImage {
            params["ktp_image"] = ktpImage
        }
        
        return params
    }
    
    var headers: [String : String]? = GeneralRequestHeaderType.json.heeaderValue
    var countryCode: String
    var phoneNumber: String
    var name: String
    var email: String
    var isSeller: Bool
    var address: String?
    var bank: String?
    var bankNumber: String?
    var ktpNumber: String?
    var password: String?
    var ktpImage: String?
    
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
