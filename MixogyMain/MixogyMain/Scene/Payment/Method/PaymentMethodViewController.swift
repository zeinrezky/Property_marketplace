//
//  PaymentMethodViewController.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 29/03/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import RxCocoa
import RxSwift
import SVProgressHUD
import UIKit

class PaymentMethodViewController: MixogyBaseViewController {

    @IBOutlet var bankViews: [UIView]!
    @IBOutlet var amountLabel: UILabel!
    @IBOutlet var methodLabel: UILabel!
    @IBOutlet var internalPaymentContainer: UIView!
    
    var disposeBag = DisposeBag()
    var viewModel = PaymentMethodViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupBinding()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        amountLabel.text = (viewModel.amount ?? 0).currencyFormat
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        for bankView in bankViews {
            let bounds = CGRect(
                x: bankView.bounds.origin.x,
                y: bankView.bounds.origin.y,
                width: UIScreen.main.bounds.width - 40,
                height: bankView.bounds.size.height)
            
            let shadowLayer = CAShapeLayer()
            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: 12).cgPath
            shadowLayer.fillColor = UIColor.white.cgColor
            shadowLayer.shadowColor = UIColor.black.cgColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = CGSize(width: 0.0, height: 3.0)
            shadowLayer.shadowOpacity = 0.2
            shadowLayer.shadowRadius = 3
            bankView.layer.insertSublayer(shadowLayer, at: 0)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.isHidden = false
        
        viewModel.detail()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.isNavigationBarHidden = true
        navigationController?.navigationBar.isHidden = true
        
        if isMovingToParent {
            navigationController?.popToRootViewController(animated: true)
        }
    }
    
    override func setupLanguage() {
        methodLabel.text = "method".localized()
    }
    
    @IBAction func submitBankTransfer(_ sender: UIButton) {
        viewModel.vendor = "midtrans"
        viewModel.paymentMethod = "bank_transfer"
        viewModel.type = .bank
        viewModel.submit()
    }
    
    @IBAction func submitGopayTransfer(_ sender: UIButton) {
        viewModel.vendor = "midtrans"
        viewModel.paymentMethod = "gopay"
        viewModel.type = .gopay
        viewModel.submit()
    }
    
    @IBAction func submitOvoTransfer(_ sender: UIButton) {
        viewModel.vendor = "ovo"
        viewModel.paymentMethod = "ovo"
        viewModel.type = .ovo
        viewModel.submit()
    }
    
    @IBAction func submitInternalTransfer(_ sender: UIButton) {
        viewModel.vendor = "internal"
        viewModel.paymentMethod = "internal"
        viewModel.type = .internals
        viewModel.submit()
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        viewModel.cancelPayment()
    }
}

// MARK: - Private Extension

fileprivate extension PaymentMethodViewController {
    
    func setupUI() {
        title = "payment".localized()
    }
    
    func setupBinding() {
        viewModel.isLoading.subscribe(onNext: { isLoading in
            if isLoading {
                SVProgressHUD.show()
            } else {
                SVProgressHUD.dismiss()
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        
        viewModel.isInternalVisible.subscribe(onNext: { isInternalVisible in
            self.internalPaymentContainer.isHidden = !isInternalVisible
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        
        viewModel.errorMessage.subscribe(onNext: { message in
            if let message = message {
                self.showAlert(message: message)
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        
        viewModel.isSuccess.subscribe(onNext: { isSuccess in
            if isSuccess {
                let alertController = UIAlertController(title: "informaton".localized(), message: "data-saved".localized(), preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                    switch self.viewModel.type {
                    case .bank:
                        let paymentCreatedViewController = PaymentCreatedViewController(nibName: "PaymentCreatedViewController", bundle: nil)
                        paymentCreatedViewController.viewModel.amount = self.viewModel.amount ?? 0
                        paymentCreatedViewController.viewModel.vaNumber = self.viewModel.vaNumber ?? ""
                        paymentCreatedViewController.viewModel.detail = self.viewModel.bank ?? ""
                        paymentCreatedViewController.viewModel.transactionCode = self.viewModel.orderid
                        self.navigationController?.pushViewController(paymentCreatedViewController, animated: true)
                        
                    case .gopay:
                        let gopayViewController = GopayViewController(nibName: "GopayViewController", bundle: nil)
                        gopayViewController.viewModel.amount = self.viewModel.amount ?? 0
                        gopayViewController.viewModel.gopayURL = self.viewModel.gopayURL ?? ""
                        gopayViewController.viewModel.qrURL = self.viewModel.qrURL ?? ""
                        gopayViewController.viewModel.transactionCode = self.viewModel.orderid
                        self.navigationController?.pushViewController(gopayViewController, animated: true)
                        
                    case .ovo:
                        let ovoViewController = OvoViewController(nibName: "OvoViewController", bundle: nil)
                        ovoViewController.viewModel.amount = self.viewModel.amount ?? 0
                        ovoViewController.viewModel.number = self.viewModel.phone ?? ""
                        ovoViewController.viewModel.transactionCode = self.viewModel.orderid
                        self.navigationController?.pushViewController(ovoViewController, animated: true)
                        
                    case .internals:
                        self.navigationController?.popToRootViewController(animated: true)
                        
                    }
                }
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        
        viewModel.isSuccessCancel.subscribe(onNext: { isSuccess in
            if isSuccess {
                let alertController = UIAlertController(title: "informaton".localized(), message: "data-saved".localized(), preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                    (((UIApplication.shared.keyWindow?.rootViewController as! UINavigationController).viewControllers.first as! UITabBarController)).selectedIndex = 2
                    self.navigationController?.popViewController(animated: true)
                }
                
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
    }
    
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "informaton".localized(), message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
