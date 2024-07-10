//
//  BankOperation.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 21/10/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import Alamofire

class BankOperation {
    
    static func list(request: BankRequest, completion: @escaping(Response<[BankResponse]>) -> Void) {
        do {
            try APIManager.execute(request: request).responseDecodable { (response:
                DataResponse<GeneralResponseArrayType<BankResponse>, AFError>) in
                completion(Response<[BankResponse]>.initArrayResult(response))
            }
        } catch {}
    }
}
