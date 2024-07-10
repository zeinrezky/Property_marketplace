//
//  LocationOperation.swift
//  MixogyAdmin
//
//  Created by ABDUL AZIS H on 25/01/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import Alamofire

class LocationOperation {
    
    static func list(request: LocationRequest, completion: @escaping(Response<[LocationResponse]>) -> Void) {
        do {
            try APIManager.execute(request: request).responseDecodable { (response:
                DataResponse<GeneralResponseArrayType<LocationResponse>, AFError>) in
                completion(Response<[LocationResponse]>.initArrayResult(response))
            }
        } catch {}
    }
    
    static func uploadPhoto(request: UploadPhotoRequest, completion: @escaping(Response<UploadPhotoResponse>) -> Void) {
        do {
            try APIManager.execute(request: request).responseDecodable { (response:
                DataResponse<GeneralResponseType<UploadPhotoResponse>, AFError>) in
                completion(Response<UploadPhotoResponse>.initResult(response))
            }
        } catch {}
    }
    
    static func add(request: LocationAddRequest, completion: @escaping(Response<()>) -> Void) {
        do {
            try APIManager.execute(request: request).responseDecodable { (response:
                DataResponse<GeneralResponseVoidType, AFError>) in
                completion(Response<()>.initVoidResult(response))
            }
        } catch {}
    }
    
    static func detail(request: LocationDetailRequest, completion: @escaping(Response<LocationDetailResponse>) -> Void) {
        do {
            try APIManager.execute(request: request).responseDecodable { (response:
                DataResponse<GeneralResponseType<LocationDetailResponse>, AFError>) in
                completion(Response<LocationDetailResponse>.initResult(response))
            }
        } catch {}
    }
    
    static func update(request: LocationUpdateRequest, completion: @escaping(Response<()>) -> Void) {
        do {
            try APIManager.execute(request: request).responseDecodable { (response:
                DataResponse<GeneralResponseVoidType, AFError>) in
                completion(Response<()>.initVoidResult(response))
            }
        } catch {}
    }
}
