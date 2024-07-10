//
//  PromoItemRequest.swift
//  MixogyAdmin
//
//  Created by ABDUL AZIS H on 23/02/20.
//  Copyright © 2020 Mixogi. All rights reserved.
//

import Alamofire

struct PromoItemRequest: URLRequestConvertible, GeneralRequest {
    
    var method = HTTPMethod.get
    var headers: [String : String]? = GeneralRequestHeaderType.general.heeaderValue
    var keyword: String
    
    var parameters: [String : Any]? {
        return [
            "keywords": keyword
        ]
    }
    
    var path: String {
        return Constants.Endpoint + "master-data/item"
    }
    
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
