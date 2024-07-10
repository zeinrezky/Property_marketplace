//
//  ProfileOperation.swift
//  MixogyAdmin
//
//  Created by ABDUL AZIS H on 22/02/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import Alamofire

class ProfileOperation {
    static func detail(request: ProfileRequest, completion: @escaping(Response<ProfileResponse>) -> Void) {
        do {
            try APIManager.execute(request: request).responseDecodable { (response:
                DataResponse<GeneralResponseType<ProfileResponse>, AFError>) in
                completion(Response<ProfileResponse>.initResult(response))
            }
        } catch {}
    }
    
    static func edit(request: ProfileEditRequest, completion: @escaping(Response<()>) -> Void) {
        do {
            try APIManager.execute(request: request).responseDecodable { (response:
                DataResponse<GeneralResponseVoidType, AFError>) in
                completion(Response<()>.initVoidResult(response))
            }
        } catch {}
    }
}
