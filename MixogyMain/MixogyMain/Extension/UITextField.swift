//
//  UITextField.swift
//  MixogyAdmin
//
//  Created by ABDUL AZIS H on 25/01/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import UIKit

class MXTextField: UITextField {

    let padding = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    func enableData() {
        backgroundColor = .white
        isEnabled = true
    }
    
    func disableData() {
        backgroundColor = .lightGray
        isEnabled = false
    }
}

protocol OTPFieldDelegate: class {
    func deleteDidTapped(_ textfield: OTPField, index: Int)
}

class OTPField: UITextField {

    weak var newDelegate: OTPFieldDelegate?
    
    override func deleteBackward() {
        super.deleteBackward()
        
        if self.tag > 0 {
            newDelegate?.deleteDidTapped(self, index: self.tag)
        }
    }
}
