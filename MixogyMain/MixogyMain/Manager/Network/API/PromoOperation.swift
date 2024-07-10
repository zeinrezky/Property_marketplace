//
//  PromoOperation.swift
//  MixogyAdmin
//
//  Created by ABDUL AZIS H on 01/02/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import Alamofire

class PromoOperation {

    static func list(request: PromoRequest, completion: @escaping(Response<[PromoResponse]>) -> Void) {
        do {
            try APIManager.execute(request: request).responseDecodable { (response:
                DataResponse<GeneralResponseArrayType<PromoResponse>, AFError>) in
                completion(Response<[PromoResponse]>.initArrayResult(response))
            }
        } catch {}
    }
    
    static func uploadPhoto(request: PromoAddPhotoRequest, completion: @escaping(Response<PromoAddPhotoResponse>) -> Void) {
        do {
            try APIManager.execute(request: request).responseDecodable { (response:
                DataResponse<GeneralResponseType<PromoAddPhotoResponse>, AFError>) in
                completion(Response<PromoAddPhotoResponse>.initResult(response))
            }
        } catch {}
    }
    
    static func detail(request: PromoDetailRequest, completion: @escaping(Response<PromoDetailResponse>) -> Void) {
        do {
            try APIManager.execute(request: request).responseDecodable { (response:
                DataResponse<GeneralResponseType<PromoDetailResponse>, AFError>) in
                completion(Response<PromoDetailResponse>.initResult(response))
            }
        } catch {}
    }
    
    static func listItem(request: PromoItemRequest, completion: @escaping(Response<[PromoItemResponse]>) -> Void) {
        do {
            try APIManager.execute(request: request).responseDecodable { (response:
                DataResponse<GeneralResponseArrayType<PromoItemResponse>, AFError>) in
                completion(Response<[PromoItemResponse]>.initArrayResult(response))
            }
        } catch {}
    }
}
