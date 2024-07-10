//
//  SellHistoryDetailViewController.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 05/04/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import RxCocoa
import RxSwift
import SVProgressHUD
import UIKit

class SellHistoryDetailViewController: MixogyBaseViewController {

    @IBOutlet var itemNameLabel: UILabel!
    @IBOutlet var gracePeriodLabel: UILabel!
    @IBOutlet var itemAmountLabel: UILabel!
    @IBOutlet var itemStatustLabel: UILabel!
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
    @IBOutlet var itemPhotosLabel: UILabel!
    @IBOutlet var categoryTitleLabel: UILabel!
    @IBOutlet var categoryLabel: [UILabel]!
    @IBOutlet var itemMainPhoto: UIImageView!
    @IBOutlet var galleryContainerView: UIView!
    @IBOutlet var itemTopConstraint: NSLayoutConstraint!
    
    var disposeBag = DisposeBag()
    var viewModel = SellHistoryDetailViewModel()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupBinding()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel.fetchData()
        
        if viewModel.type == .paymentStatus {
            itemTopConstraint.constant = 8
            itemStatustLabel.textColor = UIColor(hexString: "#C6C6C6")
            gracePeriodLabel.isHidden = false
        }
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
        title = "item-detail".localized()
        
        itemTypeTitleLabel.text = "item-type".localized()
        itemSeatTitleLabel.text = "seat".localized()
        itemDateTitleLabel.text = "date".localized()
        itemLocationTitleLabel.text = "location".localized()
        categoryTitleLabel.text = "category".localized()
        itemDescriptionTitleLabel.text = "item-description".localized()
        itemPhotosLabel.text = "item-photos".localized()
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
}

// MARK: - Private Extension

fileprivate extension SellHistoryDetailViewController {
    
    func setupUI() {
        galleryContainerView.layer.cornerRadius = 5
        galleryContainerView.clipsToBounds = true
    }
    
    func setupBinding() {
        viewModel.data.subscribe(onNext: { data in
            if let value = data {
                self.itemMainPhoto.sd_setImage(
                    with: URL(string: value.customerItem.itemImage),
                    placeholderImage: nil,
                    options: .refreshCached
                )
                self.itemNameLabel.text = value.customerItem.name
                self.itemTypeLabel.text = value.customerItem.type
                self.itemSeatLabel.text = value.customerItem.seat ?? "-"
                self.itemDateLabel.text = value.customerItem.date
                let statusType: SellStatus = SellStatus(rawValue: value.customerItem.statusId) ?? .giveToAgent
                let titleValue = statusType == .listingOnAgent ? (value.customerItem.status.lowercased() == "listing" ? "listing-status".localized() : statusType.title) : statusType.title
                self.itemStatustLabel.text = titleValue
                self.itemAmountLabel.text = value.customerItem.yourPrice.currencyFormat
                self.itemLocationLabel.text = value.customerItem.location
                self.itemDescriptionLabel.text = value.customerItem.description ?? "-"
                self.gracePeriodLabel.text = value.customerItem.gracePeriod?.ended ?? false ? "ended".localized() : value.customerItem.gracePeriod?.date ?? "-"
                self.gracePeriodLabel.isHidden = value.customerItem.statusId == 17
                
                for categoryLbl in self.categoryLabel {
                    categoryLbl.text = value.customerItem.category
                }
            }
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
    }
    
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "informaton".localized(), message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
