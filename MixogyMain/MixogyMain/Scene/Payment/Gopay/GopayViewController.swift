//
//  GopayViewController.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 04/04/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import RxCocoa
import RxSwift
import SVProgressHUD
import SDWebImage
import UIKit

class GopayViewController: MixogyBaseViewController {

    @IBOutlet var amountLabel: UILabel!
    @IBOutlet var qrImageView: UIImageView!
    @IBOutlet var seeItemLabel: UILabel!
    @IBOutlet var gopayButton: UIButton!
    @IBOutlet var changePaymentButton: UIButton!
    var disposeBag = DisposeBag()
    
    var viewModel = GopayViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        changePaymentButton.layer.cornerRadius = 4
        changePaymentButton.layer.borderColor = UIColor.greenApp.cgColor
        changePaymentButton.layer.borderWidth = 1.0
        changePaymentButton.clipsToBounds = true
        setupBinding()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        amountLabel.text = viewModel.amount.currencyFormat
        qrImageView.sd_setImage(
            with: URL(string: viewModel.qrURL),
            placeholderImage: UIImage(named: "ic_parent_profile"),
            options: .refreshCached,
            completed: nil
        )
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
        gopayButton.setTitle("open-gopay".localized(), for: .normal)
    }
    
    @IBAction func openGopay(_ sender: UIButton) {
        if let url = URL(string: viewModel.gopayURL),
            UIApplication.shared.canOpenURL(url) {
            let controller = GopayBrowserViewController(
                nibName: "GopayBrowserViewController",
                bundle: nil
            )
            controller.viewModel.url = url
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    @IBAction func showDetails(_ sender: UIButton) {
        let itemDetailViewController = ItemDetailsViewController(nibName: "ItemDetailsViewController", bundle: nil)
        itemDetailViewController.viewModel.id = viewModel.id
        self.navigationController?.pushViewController(itemDetailViewController, animated: true)
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        viewModel.cancelPayment()
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
