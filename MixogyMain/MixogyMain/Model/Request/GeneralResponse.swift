//
//  GeneralResponse.swift
//  Mixogy
//
//  Created by ABDUL AZIS H on 14/12/19.
//  Copyright © 2019 Mixogy. All rights reserved.
//

import Alamofire

struct GeneralResponseType<T:Codable>: Codable {
    let success: Bool
    let status: Int
    let error: AEError?
    let data: T?
}

struct GeneralResponseArrayType<T:Codable>: Codable {
    let success: Bool
    let status: Int
    let error: AEError?
    let data: [T]?
}

struct GeneralResponseVoidType: Codable {
    let success: Bool
    let error: AEError?
}

enum Response<Value> {
    case success(Value)
    case failure(AEError)
    case error
    
    var value: Value? {
        switch self {
        case .success(let value):
            return value
        default:
            return nil
        }
    }
    
    static func initResult<T: Codable>(_ response: DataResponse<GeneralResponseType<T>, AFError>) -> Response<T> {
        if let data = response.value?.data {
            return .success(data)
        } else if let error = response.value?.error {
            if response.response?.statusCode ?? 0 == 401 {
                tokenExpiredHandling(error: error)
            }
            return .failure(error)
        } else {
            return .error
        }
    }
    
    static func initArrayResult<T: Codable>(_ response: DataResponse<GeneralResponseArrayType<T>, AFError>) -> Response<[T]> {
        if let data = response.value?.data {
            return .success(data)
        } else if let error = response.value?.error {
            if response.response?.statusCode ?? 0 == 401 {
                tokenExpiredHandling(error: error)
            }
            return .failure(error)
        } else {
            return .error
        }
    }
    
    static func initVoidResult(_ response: DataResponse<GeneralResponseVoidType, AFError>) -> Response<()> {
        if let error = response.value?.error {
            if response.response?.statusCode ?? 0 == 401 {
                tokenExpiredHandling(error: error)
            }
            return .failure(error)
        } else {
            return .success(())
        }
    }
    
    static func tokenExpiredHandling(error: AEError) {
        guard Preference.profile != nil else {
            return
        }
        Preference.resetDefaults()
        let loginController = LoginViewController(nibName: "LoginViewController", bundle: nil)
        loginController.view.tag = 1
        (UIApplication.shared.keyWindow?.rootViewController as? UINavigationController)?.popToRootViewController(animated: true)
        (UIApplication.shared.keyWindow?.rootViewController as? UINavigationController)?.pushViewController(loginController, animated: true)
    }
    
    static func deleteAllFiles() {
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

        do {
            let fileURLs = try FileManager.default.contentsOfDirectory(at: documentsUrl,
                                                                       includingPropertiesForKeys: nil,
                                                                       options: [.skipsHiddenFiles, .skipsSubdirectoryDescendants])
            for fileURL in fileURLs {
                try FileManager.default.removeItem(at: fileURL)
            }
        } catch  { print(error) }
    }
}

class AEError: Codable {
    let code: String
    let message: String
}
