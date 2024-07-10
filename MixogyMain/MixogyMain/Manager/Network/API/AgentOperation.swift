//
//  AgentOperation.swift
//  MixogyAdmin
//
//  Created by ABDUL AZIS H on 17/02/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import Alamofire

class AgentOperation {
    
    static func list(request: AgentRequest, completion: @escaping(Response<[AgentResponse]>) -> Void) {
        
        do {
            try APIManager.execute(request: request).responseDecodable { (response:
                DataResponse<GeneralResponseArrayType<AgentResponse>, AFError>) in
                completion(Response<[AgentResponse]>.initArrayResult(response))
            }
        } catch {}
    }
    
    static func detail(request: AgentDetailRequest, completion: @escaping(Response<AgentDetailResponse>) -> Void) {
        
        do {
            try APIManager.execute(request: request).responseDecodable { (response:
                DataResponse<GeneralResponseType<AgentDetailResponse>, AFError>) in
                completion(Response<AgentDetailResponse>.initResult(response))
            }
        } catch {}
    }
    
    static func deactiveDetail(request: AgentDeactiveDetailRequest, completion: @escaping(Response<AgentDeactiveDetailResponse>) -> Void) {
        
        do {
            try APIManager.execute(request: request).responseDecodable { (response:
                DataResponse<GeneralResponseType<AgentDeactiveDetailResponse>, AFError>) in
                completion(Response<AgentDeactiveDetailResponse>.initResult(response))
            }
        } catch {}
    }
    
    static func approve(request: AgentDetailApproveRequest, completion: @escaping(Response<()>) -> Void) {
        do {
            try APIManager.execute(request: request).responseDecodable { (response:
                DataResponse<GeneralResponseVoidType, AFError>) in
                completion(Response<()>.initVoidResult(response))
            }
        } catch {}
    }
    
    static func reject(request: AgentDetailRejectRequest, completion: @escaping(Response<()>) -> Void) {
        do {
            try APIManager.execute(request: request).responseDecodable { (response:
                DataResponse<GeneralResponseVoidType, AFError>) in
                completion(Response<()>.initVoidResult(response))
            }
        } catch {}
    }
    
    static func edit(request: AgentEditRequest, completion: @escaping(Response<()>) -> Void) {
        do {
            try APIManager.execute(request: request).responseDecodable { (response:
                DataResponse<GeneralResponseVoidType, AFError>) in
                completion(Response<()>.initVoidResult(response))
            }
        } catch {}
    }
    
    static func remove(request: AgentRemoveRequest, completion: @escaping(Response<()>) -> Void) {
        do {
            try APIManager.execute(request: request).responseDecodable { (response:
                DataResponse<GeneralResponseVoidType, AFError>) in
                completion(Response<()>.initVoidResult(response))
            }
        } catch {}
    }
    
    static func deactive(request: AgentDeactiveRequest, completion: @escaping(Response<()>) -> Void) {
        do {
            try APIManager.execute(request: request).responseDecodable { (response:
                DataResponse<GeneralResponseVoidType, AFError>) in
                completion(Response<()>.initVoidResult(response))
            }
        } catch {}
    }
    
    static func activate(request: AgentDetailActivateRequest, completion: @escaping(Response<()>) -> Void) {
        do {
            try APIManager.execute(request: request).responseDecodable { (response:
                DataResponse<GeneralResponseVoidType, AFError>) in
                completion(Response<()>.initVoidResult(response))
            }
        } catch {}
    }
}
