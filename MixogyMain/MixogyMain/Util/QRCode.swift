//
//  QRCode.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 03/04/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import UIKit

class QRCode {

    static func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)

        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)

            if let output = filter.outputImage?.transformed(by: transform) {
                let colorParameters = [
                    "inputColor0": CIColor(color: UIColor.black), // Foreground
                    "inputColor1": CIColor(color: UIColor.clear) // Background
                ]
                
                let colored = output.applyingFilter("CIFalseColor", parameters: colorParameters)
                return UIImage(ciImage: colored)
            }
        }

        return nil
    }
}
