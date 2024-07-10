//
//  AddReportRequest.swift
//  MixogyAdmin
//
//  Created by ABDUL AZIS H on 07/02/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import Alamofire

struct AddReportRequest: URLRequestConvertible, GeneralRequest {
    
    var path = Constants.Endpoint + "report"
    var method = HTTPMethod.post
    var headers: [String : String]? = GeneralRequestHeaderType.general.heeaderValue
    
    var parameters: [String : Any]? {
        return [
            "item_code": itemCode,
            "phone_number": customerPhoneNumber,
            "description": description,
            "solution": solution
        ]
    }
    
    var itemCode: String
    var customerPhoneNumber: String
    var description: String
    var solution: String
    
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
