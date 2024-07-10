//
//  CollectionMethodRequest.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 10/01/21.
//  Copyright © 2021 Mixogy. All rights reserved.
//

import Alamofire

class CollectionMethodRequest: URLRequestConvertible, GeneralRequest {
    
    var method = HTTPMethod.get
    var headers: [String : String]? = GeneralRequestHeaderType.json.heeaderValue
    var path = Constants.Endpoint + "collection-method"
    var parameters: [String : Any]?
    
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
