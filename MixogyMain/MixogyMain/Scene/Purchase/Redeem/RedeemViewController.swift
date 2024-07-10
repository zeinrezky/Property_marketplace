//
//  RedeemViewController.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 24/01/21.
//  Copyright © 2021 Mixogy. All rights reserved.
//

import RxCocoa
import RxSwift
import SDWebImage
import SVProgressHUD
import UIKit

class RedeemViewController: UIViewController {

    @IBOutlet var containerView: UIView!
    @IBOutlet var itemPhotoImageView: UIImageView!
    @IBOutlet var itemNameLabel: UILabel!
    @IBOutlet var itemDescriptionLabel: UILabel!
    @IBOutlet var itemCodeLabel: UILabel!
    @IBOutlet var itemValidUntilLabel: UILabel!
    @IBOutlet var itemAreaLabel: UILabel!
    @IBOutlet var redeemButton: UIButton!
    @IBOutlet var deleteButton: UIButton!
    @IBOutlet var itemAreaTopMargin: NSLayoutConstraint!
    
    var viewModel = RedeemViewModel()
    var disposeBag = DisposeBag()
    var shadowLayer = CAShapeLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupBinding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.isHidden = false
        
        viewModel.fetchData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.isNavigationBarHidden = true
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setupLayer()
    }
    
    @IBAction func submit() {
        viewModel.submit()
    }
}

// MARK: - Private Extension

fileprivate extension RedeemViewController {
    
    func setupUI() {
        title = "Ready To Redeem"
    }
    
    func setupLayer() {
        var bounds = containerView.bounds
        bounds.size.width = UIScreen.main.bounds.size.width - 40
        shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: 9).cgPath
        shadowLayer.fillColor = UIColor.white.cgColor
        shadowLayer.shadowColor = UIColor.black.cgColor
        shadowLayer.shadowPath = shadowLayer.path
        shadowLayer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        shadowLayer.shadowOpacity = 0.2
        shadowLayer.shadowRadius = 3
        containerView.layer.insertSublayer(shadowLayer, at: 0)
    }
    
    func setupBinding() {
        viewModel.data.subscribe(onNext: { data in
            if let value = data {
                self.itemCodeLabel.text = value.customerItem.code
                self.itemNameLabel.text = value.customerItem.name
                self.itemDescriptionLabel.text = value.customerItem.description
                self.itemAreaLabel.text = "This item only available to use in " + value.customerItem.location
                self.itemValidUntilLabel.text = "Valid until " + value.customerItem.date
                self.itemPhotoImageView.sd_setImage(
                    with: URL(string: value.customerItem.itemImage),
                    placeholderImage: nil,
                    options: .refreshCached,
                    completed: nil
                )
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        
        viewModel.isLoading.subscribe(onNext: { isLoading in
            if isLoading {
                SVProgressHUD.show()
            } else {
                SVProgressHUD.dismiss()
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        
        viewModel.isRedeemed.subscribe(onNext: { isRedeemed in
            if isRedeemed {
                if self.view.tag == 0 {
                    let alertController = UIAlertController(title: "informaton".localized(), message: "data-saved".localized(), preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default)
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                }
                self.itemValidUntilLabel.isHidden = true
                self.itemAreaLabel.isHidden = true
                self.title = "Redeemed"
                self.redeemButton.backgroundColor = UIColor(hexString: "#898989")
                self.redeemButton.setTitle("REDEEMED", for: .normal)
                self.itemAreaTopMargin.constant = -100
                self.shadowLayer.removeFromSuperlayer()
                self.redeemButton.isUserInteractionEnabled = false
                self.setupLayer()
            } else {
                self.itemValidUntilLabel.isHidden = false
                self.itemAreaLabel.isHidden = false
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        
        viewModel.errorMessage.subscribe(onNext: { message in
            if let message = message {
                let alertController = UIAlertController(title: "informaton".localized(), message: message, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
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
    }
}
