//
//  UploadPhotoRequest.swift
//  MixogyAdmin
//
//  Created by ABDUL AZIS H on 26/01/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import Alamofire

struct UploadPhotoRequest: URLRequestConvertible, GeneralRequest {
    
    var path = Constants.Endpoint + "master-data/location/add-photo"
    var method = HTTPMethod.post
    var parameters: [String : Any]? {
        return [
            "photo": photo
        ]
    }
    
    var headers: [String : String]? = GeneralRequestHeaderType.general.heeaderValue
    var photo: String
    
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
