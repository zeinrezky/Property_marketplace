//
//  StaticOperation.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 01/07/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import Alamofire

class StaticOperation {
    
    static func detail(request: StaticRequest, completion: @escaping(Response<StaticResponse>) -> Void) {
        do {
            try APIManager.execute(request: request).responseDecodable { (response:
                DataResponse<GeneralResponseType<StaticResponse>, AFError>) in
                completion(Response<StaticResponse>.initResult(response))
            }
        } catch {}
    }
    
    static func faq(request: FAQRequest, completion: @escaping(Response<[FAQResponse]>) -> Void) {
        do {
            try APIManager.execute(request: request).responseDecodable { (response:
                DataResponse<GeneralResponseArrayType<FAQResponse>, AFError>) in
                completion(Response<FAQResponse>.initArrayResult(response))
            }
        } catch {}
    }
}
