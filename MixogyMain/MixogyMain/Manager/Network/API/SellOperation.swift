//
//  SellOperation.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 05/04/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import Alamofire

class SellOperation {

    static func history(request: SellHistoryRequest, completion: @escaping(Response<[SellHistoryResponse]>) -> Void) {
//        do {
//            try APIManager.execute(request: request).responseJSON { json in
//                print("json = \(json)")
//            }
//        } catch {}
        
        do {
            try APIManager.execute(request: request).responseDecodable { (response:
                DataResponse<GeneralResponseArrayType<SellHistoryResponse>, AFError>) in
                completion(Response<[SellHistoryResponse]>.initArrayResult(response))
            }
        } catch {}
    }
    
    static func pendingStatus(request: SellStatusRequest, completion: @escaping(Response<[SellStatusResponse]>) -> Void) {
//        do {
//            try APIManager.execute(request: request).responseJSON { json in
//                print("json = \(json)")
//            }
//        } catch {}
        do {
            try APIManager.execute(request: request).responseDecodable { (response:
                DataResponse<GeneralResponseArrayType<SellStatusResponse>, AFError>) in
                completion(Response<[SellStatusResponse]>.initArrayResult(response))
            }
        } catch {}
    }
    
    static func listing(request: SellListRequest, completion: @escaping(Response<[SellListResponse]>) -> Void) {
//        do {
//            try APIManager.execute(request: request).responseJSON { json in
//                print("json = \(json)")
//            }
//        } catch {}
        
        do {
            try APIManager.execute(request: request).responseDecodable { (response:
                DataResponse<GeneralResponseArrayType<SellListResponse>, AFError>) in
                completion(Response<[SellListResponse]>.initArrayResult(response))
            }
        } catch {}
    }
    
    static func ourAgent(request: OurAgentRequest, completion: @escaping(Response<[OurAgentResponse]>) -> Void) {
        
        do {
            try APIManager.execute(request: request).responseDecodable { (response:
                DataResponse<GeneralResponseArrayType<OurAgentResponse>, AFError>) in
                completion(Response<[OurAgentResponse]>.initArrayResult(response))
            }
        } catch {}
    }
    
    static func detail(request: SelltemDetailRequest, completion: @escaping(Response<SelltemDetailResponse>) -> Void) {
//        do {
//            try APIManager.execute(request: request).responseJSON { json in
//                print("json = \(json)")
//            }
//        } catch {}
        do {
            try APIManager.execute(request: request).responseDecodable { (response:
                DataResponse<GeneralResponseType<SelltemDetailResponse>, AFError>) in
                completion(Response<SelltemDetailResponse>.initResult(response))
            }
        } catch {}
    }
    
    static func historyDetail(request: SelltemDetailRequest, completion: @escaping(Response<SelltemHistoryDetailResponse>) -> Void) {
//        do {
//            try APIManager.execute(request: request).responseJSON { json in
//                print("json = \(json)")
//            }
//        } catch {}
        do {
            try APIManager.execute(request: request).responseDecodable { (response:
                DataResponse<GeneralResponseType<SelltemHistoryDetailResponse>, AFError>) in
                completion(Response<SelltemHistoryDetailResponse>.initResult(response))
            }
        } catch {}
    }
    
    static func cancelListing(request: CancelListingRequest, completion: @escaping(Response<()>) -> Void) {
        do {
            try APIManager.execute(request: request).responseDecodable { (response:
                DataResponse<GeneralResponseVoidType, AFError>) in
                completion(Response<()>.initVoidResult(response))
            }
        } catch {}
    }
    
    static func create(request: SellCreateRequest, completion: @escaping(Response<()>) -> Void) {
        do {
            try APIManager.execute(request: request).responseDecodable { (response:
                DataResponse<GeneralResponseVoidType, AFError>) in
                completion(Response<()>.initVoidResult(response))
            }
        } catch {}
    }
    
    static func edit(request: SellEditRequest, completion: @escaping(Response<()>) -> Void) {
       do {
            try APIManager.execute(request: request).responseDecodable { (response:
                DataResponse<GeneralResponseVoidType, AFError>) in
                completion(Response<()>.initVoidResult(response))
            }
        } catch {}
    }
    
