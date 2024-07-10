//
//  CategoryOperation.swift
//  MixogyAdmin
//
//  Created by ABDUL AZIS H on 24/01/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import Alamofire

class CategoryOperation {
    
    static func list(request: CategoryRequest, completion: @escaping(Response<[CategoryResponse]>) -> Void) {
        do {
            try APIManager.execute(request: request).responseDecodable { (response:
                DataResponse<GeneralResponseArrayType<CategoryResponse>, AFError>) in
                completion(Response<[CategoryResponse]>.initArrayResult(response))
            }
        } catch {}
    }
    
    static func detail(request: CategoryDetailRequest, completion: @escaping(Response<CategoryDetailResponse>) -> Void) {
        do {
            try APIManager.execute(request: request).responseDecodable { (response:
                DataResponse<GeneralResponseType<CategoryDetailResponse>, AFError>) in
                completion(Response<CategoryDetailResponse>.initResult(response))
            }
        } catch {}
    }
    
    static func listTemplate(request: TemplateRequest, completion: @escaping(Response<[TemplateResponse]>) -> Void) {
        do {
            try APIManager.execute(request: request).responseDecodable { (response:
                DataResponse<GeneralResponseArrayType<TemplateResponse>, AFError>) in
                completion(Response<[TemplateResponse]>.initArrayResult(response))
            }
        } catch {}
    }
    
    static func add(request: CategoryAddRequest, completion: @escaping(Response<()>) -> Void) {
        do {
            try APIManager.execute(request: request).responseDecodable { (response:
                DataResponse<GeneralResponseVoidType, AFError>) in
                completion(Response<()>.initVoidResult(response))
            }
        } catch {}
    }
    
    static func update(request: CategoryUpdateRequest, completion: @escaping(Response<()>) -> Void) {
        do {
            try APIManager.execute(request: request).responseDecodable { (response:
                DataResponse<GeneralResponseVoidType, AFError>) in
                completion(Response<()>.initVoidResult(response))
            }
        } catch {}
    }
}
