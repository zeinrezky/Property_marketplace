//
//  PurchaseOperation.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 22/03/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import Alamofire

class PurchaseOperation {
    
    static func myPurchase(request: MyPurchaseRequest, completion: @escaping(Response<[MyPurchaseResponse]>) -> Void) {
//        do {
//            try APIManager.execute(request: request).responseJSON { json in
//                print("json = \(json)")
//            }
//        } catch {}
        
        do {
            try APIManager.execute(request: request).responseDecodable { (response:
                DataResponse<GeneralResponseArrayType<MyPurchaseResponse>, AFError>) in
                completion(Response<[MyPurchaseResponse]>.initArrayResult(response))
            }
        } catch {}
    }
    
    static func history(request: PurchaseHistoryRequest, completion: @escaping(Response<[PurchaseHistoryResponse]>) -> Void) {
        do {
            try APIManager.execute(request: request).responseDecodable { (response:
                DataResponse<GeneralResponseArrayType<PurchaseHistoryResponse>, AFError>) in
                completion(Response<[PurchaseHistoryResponse]>.initArrayResult(response))
            }
        } catch {}
    }
    
    static func itemDetail(request: ItemDetailsRequest, completion: @escaping(Response<ItemDetailsResponse>) -> Void) {
        do {
            try APIManager.execute(request: request).responseDecodable { (response:
                DataResponse<GeneralResponseType<ItemDetailsResponse>, AFError>) in
                completion(Response<ItemDetailsResponse>.initResult(response))
            }
        } catch {}
    }
    
    static func pending(request: PurchasePendingRequest, completion: @escaping(Response<[PurchasePendingResponse]>) -> Void) {
//        do {
//            try APIManager.execute(request: request).responseJSON { json in
//                print("json = \(json)")
//            }
//        } catch {}
        
        do {
            try APIManager.execute(request: request).responseDecodable { (response:
                DataResponse<GeneralResponseArrayType<PurchasePendingResponse>, AFError>) in
                completion(Response<[PurchasePendingResponse]>.initArrayResult(response))
            }
        } catch {}
    }
    
    static func myPurchaseDetail(request: MyPurchaseDetailRequest, completion: @escaping(Response<MyPurchaseDetailResponse>) -> Void) {
//        do {
//            try APIManager.execute(request: request).responseJSON { json in
//                print("json = \(json)")
//            }
//        } catch {}
        
        do {
            try APIManager.execute(request: request).responseDecodable { (response:
                DataResponse<GeneralResponseType<MyPurchaseDetailResponse>, AFError>) in
                completion(Response<MyPurchaseDetailResponse>.initResult(response))
            }
        } catch {}
    }
    
    static func changeLocation(request: ChangeLocationRequest, completion: @escaping(Response<()>) -> Void) {
        do {
            try APIManager.execute(request: request).responseDecodable { (response:
                DataResponse<GeneralResponseVoidType, AFError>) in
                completion(Response<()>.initVoidResult(response))
            }
        } catch {}
    }
    
    static func cancelChangeLocation(request: CancelChangeLocationRequest, completion: @escaping(Response<()>) -> Void) {
        do {
            try APIManager.execute(request: request).responseDecodable { (response:
                DataResponse<GeneralResponseVoidType, AFError>) in
                completion(Response<()>.initVoidResult(response))
            }
        } catch {}
    }
    
    static func redeem(request: RedeemRequest, completion: @escaping(Response<()>) -> Void) {
        do {
            try APIManager.execute(request: request).responseDecodable { (response:
                DataResponse<GeneralResponseVoidType, AFError>) in
                completion(Response<()>.initVoidResult(response))
            }
        } catch {}
    }
    
    static func deleteCoupon(request: DeleteCouponRequest, completion: @escaping(Response<()>) -> Void) {
        do {
            try APIManager.execute(request: request).responseDecodable { (response:
                DataResponse<GeneralResponseVoidType, AFError>) in
                completion(Response<()>.initVoidResult(response))
            }
        } catch {}
    }
    
    static func confirm(request: PurchaseConfirmRequest, completion: @escaping(Response<()>) -> Void) {
        do {
            try APIManager.execute(request: request).responseDecodable { (response:
                DataResponse<GeneralResponseVoidType, AFError>) in
                completion(Response<()>.initVoidResult(response))
            }
        } catch {}
    }
    
    static func rateAgent(request: RateAgentRequest, completion: @escaping(Response<()>) -> Void) {
        do {
            try APIManager.execute(request: request).responseDecodable { (response:
                DataResponse<GeneralResponseVoidType, AFError>) in
                completion(Response<()>.initVoidResult(response))
            }
        } catch {}
    }
}
