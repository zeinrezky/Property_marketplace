//
//  OnBoardingCategoryRequest.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 01/03/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import Alamofire

struct OnBoardingCategoryRequest: URLRequestConvertible, GeneralRequest {
    
    var method = HTTPMethod.get
    var headers: [String : String]? = GeneralRequestHeaderType.json.heeaderValue
    var parameters: [String : Any]?
    var path = Constants.Endpoint + "home/category"
    
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
