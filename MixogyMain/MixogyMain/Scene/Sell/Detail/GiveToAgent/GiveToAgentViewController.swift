//
//  GiveToAgentViewController.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 05/04/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import Agrume
import RxCocoa
import RxSwift
import SDWebImage
import SVProgressHUD
import UIKit

class GiveToAgentViewController: MixogyBaseViewController {

    @IBOutlet var qrImageView: UIImageView!
    @IBOutlet var itemCodeLabel: UILabel!
    @IBOutlet var itemCodeTitleLabel: UILabel!
    @IBOutlet var itemNameLabel: [UILabel]!
    @IBOutlet var itemNameTitleLabel: UILabel!
    @IBOutlet var itemDescriptionLabel: UILabel!
    @IBOutlet var itemDescriptionTitleLabel: UILabel!
    @IBOutlet var itemSeatLabel: UILabel!
    @IBOutlet var itemSeatTitleLabel: UILabel!
    @IBOutlet var itemTypeLabel: UILabel!
    @IBOutlet var itemTypeTitleLabel: UILabel!
    @IBOutlet var itemDateLabel: UILabel!
    @IBOutlet var itemDateTitleLabel: UILabel!
    @IBOutlet var itemLocationLabel: UILabel!
    @IBOutlet var itemLocationTitleLabel: UILabel!
    @IBOutlet var categoryLabel: [UILabel]!
    @IBOutlet var categoryTitleLabel: UILabel!
    @IBOutlet var showQRLabel: UILabel!
    @IBOutlet var itemMainPhoto: [UIImageView]!
    @IBOutlet var itemPhotoTitleLabel: UILabel!
    @IBOutlet var galleryContainerView: UIView!
    @IBOutlet var ourAgentView: UIView!
    @IBOutlet var nameContainerView: UIView!
    @IBOutlet var cancelListingButton: UIButton!
    
    var disposeBag = DisposeBag()
    var viewModel = GiveToAgentViewModel()
    var shadowLayer: CAShapeLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupBinding()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.receivedNotification),
            name: Notification.Name(Constants.ItemTypeKey),
            object: nil
        )
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel.fetchData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setupLayer()
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
    }
    
    override func setupLanguage() {
        title = "give-to-agent".localized()
        showQRLabel.text = "qr-to-agent".localized()
        cancelListingButton.setTitle("cancel-listing".localized(), for: .normal)
        
        itemCodeTitleLabel.text = "item-code".localized()
        itemNameTitleLabel.text = "item-name".localized()
        itemTypeTitleLabel.text = "item-type".localized()
        itemSeatTitleLabel.text = "seat".localized()
        
        itemDateTitleLabel.text = "date".localized()
        itemLocationTitleLabel.text = "location".localized()
        categoryTitleLabel.text = "category".localized()
        itemDescriptionTitleLabel.text = "item-description".localized()
        itemPhotoTitleLabel.text = "item-photos".localized()
    }
    
    @objc func receivedNotification(notification: Notification) {
        let type = notification.userInfo!["type"] as? String ?? ""
        
        if !type.isEmpty {
            switch type {
            case "take_item_from_seller":
                self.routeeToRateAgent()
                
            default:
                break
            }
        }
    }
        
    @IBAction func showPhoto(_ sender: UIButton) {
        guard let value = viewModel.data.value?.customerItem.itemPhotos else {
            return
        }
        
        let requestPhotoGalleryViewController = RequestPhotoGalleryViewController(nibName: "RequestPhotoGalleryViewController", bundle: nil)
        requestPhotoGalleryViewController.view.frame.size.width = view.frame.size.width
        requestPhotoGalleryViewController.height = (self.view.frame.size.height / 2) + 87
        requestPhotoGalleryViewController.topCornerRadius = 12
        requestPhotoGalleryViewController.shouldDismissInteractivelty = false
        requestPhotoGalleryViewController.presentDuration = 0.2
        requestPhotoGalleryViewController.dismissDuration = 0.2
        requestPhotoGalleryViewController.frontImage = URL(string: value.frontSide ?? "")
        requestPhotoGalleryViewController.backImage = URL(string: value.backSide ?? "")
        present(requestPhotoGalleryViewController, animated: true, completion: nil)
    }

    @IBAction func routeOurAgent(_ sender: Any) {
        let ourAgentViewController = OurAgentViewController(nibName: "OurAgentViewController", bundle: nil)
        navigationController?.pushViewController(ourAgentViewController, animated: true)
    }
    
    @IBAction func cancelListing(_ sender: UIButton) {
        let confirmViewController = ConfirmViewController(nibName: "ConfirmViewController", bundle: nil)
        confirmViewController.view.frame.size.width = view.frame.size.width
        confirmViewController.height = 141
        confirmViewController.topCornerRadius = 12
        confirmViewController.shouldDismissInteractivelty = false
        confirmViewController.presentDuration = 0.2
        confirmViewController.dismissDuration = 0.2
        confirmViewController.delegate = self
        confirmViewController.theTitle = "cancel-listing".localized() + "?"
        present(confirmViewController, animated: true, completion: nil)
    }
    
    func routeeToRateAgent() {
        let rateAgentViewController = RateAgentViewController(nibName: "RateAgentViewController", bundle: nil)
        rateAgentViewController.view.frame.size.width = view.frame.size.width
        rateAgentViewController.height = UIScreen.main.bounds.size.height - 100
        rateAgentViewController.topCornerRadius = 12
        rateAgentViewController.shouldDismissInteractivelty = true
        rateAgentViewController.presentDuration = 0.2
        rateAgentViewController.dismissDuration = 0.2
        rateAgentViewController.viewModel.id = viewModel.id
        rateAgentViewController.viewModel.paramIdType = "customer_item_id"
        rateAgentViewController.viewModel.type = "seller"
        rateAgentViewController.delegate = self
        present(rateAgentViewController, animated: true, completion: nil)
    }
}

