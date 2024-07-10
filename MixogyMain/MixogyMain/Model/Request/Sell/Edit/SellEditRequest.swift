//
//  SellEditRequest.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 15/04/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import Alamofire

struct SellEditRequest: URLRequestConvertible, GeneralRequest {
    
    var method = HTTPMethod.put
    var headers: [String : String]? = GeneralRequestHeaderType.general.heeaderValue
    var path: String {
        return Constants.Endpoint + "seller/sell-item/edit/\(id)"
    }
    
    var parameters: [String : Any]? {
        var info: [String : Any] = [
            "your_price": yourPrice,
            "description": description
        ]
        
        if let confidentialnformation = confidentialnformation {
            info["confidential_information"] = confidentialnformation
        }
        
        if let multiplePhotos = multiplePhotos {
            info["multiple_photos"] = multiplePhotos
        }
        
        return info
    }
    
    var id: Int
    var yourPrice: Int
    var description: String
    var confidentialnformation: String?
    var multiplePhotos: [Int]?
    
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
