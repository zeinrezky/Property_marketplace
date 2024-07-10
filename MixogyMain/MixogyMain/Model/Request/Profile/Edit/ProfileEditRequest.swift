//
//  ProfileEditRequest.swift
//  MixogyAdmin
//
//  Created by ABDUL AZIS H on 22/02/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import Alamofire

struct ProfileEditRequest: URLRequestConvertible, GeneralRequest {
    
    var method = HTTPMethod.put
    var path = Constants.Endpoint + "profile"
    
    var parameters: [String : Any]? {
        var params: [String: Any] = [:]
        
        if let photo = photo {
            params["photo"] = photo
        }
        
        if let radius = radius {
            params["nearby_radius"] = radius
        }
        
        return params
    }
    
    var headers: [String : String]? = GeneralRequestHeaderType.general.heeaderValue
    var photo: String?
    var radius: Int?
    
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
