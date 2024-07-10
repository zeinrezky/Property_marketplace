//
//  ItemLocatonRequest.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 20/08/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import Alamofire

struct ItemLocationRequest: URLRequestConvertible, GeneralRequest {
    
    var method = HTTPMethod.get
    var headers: [String : String]? {
        return Preference.auth != nil ? GeneralRequestHeaderType.general.heeaderValue : GeneralRequestHeaderType.json.heeaderValue
    }
    
    var path: String {
        return Constants.Endpoint + "item/customer-item/detail-collection/\(id)"
    }
    
    var parameters: [String : Any]? {
        return [
            "name": name,
            "type_id": typeId
        ]
    }
    
    var id: Int
    var typeId: Int
    var name: String
    
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
