//
//  RegisterConfirmViewController.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 05/03/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import RxCocoa
import RxSwift
import SVProgressHUD
import UIKit

class RegisterConfirmViewController: MixogyBaseViewController {

    @IBOutlet var passwordTextfield: UITextField!
    @IBOutlet var confirmPasswordTextfield: UITextField!
    @IBOutlet var placeholderTextfields: [UITextField]!
    @IBOutlet var submitButton: UIButton!
    @IBOutlet var cancelButton: UIButton!
    
    var disposeBag = DisposeBag()
    var viewModel = RegisterConfirmViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupBinding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        switch viewModel.type {
        case .register:
            submitButton.setTitle("register".localized(), for: .normal)
            
        case .forgot:
            submitButton.setTitle("confirm".localized(), for: .normal)
        }
    }
    
    override func setupLanguage() {
        passwordTextfield.placeholder = "password".localized()
        confirmPasswordTextfield.placeholder = "confirm-password".localized()
        cancelButton.setTitle("cancel".localized(), for: .normal)
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    func routeToSuccess() {
        let tutorialViewController = TutorialViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal,
            options: nil
        )
        tutorialViewController.viewModel.mode.accept(.sell)
        tutorialViewController.modalPresentationStyle = .fullScreen
        tutorialViewController.view.tag = 1
        tutorialViewController.pageDelegate = self
        self.present(tutorialViewController, animated: true)
    }
}

// MARK: - Private Extension

fileprivate extension RegisterConfirmViewController {
    
    func setupUI() {
        let placeholderColor = UIColor(hexString: "#D2D2D2")
        
        for placeholderTextfield in placeholderTextfields {
            placeholderTextfield.tintColor = .white
            placeholderTextfield.attributedPlaceholder = NSAttributedString(
                string: placeholderTextfield.placeholder ?? "",
                attributes: [NSAttributedString.Key.foregroundColor: placeholderColor]
            )
        }
    }
    
    func setupBinding() {
        passwordTextfield
            .rx
            .text
            .bind(to: viewModel.password)
            .disposed(by: disposeBag)
        
        confirmPasswordTextfield
            .rx
            .text
            .bind(to: viewModel.confirmPassword)
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
                let title: String
                switch self.viewModel.type {
                case .register:
                    title = "Register Success"
                    
                case .forgot:
                    title = "Change Password Success"
                }
                let alertController = UIAlertController(title: "informaton".localized(), message: title, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                    if let login = self.navigationController?.viewControllers.first(where: { $0 is LoginViewController }) {
                        self.routeToSuccess()
                    } else {
                        self.navigationController?.popToRootViewController(animated: true)
                    }
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
//
//        viewModel.isSuccess.subscribe(onNext: { isSuccess in
//            if isSuccess {
//                if let login = self.navigationController?.viewControllers.first(where: { $0 is LoginViewController }) {
//
//                } else {
//                    self.navigationController?.popToRootViewController(animated: true)
//                }
//            }
//        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        
        submitButton.rx.tap.subscribe(onNext: {
            self.viewModel.submit()
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
    }
    
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "informaton".localized(), message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

// MARK: - TutorialViewControllerDelegate

extension RegisterConfirmViewController: TutorialViewControllerDelegate {
    
    func tutorialViewController(didExit tutorialViewController: TutorialViewController) {
        if let login = self.navigationController?.viewControllers.first(where: { $0 is LoginViewController }) {
            self.navigationController?.popToViewController(login, animated: true)
        } else {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
}
