//
//  OnlineGraceViewController.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 30/01/21.
//  Copyright © 2021 Mixogy. All rights reserved.
//

import EzPopup
import RxCocoa
import RxSwift
import SVProgressHUD
import UIKit

class OnlineGraceViewController: UIViewController {

    @IBOutlet var itemCodeLabel: UILabel!
    @IBOutlet var itemNameLabel: UILabel!
    @IBOutlet var typeLabel: UILabel!
    @IBOutlet var seatLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var categoryLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var gracePeriodLabel: UILabel!
    @IBOutlet var coverImageView: UIImageView!
    @IBOutlet var borderedView: [UIView]!
    @IBOutlet var galleryContainerView: UIView!
    @IBOutlet var confidentialGalleryContainerView: UIView!
    @IBOutlet var confidentialInformationTextView: UITextView!
    @IBOutlet var sellerProfileImageView: UIImageView!
    @IBOutlet var sellerLabel: UILabel!
    
    var disposeBag = DisposeBag()
    var viewModel = OnlineGraceViewModel()
    
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
    
    @IBAction func routeToFAQ(_ sender: UIButton) {
        let faqViewController = FAQViewController(nibName: "FAQViewController", bundle: nil)
        navigationController?.pushViewController(faqViewController, animated: true)
    }
    
    @IBAction func routeToCall(_ sender: UIButton) {
        let phone = "621123456"
        
        if let url = URL(string: "tel://\(phone)"){
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    @IBAction func showConfidentialPhoto(_ sender: UIButton) {
        guard let value = viewModel.data.value?.customerItem.confidential_photos else {
            return
        }
        
        let requestPhotoGalleryViewController = ConfidentialPhotoGalleryViewController(nibName: "ConfidentialPhotoGalleryViewController", bundle: nil)
        requestPhotoGalleryViewController.view.frame.size.width = view.frame.size.width
        requestPhotoGalleryViewController.height = (self.view.frame.size.height / 2) + 87
        requestPhotoGalleryViewController.topCornerRadius = 12
        requestPhotoGalleryViewController.shouldDismissInteractivelty = false
        requestPhotoGalleryViewController.presentDuration = 0.2
        requestPhotoGalleryViewController.dismissDuration = 0.2
        requestPhotoGalleryViewController.data.accept(value.map {(confidential) -> ConfidentialPhotoGalleryCellViewModel in
            return ConfidentialPhotoGalleryCellViewModel(id: 0, photo: confidential.photoURL)
        })
        present(requestPhotoGalleryViewController, animated: true, completion: nil)
    }
    
    @IBAction func chatButtonDidTapped() {
        guard let data = viewModel.data.value,
            let txId = data.customerItem.transactionDetailId else {
            return
        }
        
        let roomId = "\(txId)"
        
        SVProgressHUD.show()
        Room.fetchRoom(
            documentId: roomId,
            { roomId in
                SVProgressHUD.dismiss()
                PreferenceManager.room = roomId
                let vc = ChatRoomViewController()
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
        },{
            let name = data.customerItem.name ?? "\(txId)"
            Room.createRoom(roomId: roomId, title: "Transaction \(name)", member: [data.seller?.phone ?? ""])
            
            Room.fetchRoom(
                documentId: roomId,
                { roomId in
                    SVProgressHUD.dismiss()
                    PreferenceManager.room = roomId
                    let vc = ChatRoomViewController()
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
            },{
                SVProgressHUD.dismiss()
            })
        })
    }
}

// MARK: - MyPurchaseViewController

fileprivate extension OnlineGraceViewController {
    
    func setupUI() {
        title = "On Hand"
        
        for view in borderedView {
            view.layer.borderColor = UIColor(hexString: "#4DD2A7").cgColor
            view.layer.borderWidth = 0.5
        }
        
        galleryContainerView.layer.cornerRadius = 5
        galleryContainerView.clipsToBounds = true
        confidentialGalleryContainerView.layer.cornerRadius = 5
        confidentialGalleryContainerView.clipsToBounds = true
    }
    
    func setupBinding() {
        viewModel.data.subscribe(onNext: { data in
            if let value = data {
                self.coverImageView.sd_setImage(
                    with: URL(string: value.customerItem.itemImage),
                    placeholderImage: nil,
                    options: .refreshCached
                )
                if let photoURL = value.seller?.photoUrl {
                    self.sellerProfileImageView.sd_setImage(
                        with: URL(string: photoURL),
                        placeholderImage: nil,
                        options: .refreshCached
                    )
                }
                
                self.itemCodeLabel.text = value.customerItem.code
                self.itemNameLabel.text = value.customerItem.name
                self.typeLabel.text = value.customerItem.type
                self.seatLabel.text = value.customerItem.seat ?? "-"
                self.dateLabel.text = value.customerItem.date
                self.locationLabel.text = value.customerItem.location
                self.categoryLabel.text = value.customerItem.category
                self.descriptionLabel.text = value.customerItem.description ?? "-"
                self.gracePeriodLabel.text = value.customerItem.gracePeriod.ended ? "Grace Period Ended" : value.customerItem.gracePeriod.date
                self.confidentialInformationTextView.text = data?.customerItem.confidentialInformation
                self.sellerLabel.text = value.seller?.name
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
