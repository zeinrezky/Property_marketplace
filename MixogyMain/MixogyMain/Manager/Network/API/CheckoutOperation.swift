//
//  CheckoutOperation.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 29/03/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import Alamofire

class CheckoutOperation {
    
    static func add(request: CheckoutAddRequest, completion: @escaping(Response<CheckoutAddResponse>) -> Void) {
        
        do {
            try APIManager.execute(request: request).responseDecodable { (response:
                DataResponse<GeneralResponseType<CheckoutAddResponse>, AFError>) in
                completion(Response<CheckoutAddResponse>.initResult(response))
            }
        } catch {}
    }
    
    static func detail(request: CheckoutDetailRequest, completion: @escaping(Response<CheckoutDetailResponse>) -> Void) {
        do {
            try APIManager.execute(request: request).responseDecodable { (response:
                DataResponse<GeneralResponseType<CheckoutDetailResponse>, AFError>) in
                completion(Response<CheckoutDetailResponse>.initResult(response))
            }
        } catch {}
    }
    
    static func pay(request: CheckoutPayRequest, completion: @escaping(Response<CheckoutPayResponse>) -> Void) {        
        do {
            try APIManager.execute(request: request).responseDecodable { (response:
                DataResponse<GeneralResponseType<CheckoutPayResponse>, AFError>) in
                completion(Response<CheckoutPayResponse>.initResult(response))
            }
        } catch {}
    }
    
    static func cancel(request: CheckoutCancelRequest, completion: @escaping(Response<()>) -> Void) {
        do {
            try APIManager.execute(request: request).responseDecodable { (response:
                DataResponse<GeneralResponseVoidType, AFError>) in
                completion(Response<()>.initVoidResult(response))
            }
        } catch {}
    }
}
