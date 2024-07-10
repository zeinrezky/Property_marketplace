//
//  LocationRequest.swift
//  MixogyAdmin
//
//  Created by ABDUL AZIS H on 25/01/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import Alamofire

struct LocationRequest: URLRequestConvertible, GeneralRequest {
    
    var path = Constants.Endpoint + "home/location"
    var method = HTTPMethod.get
    var headers: [String : String]? = GeneralRequestHeaderType.general.heeaderValue
    
    var parameters: [String : Any]? {
        return [
            "search": search,
            "latitude": latitude,
            "longitude": longitude
        ]
    }
    
    var latitude: String
    var longitude: String
    var search: String
    
    func asURLRequest() throws -> URLRequest {
        let url = URL(string: path)!
        var urlRequest = URLRequest(url: url)
        urlRequest.allHTTPHeaderFields = headers
        urlRequest.method = method
        urlRequest.timeoutInterval = 120
        urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        return urlRequest;
    }
}
