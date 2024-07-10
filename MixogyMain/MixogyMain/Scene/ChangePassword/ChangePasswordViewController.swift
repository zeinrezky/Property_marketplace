//
//  ChangePasswordViewController.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 17/04/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import RxCocoa
import RxSwift
import SVProgressHUD
import UIKit

class ChangePasswordViewController: MixogyBaseViewController {

    @IBOutlet var oldPasswordTextfield: UITextField!
    @IBOutlet var confirmOldPasswordTextfield: UITextField!
    @IBOutlet var newPasswordTextfield: UITextField!
    @IBOutlet var confirmNewPasswordTextfield: UITextField!
    @IBOutlet var oldPasswordLabel: UILabel!
    @IBOutlet var confirmOldPasswordLabel: UILabel!
    @IBOutlet var newPasswordLabel: UILabel!
    @IBOutlet var confirmNewPasswordLabel: UILabel!
    @IBOutlet var placeholderTextfields: [UITextField]!
    @IBOutlet var recordButtons: [UIButton]!
    
    var disposeBag = DisposeBag()
    var viewModel = ChangePasswordViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupBinding()
    }
    
    override func setupLanguage() {
        oldPasswordLabel.text = "old-password".localized()
        oldPasswordTextfield.placeholder = "old-password".localized()
        confirmOldPasswordLabel.text = "confirm-old-password".localized()
        confirmOldPasswordTextfield.placeholder = "confirm-old-password".localized()
        newPasswordLabel.text = "new-password".localized()
        newPasswordTextfield.placeholder = "new-password".localized()
        confirmNewPasswordLabel.text = "confirm-new-password".localized()
        confirmNewPasswordTextfield.placeholder = "confirm-new-password".localized()
        recordButtons[0].setTitle("confirm".localized(), for: .normal)
        recordButtons[1].setTitle("cancel".localized(), for: .normal)
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
       
    @IBAction func submit(_ sender: UIButton) {
        viewModel.submit()
    }
}

// MARK: - Private Extension

fileprivate extension ChangePasswordViewController {
    
    func setupUI() {
        let colorTop = UIColor(hexString: "#2A2A2A").cgColor
        let colorMiddle = UIColor(hexString: "#585858").cgColor
        let colorBottom = UIColor(hexString: "#808080").cgColor

        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorMiddle ,colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = UIScreen.main.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
        
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
    }
    
    func setupBinding() {
        oldPasswordTextfield
            .rx
            .text
            .bind(to: viewModel.oldPassword)
            .disposed(by: disposeBag)
        
        confirmOldPasswordTextfield
            .rx
            .text
            .bind(to: viewModel.confirmOldPassword)
            .disposed(by: disposeBag)
        
        newPasswordTextfield
            .rx
            .text
            .bind(to: viewModel.newPassword)
            .disposed(by: disposeBag)
        
        confirmNewPasswordTextfield
            .rx
            .text
            .bind(to: viewModel.confirmNewPassword)
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
                let alertController = UIAlertController(title: "informaton".localized(), message: "data-saved".localized(), preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                    self.navigationController?.popViewController(animated: true)
                }
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
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
    }
    
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "informaton".localized(), message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