// MARK: - Private Extension

fileprivate extension GiveToAgentViewController {
    
    func setupUI() {
        galleryContainerView.layer.cornerRadius = 5
        galleryContainerView.clipsToBounds = true
        
        ourAgentView.layer.cornerRadius = 6
        ourAgentView.layer.borderColor = UIColor(hexString: "#CFCFCF").cgColor
        ourAgentView.layer.borderWidth = 1
        ourAgentView.clipsToBounds = true
        
        cancelListingButton.layer.cornerRadius = 5
        nameContainerView.layer.cornerRadius = 4
        nameContainerView.clipsToBounds = true
    }
    
    func setupBinding() {
        viewModel.data.subscribe(onNext: { data in
            if let value = data {
                for itemMainPhoto in self.itemMainPhoto {
                    itemMainPhoto.sd_setImage(
                        with: URL(string: value.customerItem.itemImage),
                        placeholderImage: nil,
                        options: .refreshCached
                    )
                }
                
                for itemNameLabel in self.itemNameLabel {
                    itemNameLabel.text = value.customerItem.name
                }
                
                for categoryLbl in self.categoryLabel {
                    categoryLbl.text = value.customerItem.category
                }
                
                self.itemCodeLabel.text = value.customerItem.code
                self.itemTypeLabel.text = value.customerItem.type
                self.itemSeatLabel.text = value.customerItem.seat ?? "-"
                self.itemDateLabel.text = value.customerItem.date
                self.itemLocationLabel.text = value.customerItem.location
                self.itemDescriptionLabel.text = value.customerItem.description ?? "-"
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        
        viewModel.qrImage.subscribe(onNext: { url in
            self.qrImageView.sd_setImage(
                with: url,
                placeholderImage: nil,
                options: .refreshCached,
                completed: nil
            )
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        
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
    
    func setupLayer() {
        guard shadowLayer == nil else {
            return
        }
        
        let bounds = CGRect(
            x: cancelListingButton.bounds.origin.x,
            y: cancelListingButton.bounds.origin.y,
            width: view.frame.size.width - 40,
            height: 37
        )
        
        let shadowLayer = CAShapeLayer()
        shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: 5).cgPath
        shadowLayer.fillColor = UIColor.greenApp.cgColor
        shadowLayer.shadowColor = UIColor.black.cgColor
        shadowLayer.shadowPath = shadowLayer.path
        shadowLayer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        shadowLayer.shadowOpacity = 0.2
        shadowLayer.shadowRadius = 5
        cancelListingButton.layer.insertSublayer(shadowLayer, at: 0)
        self.shadowLayer = shadowLayer
    }
    
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "informaton".localized(), message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}

// MARK: - ConfirmViewControllerDelegate

extension GiveToAgentViewController: ConfirmViewControllerDelegate {
    
    func confirmViewController(didTapConfirm confirmViewController: ConfirmViewController) {
        viewModel.cancelListing()
    }
}

// MARK: - RateAgentViewControllerDelegate

extension GiveToAgentViewController: RateAgentViewControllerDelegate {
    
    func rateAgentViewController(didSuccess rateAgentViewController: RateAgentViewController) {
        navigationController?.popViewController(animated: true)
    }
}
