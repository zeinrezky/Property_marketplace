//
//  InvoiceOperation.swift
//  MixogyAdmin
//
//  Created by ABDUL AZIS H on 08/02/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import Alamofire

class InvoiceOperation {
    
    static func listPending(request: InvoicePendingRequest, completion: @escaping(Response<InvoicePendingResponse>) -> Void) {
        
        do {
            try APIManager.execute(request: request).responseDecodable { (response:
                DataResponse<GeneralResponseType<InvoicePendingResponse>, AFError>) in
                completion(Response<InvoicePendingResponse>.initResult(response))
            }
        } catch {}
    }
    
    static func listGenerated(request: InvoiceGeneratedRequest, completion: @escaping(Response<InvoiceGeneratedResponse>) -> Void) {
        
        do {
            try APIManager.execute(request: request).responseDecodable { (response:
                DataResponse<GeneralResponseType<InvoiceGeneratedResponse>, AFError>) in
                completion(Response<InvoiceGeneratedResponse>.initResult(response))
            }
        } catch {}
    }
    
    static func listPaid(request: InvoicePaidRequest, completion: @escaping(Response<InvoicePaidResponse>) -> Void) {
        
        do {
            try APIManager.execute(request: request).responseDecodable { (response:
                DataResponse<GeneralResponseType<InvoicePaidResponse>, AFError>) in
                completion(Response<InvoicePaidResponse>.initResult(response))
            }
        } catch {}
    }
}
