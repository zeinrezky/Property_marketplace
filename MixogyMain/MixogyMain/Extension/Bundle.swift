//
//  Bundle.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 26/10/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import Foundation

extension Bundle {
    private static var bundle: Bundle!

    public static func localizedBundle() -> Bundle! {
        if bundle == nil {
            let appLang = Preference.language ?? "en"
            let path = Bundle.main.path(forResource: appLang, ofType: "lproj")
            bundle = Bundle(path: path!)
        }

        return bundle;
    }

    public static func setLanguage(lang: String) {
        Preference.language = lang
        let path = Bundle.main.path(forResource: lang, ofType: "lproj")
        bundle = Bundle(path: path!)
    }
}
