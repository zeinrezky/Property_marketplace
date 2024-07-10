//
//  SellPaymentMethodRequest.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 04/04/21.
//  Copyright © 2021 Mixogy. All rights reserved.
//

import Alamofire

struct SellPaymentMethodRequest: URLRequestConvertible, GeneralRequest {
    
    var method = HTTPMethod.get
    var headers: [String : String]? = GeneralRequestHeaderType.general.heeaderValue
    var parameters: [String : Any]?
    
    var path: String {
        return Constants.Endpoint + "collection-method"
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
