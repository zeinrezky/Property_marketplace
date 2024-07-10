//
//  InboxOperation.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 03/04/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import Alamofire

class InboxOperation {
    
    static func list(request: InboxRequest, completion: @escaping(Response<[InboxResponse]>) -> Void) {
        do {
            try APIManager.execute(request: request).responseDecodable { (response:
                DataResponse<GeneralResponseArrayType<InboxResponse>, AFError>) in
                completion(Response<[InboxResponse]>.initArrayResult(response))
            }
        } catch {}
    }
}
