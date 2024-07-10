//
//  AgentEditRequest.swift
//  MixogyAdmin
//
//  Created by ABDUL AZIS H on 21/02/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import Alamofire

struct AgentEditRequest: URLRequestConvertible, GeneralRequest {
    
    var method = HTTPMethod.post
    
    var path: String {
        return Constants.Endpoint + "agent/edit/\(id)"
    }
    
    var parameters: [String : Any]? {
        var params: [String : Any] = [
            "name": name,
            "email": email,
            "ktp_number": ktpNumber,
            "phone_number": phoneNumber,
            "location_id": locationId,
            "location_pick_up": locationPickUp,
            "location_pick_up_latitude": locationPickUpLatitude,
            "location_pick_up_longitude": locationPickUpLongitude
        ]
        
        if let ktpImage = ktpImage {
            params["ktp_image"] = ktpImage
        }
        
        if let locationPickUpDetail = locationPickUpDetail {
            params["location_pick_up_detail"] = locationPickUpDetail
        }
        
        return params
    }
    
    var headers: [String : String]? = GeneralRequestHeaderType.general.heeaderValue
    var id: Int
    var name: String
    var email: String
    var ktpNumber: String
    var phoneNumber: String
    var locationId: Int
    var locationPickUp: String
    var locationPickUpLatitude: String
    var locationPickUpLongitude: String
    var locationPickUpDetail: String?
    var ktpImage: String?
    
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
