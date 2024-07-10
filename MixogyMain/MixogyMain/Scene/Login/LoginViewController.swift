//
//  LoginViewController.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 04/03/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import RxCocoa
import RxSwift
import Firebase
import SKCountryPicker
import SVProgressHUD
import UIKit

enum LoginViewControllerFrom {
    case home
    case cart
}

class LoginViewController: MixogyBaseViewController {

    @IBOutlet var countryImageView: UIImageView!
    @IBOutlet var countryLabel: UILabel!
    @IBOutlet var takeMeBackLabel: UILabel!
    @IBOutlet var youNotLoginLabel: UILabel!
    @IBOutlet var dontHaveAccountLabel: UILabel!
    @IBOutlet var forgotLabel: UILabel!
    @IBOutlet var countryView: UIView!
    @IBOutlet var phoneTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    @IBOutlet var placeholderTextfields: [UITextField]!
    @IBOutlet var recordButtons: [UIButton]!
    @IBOutlet var submitButton: UIButton!
    @IBOutlet var languageButton: UIButton!
    
    var from: LoginViewControllerFrom = .home
    
    var disposeBag = DisposeBag()
    var viewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupBinding()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if view.tag == 1 {
            navigationController?.popToRootViewController(animated: false)
        }
    }
    
    override func setupLanguage() {
        takeMeBackLabel.text = "take-me-back".localized()
        youNotLoginLabel.text = "you-not-logged-in".localized()
        dontHaveAccountLabel.text = "dont-have-account?".localized()
        
        let attributedString = NSMutableAttributedString(string: "i-forgot-my-password".localized())
        
        attributedString.addAttribute(
            NSAttributedString.Key.underlineStyle,
            value: NSUnderlineStyle.single.rawValue,
            range: NSMakeRange(0, attributedString.length)
        )
        
        forgotLabel.attributedText = attributedString
        
        languageButton.setTitle("profile-lang".localized(), for: .normal)
        recordButtons[0].setTitle("login".localized(), for: .normal)
        recordButtons[1].setTitle("register".localized(), for: .normal)
        phoneTextfield.placeholder = "phone-number".localized()
        passwordTextfield.placeholder = "password".localized()
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
    
    @IBAction func routeToRegister(_ sender: UIButton) {
        let registerViewController = RegisterViewController(nibName: "RegisterViewController", bundle: nil)
        navigationController?.pushViewController(registerViewController, animated: true)
    }
    
    @IBAction func dismissSelf(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func routeToForgorPassword(_ sender: UIButton) {
        let forgotPasswordViewController = ForgotPasswordViewController(nibName: "ForgotPasswordViewController", bundle: nil)
        navigationController?.pushViewController(forgotPasswordViewController, animated: true)
    }
    
    @IBAction func changeLanguage(_ sender: UIButton) {
        Preference.language = Preference.language ?? "en" == "en" ? "id-ID" : "en"
        Bundle.setLanguage(lang: Preference.language ?? "en")
        NotificationCenter.default.post(
            name: Notification.Name(Constants.ChangeLanguageKey),
            object: nil,
            userInfo: nil
        )
    }
}

// MARK: - Private Extension

fileprivate extension LoginViewController {
    
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
            self.viewModel.countryCode.accept(country.dialingCode)
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
        
        let attributedString = NSMutableAttributedString(string: "i-forgot-my-password".localized())
        
        attributedString.addAttribute(
            NSAttributedString.Key.underlineStyle,
            value: NSUnderlineStyle.single.rawValue,
            range: NSMakeRange(0, attributedString.length)
        )
        
        forgotLabel.attributedText = attributedString
    }
    
    func setupBinding() {
        phoneTextfield
            .rx
            .text
            .bind(to: viewModel.phone)
            .disposed(by: disposeBag)
        
        passwordTextfield
            .rx
            .text
            .bind(to: viewModel.password)
            .disposed(by: disposeBag)
        
        viewModel.isLoading.subscribe(onNext: { isLoading in
            if isLoading {
                SVProgressHUD.show()
            } else {
                SVProgressHUD.dismiss()
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        
        viewModel.isSuccess.subscribe(onNext: { isSuccess in
            if isSuccess {
                self.navigationController?.popToRootViewController(animated: true)
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        
        viewModel.errorMessage.subscribe(onNext: { message in
            if let message = message {
                self.showAlert(message: message)
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        
        viewModel.isInvalid.subscribe(onNext: { isInvalid in
            if isInvalid {
                self.showAlert(message: "Form Tidak Lengkap")
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        
        submitButton.rx.tap.subscribe(onNext: {
            self.viewModel.loginUser()
            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
    }
    
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "informaton".localized(), message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
