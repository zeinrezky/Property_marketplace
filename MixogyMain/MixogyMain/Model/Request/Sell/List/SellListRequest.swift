//
//  SellListRequest.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 04/04/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import Alamofire

struct SellListRequest: URLRequestConvertible, GeneralRequest {
    
    var method = HTTPMethod.get
    var headers: [String : String]? = GeneralRequestHeaderType.general.heeaderValue
    var path = Constants.Endpoint + "seller/list"
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



