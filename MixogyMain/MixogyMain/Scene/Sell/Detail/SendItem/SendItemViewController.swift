//
//  SendItemViewController.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 11/04/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import Agrume
import CoreLocation
import RxCocoa
import RxSwift
import SDWebImage
import SVProgressHUD
import UIKit

class SendItemViewController: MixogyBaseViewController {

    @IBOutlet var agentProfileImageView: UIImageView!
    @IBOutlet var agentLabel: UILabel!
    @IBOutlet var agentTitleLabel: UILabel!
    @IBOutlet var itemCodeLabel: UILabel!
    @IBOutlet var itemCodeTitleLabel: UILabel!
    @IBOutlet var itemNameLabel: UILabel!
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
    @IBOutlet var courierNameTextField: UITextField!
    @IBOutlet var courierResiTextField: UITextField!
    @IBOutlet var courierPhoneTextField: UITextField!
    @IBOutlet var courierNameLabel: UILabel!
    @IBOutlet var courierResiLabel: UILabel!
    @IBOutlet var courierPhoneLabel: UILabel!
    @IBOutlet var confirmButton: UIButton!
    @IBOutlet var categoryLabel: UILabel!
    @IBOutlet var categoryTitleLabel: UILabel!
    @IBOutlet var itemPhotoTitleLabel: UILabel!
    @IBOutlet var itemMainPhoto: UIImageView!
    @IBOutlet var galleryContainerView: UIView!
    @IBOutlet var addressTextView: UITextView!
    @IBOutlet var phoneTextField: UITextField!
    @IBOutlet var placeNameLabel: UILabel!
    @IBOutlet var provinceTextField: UITextField!
    @IBOutlet var cityTextField: UITextField!
    @IBOutlet var editableTextField: [UIView]!
    
    let locationManager = CLLocationManager()
    var disposeBag = DisposeBag()
    var viewModel = SendItemViewModel()
        
    override func viewDidLoad() {
        super.viewDidLoad()
            
        setupUI()
        setupBinding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
         
         navigationController?.isNavigationBarHidden = false
         navigationController?.navigationBar.isHidden = false
        
        for view in editableTextField {
            view.layer.borderColor = UIColor(hexString: "#D5D5D5").cgColor
            view.layer.borderWidth = 1.0
        }
     }
     
     override func viewWillDisappear(_ animated: Bool) {
         super.viewWillDisappear(animated)
         
         navigationController?.isNavigationBarHidden = true
         navigationController?.navigationBar.isHidden = true
     }
    
    override func setupLanguage() {
        title = "send-item".localized()
        itemCodeTitleLabel.text = "item-code".localized()
        itemNameTitleLabel.text = "item-name".localized()
        itemTypeTitleLabel.text = "item-type".localized()
        itemSeatTitleLabel.text = "seat".localized()
        agentTitleLabel.text = "buyer-name".localized()
        itemDateTitleLabel.text = "date".localized()
        itemLocationTitleLabel.text = "location".localized()
        categoryTitleLabel.text = "category".localized()
        itemDescriptionTitleLabel.text = "item-description".localized()
        itemPhotoTitleLabel.text = "item-photos".localized()
        confirmButton.setTitle("confirm-send".localized(), for: .normal)
        courierNameTextField.placeholder = "courier-name".localized()
        courierResiTextField.placeholder = "resi-number".localized()
        courierPhoneTextField.placeholder = "contact-number".localized()
        courierNameLabel.text = "courier-name".localized()
        courierResiLabel.text = "resi-number".localized()
        courierPhoneLabel.text = "contact-number".localized()
    }
    
    @IBAction func showPhoto(_ sender: UIButton) {
        guard let value = viewModel.data.value else {
            return
        }
        
        let requestPhotoGalleryViewController = RequestPhotoGalleryViewController(nibName: "RequestPhotoGalleryViewController", bundle: nil)
        requestPhotoGalleryViewController.view.frame.size.width = view.frame.size.width
        requestPhotoGalleryViewController.height = (self.view.frame.size.height / 2) + 87
        requestPhotoGalleryViewController.topCornerRadius = 12
        requestPhotoGalleryViewController.shouldDismissInteractivelty = false
        requestPhotoGalleryViewController.presentDuration = 0.2
        requestPhotoGalleryViewController.dismissDuration = 0.2
        requestPhotoGalleryViewController.frontImage = URL(string: value.customerItem.itemPhotos.frontSide ?? "")
        requestPhotoGalleryViewController.backImage = URL(string: value.customerItem.itemPhotos.backSide ?? "")
        present(requestPhotoGalleryViewController, animated: true, completion: nil)
    }
    
