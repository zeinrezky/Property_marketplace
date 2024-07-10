//
//  ForgotPasswordViewController.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 12/03/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import RxCocoa
import RxSwift
import Firebase
import SKCountryPicker
import SVProgressHUD
import UIKit

class ForgotPasswordViewController: MixogyBaseViewController {

    @IBOutlet var countryImageView: UIImageView!
    @IBOutlet var countryLabel: UILabel!
    @IBOutlet var helpLabel: UILabel!
    @IBOutlet var countryView: UIView!
    @IBOutlet var phoneTextfield: UITextField!
    @IBOutlet var placeholderTextfields: [UITextField]!
    @IBOutlet var recordButtons: [UIButton]!
    @IBOutlet var submitButton: UIButton!
    @IBOutlet var cancelButton: UIButton!
    
    var disposeBag = DisposeBag()
    var viewModel = ForgotPasswordViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupBinding()
    }
    
    override func setupLanguage() {
        phoneTextfield.placeholder = "phone-number".localized()
        submitButton.setTitle("send-otp".localized(), for: .normal)
        cancelButton.setTitle("cancel".localized(), for: .normal)
    }
    
    @IBAction func routeToOTP(_ sender: UIButton) {
        viewModel.submit()
    }
    
    @IBAction func dismissSelf() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func countryCodeButtonClicked(_ sender: UIButton) {
        let countryController = CountryPickerWithSectionViewController.presentController(on: self) { (country: Country) in
            self.countryImageView.image = country.flag
            self.countryLabel.text = country.dialingCode
            self.viewModel.countryCode.accept(country.dialingCode)
        }

        // can customize the countryPicker here e.g font and color
        countryController.detailColor = UIColor.red
    }
    
    @IBAction func routeToGetHelp(_ sender: UIButton) {
        let getHelpViewController = GetHelpViewController(nibName: "GetHelpViewController", bundle: nil)
        navigationController?.pushViewController(getHelpViewController, animated: true)
    }
}

// MARK: - Private Extension

fileprivate extension ForgotPasswordViewController {
    
    func setupUI() {
        let colorTop = UIColor(hexString: "#2A2A2A").cgColor
        let colorMiddle = UIColor(hexString: "#585858").cgColor
        let colorBottom = UIColor(hexString: "#808080").cgColor

        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorMiddle ,colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = UIScreen.main.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        if let country = CountryManager.shared.currentCountry {
            countryLabel.text = country.dialingCode
            countryImageView.image = country.flag
            viewModel.countryCode.accept(country.dialingCode)
        }
        
        countryView.layer.cornerRadius = 5
        
        let placeholderColor = UIColor(hexString: "#D2D2D2")
        
        for placeholderTextfield in placeholderTextfields {
            placeholderTextfield.tintColor = .white
            placeholderTextfield.attributedPlaceholder = NSAttributedString(
                string: placeholderTextfield.placeholder ?? "",
                attributes: [NSAttributedString.Key.foregroundColor: placeholderColor]
            )
        }
        
        for recordButton in recordButtons {
            recordButton.layer.cornerRadius = 9
        }
        
        let attributedString = NSMutableAttributedString(string: "Get Help")
        
        attributedString.addAttribute(
            NSAttributedString.Key.underlineStyle,
            value: NSUnderlineStyle.single.rawValue,
            range: NSMakeRange(0, attributedString.length)
        )
        
        helpLabel.attributedText = attributedString
    }
    
    func setupBinding() {
        phoneTextfield
            .rx
            .text
            .bind(to: viewModel.phoneNumber)
            .disposed(by: disposeBag)
        
        viewModel.isInvalid.subscribe(onNext: { isInvalid in
            if isInvalid {
                self.showAlert(message: "Form Tidak Lengkap")
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        
        viewModel.isLoading.subscribe(onNext: { isLoading in
            if isLoading {
                SVProgressHUD.show()
            } else {
                SVProgressHUD.dismiss()
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        
        viewModel.isSuccess.subscribe(onNext: { isSuccess in
            if isSuccess {
                let otpViewController = OTPViewController(nibName: "OTPViewController", bundle: nil)
                otpViewController.viewModel.type = .forgot(self.viewModel.request, self.viewModel.token)
                self.navigationController?.pushViewController(otpViewController, animated: true)
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        
        viewModel.errorMessage.subscribe(onNext: { message in
            if let message = message {
                self.showAlert(message: message)
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
