//
//  DeleteCouponRequest.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 24/01/21.
//  Copyright © 2021 Mixogy. All rights reserved.
//

import Alamofire

struct DeleteCouponRequest: URLRequestConvertible, GeneralRequest {
    
    var method = HTTPMethod.post
    var headers: [String : String]? = GeneralRequestHeaderType.general.heeaderValue
    
    var parameters: [String : Any]? {
        return [
            "transaction_detail_id": transactionDetailId
        ]
    }
    
    var path: String {
        return Constants.Endpoint + "purchase/delete-coupon"
    }
    
    var transactionDetailId: Int
    
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
