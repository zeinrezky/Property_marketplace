//
//  Preference.swift
//  Mixogy
//
//  Created by ABDUL AZIS H on 14/12/19.
//  Copyright © 2019 Mixogy. All rights reserved.
//

import UIKit

struct Preference {
    static let AuthKey = "auth"
    static let ProfileKey = "profile"
    static let QuestionKey = "question"
    static let AnswerKey = "Answer"
    static let CartCountKey = "CartCount"
    static let CartKey = "Cart"
    static let OTPKey = "OTPKey"
    static let LanguageKey = "LanguageKey"
    static let DeviceTokenKey = "DeviceToken"
    static let InboxKey = "InboxKey"
    static let BuyGuideOpened = "BuyGuideOpened"
    static let SellGuideOpened = "SellGuideOpened"
    
    static var auth: LoginResponse? {
        get {
            guard let data = UserDefaults.standard.data(forKey: AuthKey) else {
                return nil
            }
            
            guard let value: LoginResponse = JSONCodable.decodedData(value: data) else {
                return nil
            }
            
            return value
        }
        set {
            if let value = newValue, let data = JSONCodable.encodedData(value: value) {
                UserDefaults.standard.set(data, forKey: AuthKey)
            } else {
                UserDefaults.standard.removeObject(forKey: AuthKey)
            }
        }
    }
    
    static var profile: ProfileResponse? {
        get {
            guard let data = UserDefaults.standard.data(forKey: ProfileKey) else {
                return nil
            }
            
            guard let value: ProfileResponse = JSONCodable.decodedData(value: data) else {
                return nil
            }
            
            return value
        }
        set {
            if let value = newValue, let data = JSONCodable.encodedData(value: value) {
                UserDefaults.standard.set(data, forKey: ProfileKey)
            } else {
                UserDefaults.standard.removeObject(forKey: ProfileKey)
            }
        }
    }
    
    static var cart: CartResponse? {
        get {
            guard let data = UserDefaults.standard.data(forKey: CartKey) else {
                return nil
            }
            
            guard let value: CartResponse = JSONCodable.decodedData(value: data) else {
                return nil
            }
            
            return value
        }
        set {
            if let value = newValue, let data = JSONCodable.encodedData(value: value) {
                UserDefaults.standard.set(data, forKey: CartKey)
            } else {
                UserDefaults.standard.removeObject(forKey: CartKey)
            }
        }
    }
    
    static var cartCount: Int? {
        get {
            return UserDefaults.standard.integer(forKey: CartCountKey)
        }
        set {
            if let value = newValue {
                UserDefaults.standard.set(value, forKey: CartCountKey)
            } else {
                UserDefaults.standard.removeObject(forKey: CartCountKey)
            }
        }
    }
    
    static var inboxCount: Int? {
        get {
            return UserDefaults.standard.integer(forKey: InboxKey)
        }
        set {
            if let value = newValue {
                UserDefaults.standard.set(value, forKey: InboxKey)
            } else {
                UserDefaults.standard.removeObject(forKey: InboxKey)
            }
        }
    }
    
    static var otpKey: String? {
        get {
            return UserDefaults.standard.string(forKey: OTPKey)
        }
        set {
            if let value = newValue {
                UserDefaults.standard.set(value, forKey: OTPKey)
            } else {
                UserDefaults.standard.removeObject(forKey: OTPKey)
            }
        }
    }
    
    static var language: String? {
        get {
            return UserDefaults.standard.string(forKey: LanguageKey)
        }
        set {
            if let value = newValue {
                UserDefaults.standard.set(value, forKey: LanguageKey)
            } else {
                UserDefaults.standard.removeObject(forKey: LanguageKey)
            }
        }
    }
    
    static var buyGuideOpened: Bool? {
        get {
            return UserDefaults.standard.bool(forKey: BuyGuideOpened)
        }
        set {
            if let value = newValue {
                UserDefaults.standard.set(value, forKey: BuyGuideOpened)
            } else {
                UserDefaults.standard.removeObject(forKey: BuyGuideOpened)
            }
        }
    }
    
    static var sellGuideOpened: Bool? {
        get {
            return UserDefaults.standard.bool(forKey: SellGuideOpened)
        }
        set {
            if let value = newValue {
                UserDefaults.standard.set(value, forKey: SellGuideOpened)
            } else {
                UserDefaults.standard.removeObject(forKey: SellGuideOpened)
            }
        }
    }
    
    static var deviceToken: String? {
        get {
            guard let value = UserDefaults.standard.string(forKey: DeviceTokenKey) else {
                return nil
            }
            
            return value
        }
        set {
            if let value = newValue {
                UserDefaults.standard.set(value, forKey: DeviceTokenKey)
            } else {
                UserDefaults.standard.removeObject(forKey: DeviceTokenKey)
            }
        }
    }
    
    static func resetDefaults() {
        let token = Preference.deviceToken
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
        Preference.deviceToken = token
    }
}
