//
//  PurchaseHistoryDetailViewController.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 30/03/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import RxCocoa
import RxSwift
import SVProgressHUD
import UIKit

class PurchaseHistoryDetailViewController: UIViewController {

    @IBOutlet var itemCodeLabel: UILabel!
    @IBOutlet var itemNameLabel: UILabel!
    @IBOutlet var typeLabel: UILabel!
    @IBOutlet var seatLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var gracePeriodLabel: UILabel!
    @IBOutlet var coverImageView: UIImageView!
        
    var disposeBag = DisposeBag()
    var viewModel = PurchaseHistoryDetailViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupBinding()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel.fetchData()
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

fileprivate extension PurchaseHistoryDetailViewController {
    
    func setupUI() {
        title = "Item Details"
    }
    
    func setupBinding() {
        viewModel.data.subscribe(onNext: { data in
            if let value = data {
                self.coverImageView.sd_setImage(
                    with: URL(string: value.customerItem.itemImage),
                    placeholderImage: nil,
                    options: .refreshCached
                )
                self.itemCodeLabel.text = value.customerItem.code
                self.itemNameLabel.text = value.customerItem.name
                self.typeLabel.text = value.customerItem.type
                self.seatLabel.text = value.customerItem.seat ?? "-"
                self.dateLabel.text = value.customerItem.date
                self.locationLabel.text = value.customerItem.location
                self.descriptionLabel.text = value.customerItem.description ?? "-"
                self.gracePeriodLabel.text = value.customerItem.gracePeriod.ended ? "Grace Period Ended" : value.customerItem.gracePeriod.date
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
