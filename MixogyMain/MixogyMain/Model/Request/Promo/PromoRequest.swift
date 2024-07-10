//
//  PromoRequest.swift
//  MixogyAdmin
//
//  Created by ABDUL AZIS H on 01/02/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import Alamofire

struct PromoRequest: URLRequestConvertible, GeneralRequest {
    var method = HTTPMethod.get
    var headers: [String : String]? = GeneralRequestHeaderType.general.heeaderValue
    var path = Constants.Endpoint + "promo"
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
