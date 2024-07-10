//
//  SuggestionRequest.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 25/04/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import Alamofire

struct SuggestionRequest: URLRequestConvertible, GeneralRequest {
    
    var method = HTTPMethod.post
    var headers: [String : String]? = GeneralRequestHeaderType.general.heeaderValue
    var path = Constants.Endpoint + "suggestion"
    
    var parameters: [String : Any]? {
        return [
            "title": title,
            "description": description
        ]
    }
    
    var title: String
    var description: String
    
    func asURLRequest() throws -> URLRequest {
        let url = URL(string: path)!
        var urlRequest = URLRequest(url: url)
        urlRequest.allHTTPHeaderFields = headers
        urlRequest.method = method
        urlRequest.timeoutInterval = 120
        if let parameters = parameters {
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
            } catch {
                throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
            }
        }
        return urlRequest;
    }
}
