//
//  CartAddressEditRequest.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 28/03/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import Alamofire

struct CartAddressEditRequest: URLRequestConvertible, GeneralRequest {
    
    var method = HTTPMethod.put
    var headers: [String : String]? = GeneralRequestHeaderType.general.heeaderValue
    var path: String {
        return Constants.Endpoint + "delivery/address/\(id)"
    }
    
    var parameters: [String : Any]? {
        return [
            "code": code,
            "phone": phone,
            "place_name": placeName,
            "latitude": latitude,
            "detail": detail,
            "longitude": longitude,
            "city_id": cityId
        ]
    }
    
    var id: Int
    var code: String
    var phone: String
    var placeName: String
    var detail: String
    var latitude: String
    var longitude: String
    var cityId: Int
    
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
