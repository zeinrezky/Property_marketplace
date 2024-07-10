//
//  ReportOperation.swift
//  MixogyAdmin
//
//  Created by ABDUL AZIS H on 06/02/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import Alamofire

class ReportOperation {
    static func list(request: ReportRequest, completion: @escaping(Response<[ReportResponse]>) -> Void) {
        
        do {
            try APIManager.execute(request: request).responseDecodable { (response:
                DataResponse<GeneralResponseArrayType<ReportResponse>, AFError>) in
                completion(Response<[ReportResponse]>.initArrayResult(response))
            }
        } catch {}
    }
    
    static func add(request: AddReportRequest, completion: @escaping(Response<()>) -> Void) {
        do {
            try APIManager.execute(request: request).responseDecodable { (response:
                DataResponse<GeneralResponseVoidType, AFError>) in
                completion(Response<()>.initVoidResult(response))
            }
        } catch {}
    }
    
    static func detail(request: DetailReportRequest, completion: @escaping(Response<DetailResportResponse>) -> Void) {
        do {
            try APIManager.execute(request: request).responseDecodable { (response:
                DataResponse<GeneralResponseType<DetailResportResponse>, AFError>) in
                completion(Response<DetailResportResponse>.initResult(response))
            }
        } catch {}
    }
    
    static func edit(request: EditReportRequest, completion: @escaping(Response<()>) -> Void) {
        do {
            try APIManager.execute(request: request).responseDecodable { (response:
                DataResponse<GeneralResponseVoidType, AFError>) in
                completion(Response<()>.initVoidResult(response))
            }
        } catch {}
    }
}