    static func sendItem(request: SellSendItemRequest, completion: @escaping(Response<()>) -> Void) {
        do {
            try APIManager.execute(request: request).responseDecodable { (response:
                DataResponse<GeneralResponseVoidType, AFError>) in
                completion(Response<()>.initVoidResult(response))
            }
        } catch {}
    }
    
    static func suggestion(request: SuggestionRequest, completion: @escaping(Response<()>) -> Void) {
        do {
            try APIManager.execute(request: request).responseDecodable { (response:
                DataResponse<GeneralResponseVoidType, AFError>) in
                completion(Response<()>.initVoidResult(response))
            }
        } catch {}
    }
    
    static func category(request: SellItemCategoryRequest, completion: @escaping(Response<[SellItemCategoryResponse]>) -> Void) {
        do {
            try APIManager.execute(request: request).responseDecodable { (response:
                DataResponse<GeneralResponseArrayType<SellItemCategoryResponse>, AFError>) in
                completion(Response<[SellItemCategoryResponse]>.initArrayResult(response))
            }
        } catch {}
    }
    
    static func itemDetailCategory(request: ItemDetailCategoryRequest, completion: @escaping(Response<[ItemDetailCategoryResponse]>) -> Void) {
        do {
            try APIManager.execute(request: request).responseDecodable { (response:
                DataResponse<GeneralResponseArrayType<ItemDetailCategoryResponse>, AFError>) in
                completion(Response<ItemDetailCategoryResponse>.initArrayResult(response))
            }
        } catch {}
    }
    
    static func createFilter(request: SellCreateFilterRequest, completion: @escaping(Response<[SellCreateFilterResponse]>) -> Void) {
        do {
            try APIManager.execute(request: request).responseDecodable { (response:
                DataResponse<GeneralResponseArrayType<SellCreateFilterResponse>, AFError>) in
                completion(Response<SellCreateFilterResponse>.initArrayResult(response))
            }
        } catch {}
    }
    
    static func createFilterDetail(request: SellCreateFilterDetailRequest, completion: @escaping(Response<SellCreateFilterDetailResponse>) -> Void) {
        
        do {
            try APIManager.execute(request: request).responseDecodable { (response:
                DataResponse<GeneralResponseType<SellCreateFilterDetailResponse>, AFError>) in
                completion(Response<SellCreateFilterDetailResponse>.initResult(response))
            }
        } catch {}
    }
    
    static func itemDetaillist(request: SellItemDetailRequest, completion: @escaping(Response<SellItemDetailResponse>) -> Void) {
//        do {
//            try APIManager.execute(request: request).responseJSON { json in
//                print("json = \(json)")
//            }
//        } catch {}
        
        do {
            try APIManager.execute(request: request).responseDecodable { (response:
                DataResponse<GeneralResponseType<SellItemDetailResponse>, AFError>) in
                completion(Response<SellItemDetailResponse>.initResult(response))
            }
        } catch {}
    }
    
    static func reason(request: CancelReasonRequest, completion: @escaping(Response<[CancelReasonResponse]>) -> Void) {
        do {
            try APIManager.execute(request: request).responseDecodable { (response:
                DataResponse<GeneralResponseArrayType<CancelReasonResponse>, AFError>) in
                completion(Response<[CancelReasonResponse]>.initArrayResult(response))
            }
        } catch {}
    }
    
    static func uploadPhoto(request: SellUploadPhotoRequest, completion: @escaping(Response<UploadPhotoResponse>) -> Void) {
        do {
            try APIManager.execute(request: request).responseDecodable { (response:
                DataResponse<GeneralResponseType<UploadPhotoResponse>, AFError>) in
                completion(Response<UploadPhotoResponse>.initResult(response))
            }
        } catch {}
    }
    
    static func paymentMethod(request: SellPaymentMethodRequest, completion: @escaping(Response<[SellPaymentMethodResponse]>) -> Void) {
        do {
            try APIManager.execute(request: request).responseDecodable { (response:
                DataResponse<GeneralResponseArrayType<SellPaymentMethodResponse>, AFError>) in
                completion(Response<[SellPaymentMethodResponse]>.initArrayResult(response))
            }
        } catch {}
    }
}
