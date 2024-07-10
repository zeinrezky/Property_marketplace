//
//  HomeNearByRequest.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 03/03/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import Alamofire

struct HomeNearByRequest: URLRequestConvertible, GeneralRequest {
    
    var method = HTTPMethod.get
    var headers: [String : String]? = GeneralRequestHeaderType.json.heeaderValue
    var path = Constants.Endpoint + "home/item/nearby"
    
    var parameters: [String : Any]? {
        return [
            "latitude": latitude,
            "longitude": longitude,
            "distance": distance,
            "use_category": true,
            "search": keywords
        ]
    }
    
    var latitude: String
    var longitude: String
    var distance: Int
    var keywords: String
    
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
