//
//  AuthOperation.swift
//  Mixogy
//
//  Created by ABDUL AZIS H on 14/12/19.
//  Copyright © 2019 Mixogy. All rights reserved.
//

import Alamofire

class AuthOperation {
    
    static func login(request: LoginRequest, completion: @escaping(Response<LoginResponse>) -> Void) {
        do {
            try APIManager.execute(request: request).responseDecodable { (response: DataResponse<GeneralResponseType<LoginResponse>, AFError>) in
                completion(Response<LoginResponse>.initResult(response))
            }
        } catch {}
    }
    
    static func registerValidate(request: RegisterValidateRequest, completion: @escaping(Response<()>) -> Void) {
        do {
            try APIManager.execute(request: request).responseDecodable { (response:
                DataResponse<GeneralResponseVoidType, AFError>) in
                completion(Response<()>.initVoidResult(response))
            }
        } catch {}
    }
    
    static func register(request: RegisterRequest, completion: @escaping(Response<()>) -> Void) {
        do {
            try APIManager.execute(request: request).responseDecodable { (response:
                DataResponse<GeneralResponseVoidType, AFError>) in
                completion(Response<()>.initVoidResult(response))
            }
        } catch {}
    }
    
    static func changePassword(request: ChangePasswordRequest, completion: @escaping(Response<()>) -> Void) {
        do {
            try APIManager.execute(request: request).responseDecodable { (response:
                DataResponse<GeneralResponseVoidType, AFError>) in
                completion(Response<()>.initVoidResult(response))
            }
        } catch {}
    }
    
    static func upgrade(request: RegisterUpgradeRequest, completion: @escaping(Response<()>) -> Void) {
        do {
            try APIManager.execute(request: request).responseDecodable { (response:
                DataResponse<GeneralResponseVoidType, AFError>) in
                completion(Response<()>.initVoidResult(response))
            }
        } catch {}
    }
    
    static func forgotPassword(request: ForgotPasswordRequest, completion: @escaping(Response<()>) -> Void) {
        do {
            try APIManager.execute(request: request).responseDecodable { (response:
                DataResponse<GeneralResponseVoidType, AFError>) in
                completion(Response<()>.initVoidResult(response))
            }
        } catch {}
    }
    
    static func forgotPasswordToken(request: ForgotPasswordTokenRequest, completion: @escaping(Response<ForgotPasswordTokenResponse>) -> Void) {
        do {
            try APIManager.execute(request: request).responseDecodable { (response: DataResponse<GeneralResponseType<ForgotPasswordTokenResponse>, AFError>) in
                completion(Response<ForgotPasswordTokenResponse>.initResult(response))
            }
        } catch {}
    }
}
