//
//  AgentDeactiveRequest.swift
//  MixogyAdmin
//
//  Created by ABDUL AZIS H on 21/02/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import Alamofire

struct AgentDeactiveRequest: URLRequestConvertible, GeneralRequest {
    
    var method = HTTPMethod.post
    var path: String = Constants.Endpoint + "agent/deactive"
    
    var parameters: [String : Any]? {
        return [
            "from_agent_id": fromAgentId,
            "to_agent_id": toAgentId,
            "deactive_until": deactiveUntil,
            "password": password
        ]
    }
    
    var headers: [String : String]? = GeneralRequestHeaderType.general.heeaderValue
    var fromAgentId: Int
    var toAgentId: Int
    var deactiveUntil: String
    var password: String
    
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
