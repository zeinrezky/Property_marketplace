//
//  LocationUpdateRequest.swift
//  MixogyAdmin
//
//  Created by ABDUL AZIS H on 26/01/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import Alamofire

struct LocationUpdateRequest: URLRequestConvertible, GeneralRequest {
    
    var path: String {
        return Constants.Endpoint + "master-data/location/\(id)"
    }
    
    var parameters: [String : Any]? {
        return [
            "name": name,
            "place_name": placeName,
            "latitude": latitude,
            "longitude": longitude,
            "start": start.lowercased(),
            "until": until.lowercased(),
            "photo_id": photos
        ]
    }
    
    var method = HTTPMethod.put
    var id: Int
    var headers: [String : String]? = GeneralRequestHeaderType.general.heeaderValue
    var name: String
    var placeName: String
    var latitude: String
    var longitude: String
    var start: String
    var until: String
    var photos: [Int]
    
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
