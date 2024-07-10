//
//  PromoAddPhoto.swift
//  MixogyAdmin
//
//  Created by ABDUL AZIS H on 02/02/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import Alamofire

struct PromoAddPhotoRequest: URLRequestConvertible, GeneralRequest {
    
    var path = Constants.Endpoint + "promo/add-photo"
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
