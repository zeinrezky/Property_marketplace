//
//  JSONCodable.swift
//  Mixogy
//
//  Created by ABDUL AZIS H on 14/12/19.
//  Copyright © 2019 Mixogy. All rights reserved.
//

import Foundation

class JSONCodable {
    
    static func encodedData<T: Codable>(value: T) -> Data? {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(value) {
            return encoded
        }
        return nil
    }
    
    static func decodedData<T: Codable>(value: Data) -> T? {
        let decoder = JSONDecoder()
        if let decoded = try? decoder.decode(T.self, from: value) {
            return decoded
        }
        return nil
    }
}
