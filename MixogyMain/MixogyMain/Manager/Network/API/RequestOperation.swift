//
//  RequestOperation.swift
//  MixogyAdmin
//
//  Created by ABDUL AZIS H on 12/02/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import Alamofire

class RequestOperation {
    
    static func list(request: RequestRequest, completion: @escaping(Response<[RequestResponse]>) -> Void) {
        
        do {
            try APIManager.execute(request: request).responseDecodable { (response:
                DataResponse<GeneralResponseArrayType<RequestResponse>, AFError>) in
                completion(Response<[RequestResponse]>.initArrayResult(response))
            }
        } catch {}
    }
    
    static func detail(request: RequestDetailRequest, completion: @escaping(Response<RequestDetailResponse>) -> Void) {
        
        do {
            try APIManager.execute(request: request).responseDecodable { (response:
                DataResponse<GeneralResponseType<RequestDetailResponse>, AFError>) in
                completion(Response<RequestDetailResponse>.initResult(response))
            }
        } catch {}
    }
    
    static func accept(request: RequestAcceptRequest, completion: @escaping(Response<()>) -> Void) {
        
        do {
            try APIManager.execute(request: request).responseDecodable { (response:
                DataResponse<GeneralResponseVoidType, AFError>) in
                completion(Response<()>.initVoidResult(response))
            }
        } catch {}
    }
    
    static func reject(request: RequestRejectRequest, completion: @escaping(Response<()>) -> Void) {
        do {
            try APIManager.execute(request: request).responseDecodable { (response:
                DataResponse<GeneralResponseVoidType, AFError>) in
                completion(Response<()>.initVoidResult(response))
            }
        } catch {}
    }
    
    static func takeItem(request: RequestTakeItemRequest, completion: @escaping(Response<()>) -> Void) {
        do {
            try APIManager.execute(request: request).responseDecodable { (response:
                DataResponse<GeneralResponseVoidType, AFError>) in
                completion(Response<()>.initVoidResult(response))
            }
        } catch {}
    }
    
    static func giveItem(request: RequestGiveItemRequest, completion: @escaping(Response<()>) -> Void) {
        do {
            try APIManager.execute(request: request).responseDecodable { (response:
                DataResponse<GeneralResponseVoidType, AFError>) in
                completion(Response<()>.initVoidResult(response))
            }
        } catch {}
    }
}
