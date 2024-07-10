//
//  PaymentCreatedViewController.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 29/03/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import RxCocoa
import RxSwift
import SVProgressHUD
import UIKit

class PaymentCreatedViewController: MixogyBaseViewController {

    @IBOutlet var vaNumberlabel: UILabel!
    @IBOutlet var amountLabel: UILabel!
    @IBOutlet var detailLabel: UILabel!
    @IBOutlet var seeItemLabel: UILabel!
    @IBOutlet var changePaymentButton: UIButton!
    
    var viewModel = PaymentCreatedViewModel()
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupBinding()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        vaNumberlabel.text = viewModel.vaNumber
        amountLabel.text = viewModel.amount.currencyFormat
        detailLabel.text = viewModel.detail
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.isNavigationBarHidden = true
        navigationController?.navigationBar.isHidden = true
        
        if isMovingFromParent {
            navigationController?.popToRootViewController(animated: true)
        }
    }
    
    override func setupLanguage() {
        seeItemLabel.text = "see-item-details".localized()
    }
    
    @IBAction func showDetails(_ sender: UIButton) {
        let itemDetailViewController = ItemDetailsViewController(nibName: "ItemDetailsViewController", bundle: nil)
        itemDetailViewController.viewModel.id = viewModel.id
        self.navigationController?.pushViewController(itemDetailViewController, animated: true)
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        viewModel.cancelPayment()
    }
}

// MARK: - Private Extension

fileprivate extension PaymentCreatedViewController {
    
    func setupUI() {
        title = "Payment"
        
        changePaymentButton.layer.cornerRadius = 4
        changePaymentButton.layer.borderColor = UIColor.greenApp.cgColor
        changePaymentButton.layer.borderWidth = 1.0
        changePaymentButton.clipsToBounds = true
    }
    
    func setupBinding() {
        viewModel.isLoading.subscribe(onNext: { isLoading in
            if isLoading {
                SVProgressHUD.show()
            } else {
                SVProgressHUD.dismiss()
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        
        viewModel.errorMessage.subscribe(onNext: { message in
            if let message = message {
                self.showAlert(message: message)
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        
        viewModel.isSuccessCancel.subscribe(onNext: { isSuccess in
            if isSuccess {
                let alertController = UIAlertController(title: "informaton".localized(), message: "data-saved".localized(), preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                    (((UIApplication.shared.keyWindow?.rootViewController as! UINavigationController).viewControllers.first as! UITabBarController)).selectedIndex = 2
                    self.navigationController?.popToRootViewController(animated: true)
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
