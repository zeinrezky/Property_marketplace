//
//  APIManager.swift
//  Mixogy
//
//  Created by ABDUL AZIS H on 13/12/19.
//  Copyright © 2019 Mixogy. All rights reserved.
//

import Alamofire

class APIManager {
    
    static func execute(request: URLRequestConvertible) throws -> DataRequest {
        return AF.request(request)
    }
    
    static func uploadForm(request: URLRequestConvertible, form: MultipartFormData) throws -> UploadRequest {
        return AF.upload(multipartFormData: form, with: request)
    }
    
    static func download(request: URLConvertible, path: String) throws -> DownloadRequest {
        let destination: DownloadRequest.Destination = { _, _ in
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent(path)

            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        return AF.download(
            request,
            method: .get,
            parameters: nil,
            encoding: JSONEncoding.default,
            headers: nil,
            to: destination
        )
    }
}
