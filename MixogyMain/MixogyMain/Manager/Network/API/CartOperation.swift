//
//  CartOperation.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 09/03/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import Alamofire

class CartOperation {
    
    static func detail(request: CartRequest, completion: @escaping(Response<CartResponse>) -> Void) {
        do {
            try APIManager.execute(request: request).responseDecodable { (response:
                DataResponse<GeneralResponseType<CartResponse>, AFError>) in
                completion(Response<CartResponse>.initResult(response))
            }
        } catch {}
    }
    
    static func add(request: CartAddRequest, completion: @escaping(Response<CartAddResponse>) -> Void) {
        do {
            try APIManager.execute(request: request).responseDecodable { (response:
                DataResponse<GeneralResponseType<CartAddResponse>, AFError>) in
                completion(Response<CartAddResponse>.initResult(response))
            }
        } catch {}
    }
    
    static func deliveryFee(request: CartFeeRequest, completion: @escaping(Response<CartFeeResponse>) -> Void) {
        do {
            try APIManager.execute(request: request).responseDecodable { (response:
                DataResponse<GeneralResponseType<CartFeeResponse>, AFError>) in
                completion(Response<CartFeeResponse>.initResult(response))
            }
        } catch {}
    }
    
    static func remove(request: CartRemoveRequest, completion: @escaping(Response<CartRemoveResponse>) -> Void) {
        
        do {
            try APIManager.execute(request: request).responseDecodable { (response:
                DataResponse<GeneralResponseType<CartRemoveResponse>, AFError>) in
                completion(Response<CartRemoveResponse>.initResult(response))
            }
        } catch {}    }
    
    static func addressList(request: CartAddressRequest, completion: @escaping(Response<[CartAddressResponse]>) -> Void) {
        do {
            try APIManager.execute(request: request).responseDecodable { (response:
                DataResponse<GeneralResponseArrayType<CartAddressResponse>, AFError>) in
                completion(Response<[CartAddressResponse]>.initArrayResult(response))
            }
        } catch {}
    }
    
    static func addressDetail(request: CartAddressDetailRequest, completion: @escaping(Response<CartAddressDetailResponse>) -> Void) {
        do {
            try APIManager.execute(request: request).responseDecodable { (response:
                DataResponse<GeneralResponseType<CartAddressDetailResponse>, AFError>) in
                completion(Response<CartAddressDetailResponse>.initResult(response))
            }
        } catch {}
    }
    
    static func provinceList(request: CartProvinceRequest, completion: @escaping(Response<[CartProvinceResponse]>) -> Void) {
        do {
            try APIManager.execute(request: request).responseDecodable { (response:
                DataResponse<GeneralResponseArrayType<CartProvinceResponse>, AFError>) in
                completion(Response<[CartProvinceResponse]>.initArrayResult(response))
            }
        } catch {}
    }
    
    static func cityList(request: CartCityRequest, completion: @escaping(Response<[CartCityResponse]>) -> Void) {
        do {
            try APIManager.execute(request: request).responseDecodable { (response:
                DataResponse<GeneralResponseArrayType<CartCityResponse>, AFError>) in
                completion(Response<[CartCityResponse]>.initArrayResult(response))
            }
        } catch {}
    }
    
    static func batchPickup(request: BatchPickupRequest, completion: @escaping(Response<[BatchPickupResponse]>) -> Void) {
        
        do {
            try APIManager.execute(request: request).responseDecodable { (response:
                DataResponse<GeneralResponseArrayType<BatchPickupResponse>, AFError>) in
                completion(Response<[BatchPickupResponse]>.initArrayResult(response))
            }
        } catch {}
    }
    
    static func addAddress(request: CartAddressAddRequest, completion: @escaping(Response<()>) -> Void) {
        do {
            try APIManager.execute(request: request).responseDecodable { (response:
                DataResponse<GeneralResponseVoidType, AFError>) in
                completion(Response<()>.initVoidResult(response))
            }
        } catch {}
    }
    
    static func editAddress(request: CartAddressEditRequest, completion: @escaping(Response<()>) -> Void) {
        do {
            try APIManager.execute(request: request).responseDecodable { (response:
                DataResponse<GeneralResponseVoidType, AFError>) in
                completion(Response<()>.initVoidResult(response))
            }
        } catch {}
    }
    
    static func collectionMethod(request: CollectionMethodRequest, completion: @escaping(Response<[CollectionMethodResponse]>) -> Void) {
        
        do {
            try APIManager.execute(request: request).responseDecodable { (response:
                DataResponse<GeneralResponseArrayType<CollectionMethodResponse>, AFError>) in
                completion(Response<[CollectionMethodResponse]>.initArrayResult(response))
            }
        } catch {}
    }
}
