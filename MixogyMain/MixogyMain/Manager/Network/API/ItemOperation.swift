//
//  ItemOperation.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 06/03/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import Alamofire

class ItemOperation {
    
    static func detail(request: ItemDetailRequest, completion: @escaping(Response<ItemDetailResponse>) -> Void) {
        do {
            try APIManager.execute(request: request).responseDecodable { (response:
                DataResponse<GeneralResponseType<ItemDetailResponse>, AFError>) in
                completion(Response<ItemDetailResponse>.initResult(response))
            }
        } catch {}
    }
    
    static func location(request: ItemLocationRequest, completion: @escaping(Response<ItemLocatonRsponse>) -> Void) {
//        do {
//            try APIManager.execute(request: request).responseJSON { json in
//                print("json = \(json)")
//            }
//        } catch {}
        
        do {
            try APIManager.execute(request: request).responseDecodable { (response:
                DataResponse<GeneralResponseType<ItemLocatonRsponse>, AFError>) in
                completion(Response<ItemDetailResponse>.initResult(response))
            }
        } catch {}
    }
    
    static func detailCart(request: ItemDetailCartRequest, completion: @escaping(Response<ItemDetailCartResponse>) -> Void) {
//        do {
//            try APIManager.execute(request: request).responseJSON { json in
//                print("json = \(json)")
//            }
//        } catch {}
        
        
        do {
            try APIManager.execute(request: request).responseDecodable { (response:
                DataResponse<GeneralResponseType<ItemDetailCartResponse>, AFError>) in
                completion(Response<ItemDetailCartResponse>.initResult(response))
            }
        } catch {}
    }
}
