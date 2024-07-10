//
//  EditReportRequest.swift
//  MixogyAdmin
//
//  Created by ABDUL AZIS H on 07/02/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import Alamofire

struct EditReportRequest: URLRequestConvertible, GeneralRequest {
    
    var method = HTTPMethod.put
    var headers: [String : String]? = GeneralRequestHeaderType.general.heeaderValue
    
    var path: String {
        return Constants.Endpoint + "report/\(id)"
    }
    
    var parameters: [String : Any]? {
        return [
            "item_code": itemCode,
            "customer_phone_number": customerPhoneNumber,
            "description": description,
            "solution": solution,
            "status": status
        ]
    }
    
    var id: Int
    var itemCode: String
    var customerPhoneNumber: String
    var description: String
    var solution: String
    var status: String
    
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
