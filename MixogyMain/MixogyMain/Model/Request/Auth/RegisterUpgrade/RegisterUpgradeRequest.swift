//
//  RegisterUpgradeRequest.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 22/04/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import Alamofire

struct RegisterUpgradeRequest: URLRequestConvertible, GeneralRequest {
    
    var path = Constants.Endpoint + "profile/upgrade"
    var method = HTTPMethod.post
    var parameters: [String : Any]? {
        var params: [String : Any] = [
            "bank": bank,
            "bank_number": bankNumber,
            "ktp_number": ktpNumber,
            "ktp_image": ktpImage
        ]
        
        if let address = address {
            params["address"] = address
        }
        
        return params
    }
    
    var headers: [String : String]? = GeneralRequestHeaderType.general.heeaderValue
    var address: String?
    var bank: String
    var bankNumber: String
    var ktpNumber: String
    var ktpImage: String
    
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
