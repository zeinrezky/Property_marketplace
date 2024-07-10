//
//  HomeSearchRequest.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 03/03/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import Alamofire

struct HomeSearchRequest: URLRequestConvertible, GeneralRequest {
    
    var method = HTTPMethod.get
    var headers: [String : String]? = GeneralRequestHeaderType.json.heeaderValue
    
    var path: String {
        return Constants.Endpoint + "home/item/\(id)"
    }
    
    var parameters: [String : Any]? {
        return [
            "search": search
        ]
    }
    
    var search: String
    var id: Int
    
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