    @IBAction func switchImages(_ sender: UIButton) {
        viewModel.switchLocationImage(index: sender.tag)
    }
    
    @IBAction func routeToChat(_ sender: UIButton) {
        guard let data = viewModel.data.value,
            let agentId = data.agent?.id else {
            return
        }
        
        let agent = "agent-\(agentId)"
        let roomId = "\(data.customerItem.transactionDetailId ?? 0)"
        
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
            Room.createRoom(roomId: roomId, title: "Transaction \(roomId)", member: [agent])
            
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
    
    @IBAction func sendItem(_ sender: UIButton) {
        viewModel.sendItem()
    }
}

// MARK: - Private Extension

fileprivate extension SendItemViewController {
    
    func setupUI() {
        galleryContainerView.layer.cornerRadius = 5
        galleryContainerView.clipsToBounds = true
        
        locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    func setupBinding() {
        courierNameTextField
            .rx
            .text
            .bind(to: viewModel.courierName)
            .disposed(by: disposeBag)
        
        courierResiTextField
            .rx
            .text
            .bind(to: viewModel.courierResi)
            .disposed(by: disposeBag)
        
        courierPhoneTextField
            .rx
            .text
            .bind(to: viewModel.courierPhone)
            .disposed(by: disposeBag)
        
        viewModel.data.subscribe(onNext: { data in
            if let value = data {
                
                if value.customerItem.statusId == 19 {
                    self.confirmButton.isHidden = true
                    self.courierNameTextField.isUserInteractionEnabled = false
                    self.courierResiTextField.isUserInteractionEnabled = false
                    self.courierPhoneTextField.isUserInteractionEnabled = false
                    self.courierNameTextField.text = value.customerItem.courierName
                    self.courierResiTextField.text = value.customerItem.resiNumber
                    self.courierPhoneTextField.text = value.customerItem.contactNumber
                }
                
                self.agentLabel.text = value.buyer?.name
                self.itemCodeLabel.text = value.customerItem.code
                self.itemNameLabel.text = value.customerItem.name
                self.itemDescriptionLabel.text = value.customerItem.description ?? "-"
                self.itemSeatLabel.text = value.customerItem.seat
                self.itemTypeLabel.text = value.customerItem.type
                self.itemDateLabel.text = value.customerItem.date
                self.itemLocationLabel.text = value.customerItem.location
                self.categoryLabel.text = value.customerItem.category
                self.phoneTextField.text = value.buyer?.address?.phone
                self.placeNameLabel.text = value.buyer?.address?.placeName
                self.provinceTextField.text = value.buyer?.address?.provinceName
                self.cityTextField.text = value.buyer?.address?.cityName
                self.addressTextView.text = value.buyer?.address?.detail
                self.itemMainPhoto.sd_setImage(
                    with: URL(string: value.customerItem.itemImage),
                    placeholderImage: nil,
                    options: .refreshCached,
                    completed: nil
                )
                
                self.agentProfileImageView.sd_setImage(
                    with: URL(string: value.buyer?.photoUrl ?? ""),
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
        
        viewModel.agentImage.subscribe(onNext: { url in
            self.agentProfileImageView.sd_setImage(
                with: url,
                placeholderImage: nil,
                options: .refreshCached,
                completed: nil
            )
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
        
        viewModel.isInvalid.subscribe(onNext: { isInvalid in
            if isInvalid {
                self.showAlert(message: "Form Tidak Lengkap")
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
    
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "informaton".localized(), message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

// MARK: - CLLocationManagerDelegate

extension SendItemViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let value: CLLocationCoordinate2D = manager.location?.coordinate else {
            return
        }
        
        viewModel.userCoordinate = value
        viewModel.fetchData()
        
        locationManager.stopUpdatingLocation()
    }
}
