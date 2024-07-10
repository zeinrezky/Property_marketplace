//
//  ItemDetailCategory.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 07/04/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import Alamofire

struct ItemDetailCategoryRequest: URLRequestConvertible, GeneralRequest {
    
    var method = HTTPMethod.get
    var headers: [String : String]? = GeneralRequestHeaderType.general.heeaderValue
    var parameters: [String : Any]? {
        return [
            "keywords": keywords
        ]
    }
    
    var path: String {
        return Constants.Endpoint + "seller/sell-item/item-by-category/\(id)"
    }
    
    var id: Int
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
