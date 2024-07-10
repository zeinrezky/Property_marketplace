//
//  HomeOperation.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 01/03/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import Alamofire

class HomeOperation {
    
    static func categoryItemList(request: HomeCategoryItemRequest, completion: @escaping(Response<[HomeCategoryItemResponse]>) -> Void) {
        do {
            try APIManager.execute(request: request).responseDecodable { (response:
                DataResponse<GeneralResponseArrayType<HomeCategoryItemResponse>, AFError>) in
                completion(Response<[HomeCategoryItemResponse]>.initArrayResult(response))
            }
        } catch {}
    }
    
    static func promoList(request: HomePromoRequest, completion: @escaping(Response<[HomePromoResponse]>) -> Void) {
        do {
            try APIManager.execute(request: request).responseDecodable { (response:
                DataResponse<GeneralResponseArrayType<HomePromoResponse>, AFError>) in
                completion(Response<[HomePromoResponse]>.initArrayResult(response))
            }
        } catch {}
    }
    
    static func nearByList(request: HomeNearByRequest, completion: @escaping(Response<[HomeNearByResponse]>) -> Void) {
//        do {
//            try APIManager.execute(request: request).responseJSON { json in
//                print("json = \(json)")
//            }
//        } catch {}
        
        do {
            try APIManager.execute(request: request).responseDecodable { (response:
                DataResponse<GeneralResponseArrayType<HomeNearByResponse>, AFError>) in
                completion(Response<[HomeNearByResponse]>.initArrayResult(response))
            }
        } catch {}
    }
    
    static func searchList(request: HomeSearchRequest, completion: @escaping(Response<[HomeSearchResponse]>) -> Void) {
        do {
            try APIManager.execute(request: request).responseDecodable { (response:
                DataResponse<GeneralResponseArrayType<HomeSearchResponse>, AFError>) in
                completion(Response<[HomeSearchResponse]>.initArrayResult(response))
            }
        } catch {}
    }
    
    static func locationSearchList(request: HomeLocationSearchRequest, completion: @escaping(Response<[HomeNearByResponse]>) -> Void) {
        do {
            try APIManager.execute(request: request).responseDecodable { (response:
                DataResponse<GeneralResponseArrayType<HomeNearByResponse>, AFError>) in
                completion(Response<[HomeNearByResponse]>.initArrayResult(response))
            }
        } catch {}
    }
}
