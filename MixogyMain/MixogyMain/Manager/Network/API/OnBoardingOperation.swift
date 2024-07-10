//
//  OnBoardingOperation.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 01/03/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import Alamofire

class OnBoardingOperation {
    
    static func categoryList(request: OnBoardingCategoryRequest, completion: @escaping(Response<[OnBoardingCategoryResponse]>) -> Void) {
        do {
            try APIManager.execute(request: request).responseDecodable { (response:
                DataResponse<GeneralResponseArrayType<OnBoardingCategoryResponse>, AFError>) in
                completion(Response<[OnBoardingCategoryResponse]>.initArrayResult(response))
            }
        } catch {}
    }
}
