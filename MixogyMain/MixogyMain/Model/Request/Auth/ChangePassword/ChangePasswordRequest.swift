//
//  ChangePasswordRequest.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 15/03/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import Alamofire

struct ChangePasswordRequest: URLRequestConvertible, GeneralRequest {
    
    var path = Constants.Endpoint + "change-password"
    var method = HTTPMethod.post
    var headers: [String : String]? = GeneralRequestHeaderType.general.heeaderValue
    var codePhone: String
    var phoneNumber: String
    var currentPassword: String
    var confirmCurrentPassword: String
    var newPassword: String
    var confirmNewPassword: String
    
    var parameters: [String : Any]? {
        return [
            "code_phone": codePhone,
            "phone_number": phoneNumber,
            "current_password": currentPassword,
            "confirm_current_password": confirmCurrentPassword,
            "new_password": newPassword,
            "confirm_new_password": confirmNewPassword
        ]
    }
    
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
