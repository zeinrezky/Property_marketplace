//
//  LocationDetailRequest.swift
//  MixogyAdmin
//
//  Created by ABDUL AZIS H on 26/01/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import Alamofire

struct LocationDetailRequest: URLRequestConvertible, GeneralRequest {
    
    var path: String {
        return Constants.Endpoint + "master-data/location/\(id)"
    }
    
    var method = HTTPMethod.get
    var parameters: [String : Any]?
    var headers: [String : String]? = GeneralRequestHeaderType.general.heeaderValue
    let id: Int
    
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
