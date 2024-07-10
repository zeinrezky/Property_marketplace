//
//  OTPViewController.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 05/03/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import Firebase
import RxCocoa
import RxSwift
import SVProgressHUD
import UIKit

class OTPViewController: MixogyBaseViewController {

    @IBOutlet var phoneLabel: UILabel!
    @IBOutlet var weSendLabel: UILabel!
    @IBOutlet var inputOTPLabel: UILabel!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var forgotButton: UIButton!
    @IBOutlet var widthConstraint: [NSLayoutConstraint]!
    @IBOutlet var otpViews: [UIView]!
    @IBOutlet var otpTextFields: [OTPField]!
    
    var disposeBag = DisposeBag()
    var viewModel = OTPViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupBinding()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if view.tag == 0 {
            view.tag = 1
            viewModel.sendOTPSMS()
        }
    }
    
    override func setupLanguage() {
        weSendLabel.text = "we-have-send-code".localized()
        inputOTPLabel.text = "input-otp".localized()
        
        forgotButton.setTitle("resend-otp".localized(), for: .normal)
        cancelButton.setTitle("cancel".localized(), for: .normal)
    }
    
    @IBAction func resend(_ sender: UIButton) {
        viewModel.sendOTPSMS()
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    func routeToConfirmPassword() {
        let registerConfirmViewController = RegisterConfirmViewController(nibName: "RegisterConfirmViewController", bundle: nil)
        
        switch viewModel.type {
        case .register(let request):
            registerConfirmViewController.viewModel.type = .register(request)
            
        case .forgot(let request, let token):
            registerConfirmViewController.viewModel.type = .forgot(request, token)
        }
        
        navigationController?.pushViewController(registerConfirmViewController, animated: true)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if (textField.text ?? "").count > 0 && textField.tag < 5 {
            self.otpTextFields[textField.tag + 1].becomeFirstResponder()
        }
    }
}

// MARK: - Private Extension

extension OTPViewController {
    
    func setupUI() {
        otpTextFields[0].becomeFirstResponder()
        
        let width = (UIScreen.main.bounds.size.width - 110) / 6
        
        for widthConstraint in widthConstraint {
            widthConstraint.constant = width
        }
        
        for view in otpViews {
            view.layer.cornerRadius = 6
            view.layer.borderColor = UIColor(hexString: "#4DD2A7").cgColor
            view.layer.borderWidth = 1
            view.clipsToBounds = true
        }
        
        for i in 0..<otpTextFields.count {
            otpTextFields[i].newDelegate = self
            otpTextFields[i].delegate = self
            otpTextFields[i].tag = i
            otpTextFields[i].addTarget(
                self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
            otpTextFields[i].rx.text.subscribe(onNext: { value in
                if let value = value {
                    if i == self.otpTextFields.count - 1 && !value.isEmpty {
                        var text = ""
                        
                        for i in 0..<self.otpTextFields.count {
                            text += self.otpTextFields[i].text ?? ""
                        }
                        
                        self.viewModel.verifyOTP(code: text)
                        
                        for i in 0..<self.otpTextFields.count {
                            self.otpTextFields[i].text = ""
                        }
                        
                        self.view.endEditing(true)
                    }
                }
            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        }
        
        let attributedString = NSMutableAttributedString(string: "Resend OTP Number")
        
        attributedString.addAttribute(
            NSAttributedString.Key.underlineColor,
            value: UIColor(hexString: "#4DD2A7"),
            range: NSMakeRange(0, attributedString.length)
        )
        
        attributedString.addAttribute(
            NSAttributedString.Key.underlineStyle,
            value: NSUnderlineStyle.single.rawValue,
            range: NSMakeRange(0, attributedString.length)
        )
        
        self.forgotButton.titleLabel?.attributedText = attributedString
    }
    
    func setupBinding() {
        viewModel
            .phoneNumber
            .bind(to: phoneLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.isSuccess.subscribe(onNext: { isSuccess in
            if isSuccess {
                self.routeToConfirmPassword()
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        
        viewModel.errorMessage.subscribe(onNext: { message in
            if let message = message {
                self.showAlert(message: message)
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        
        viewModel.isLoading.subscribe(onNext: { isLoading in
            if isLoading {
                SVProgressHUD.show()
            } else {
                SVProgressHUD.dismiss()
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
    }
    
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "informaton".localized(), message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

extension OTPViewController: OTPFieldDelegate {
    
    func deleteDidTapped(_ textfield: OTPField, index: Int) {
        otpTextFields[index - 1].text = ""
        otpTextFields[index - 1].becomeFirstResponder()
    }
}

extension OTPViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
}
