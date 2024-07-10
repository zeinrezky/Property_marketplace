//
//  HomeCategoryItemRequest.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 01/03/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import Alamofire

struct HomeCategoryItemRequest: URLRequestConvertible, GeneralRequest {
    
    var method = HTTPMethod.get
    var headers: [String : String]? {
        return Preference.auth != nil ? GeneralRequestHeaderType.general.heeaderValue : GeneralRequestHeaderType.json.heeaderValue
    }
    
    var parameters: [String : Any]?
    var path: String {
        return Constants.Endpoint + "home/item/\(id)"
    }
    
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
