//
//  AgentDetailActivateRequest.swift
//  MixogyAdmin
//
//  Created by ABDUL AZIS H on 22/02/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import Alamofire

struct AgentDetailActivateRequest: URLRequestConvertible, GeneralRequest {
    
    var method = HTTPMethod.post
    var path: String = Constants.Endpoint + "agent/active"
    
    var parameters: [String : Any]? {
        return [
            "agent_id": agentId,
        ]
    }
    
    var headers: [String : String]? = GeneralRequestHeaderType.general.heeaderValue
    var agentId: Int
    
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
