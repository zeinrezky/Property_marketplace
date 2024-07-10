//
//  SellSendItemRequest.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 11/04/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import Alamofire

struct SellSendItemRequest: URLRequestConvertible, GeneralRequest {
    
    var method = HTTPMethod.post
    var headers: [String : String]? = GeneralRequestHeaderType.general.heeaderValue
    var path: String {
        return Constants.Endpoint + "seller/send-item/\(id)"
    }
    
    var parameters: [String : Any]? {
        return [
            "courier_name": courierName,
            "resi_number": courierResi,
            "contact_number": courierPhone
        ]
    }
    
    var id: Int
    var courierName: String
    var courierResi: String
    var courierPhone: String
    
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
