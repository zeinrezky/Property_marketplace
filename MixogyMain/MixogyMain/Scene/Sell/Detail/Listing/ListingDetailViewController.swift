//
//  ListingDetailViewController.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 05/04/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import Photos
import RxCocoa
import RxSwift
import SVProgressHUD
import UIKit

class ListingDetailViewController: MixogyBaseViewController {

    @IBOutlet var itemNameLabel: UILabel!
    @IBOutlet var itemAmountTextField: UITextField!
    @IBOutlet var itemStatustLabel: UILabel!
    @IBOutlet var itemDescriptionTextview: UITextView!
    @IBOutlet var confidentialInformationTextView: UITextView!
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
    @IBOutlet var itemMainPhoto: UIImageView!
    @IBOutlet var itemPhotoTitleLabel: UILabel!
    @IBOutlet var galleryContainerView: UIView!
    @IBOutlet var confidentialGalleryContainerView: UIView!
    @IBOutlet var confidentialPhotoViews: [UIView]!
    @IBOutlet var cancelListingButton: UIButton!
    @IBOutlet var editButton: UIButton!
    @IBOutlet var containerView: UIView!
    @IBOutlet var onlineMethodViewHeight: NSLayoutConstraint!
    @IBOutlet var confidentialRight: NSLayoutConstraint!
    @IBOutlet var onlineMethodView: UIView!
    @IBOutlet var uploadPhotoContainer: UIView!
    @IBOutlet var collectionView: UICollectionView!
    
    var disposeBag = DisposeBag()
    var viewModel = ListingDetailViewModel()
    var shadowLayer: CAShapeLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupBinding()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.receivedNotification(notification:)),
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
        title = "item-detail".localized()
        cancelListingButton.setTitle("cancel-listing".localized(), for: .normal)
        editButton.setTitle("edit".localized(), for: .normal)
        
        itemTypeTitleLabel.text = "item-type".localized()
        itemSeatTitleLabel.text = "seat".localized()
        
        itemDateTitleLabel.text = "date".localized()
        itemLocationTitleLabel.text = "location".localized()
        itemDescriptionTitleLabel.text = "item-description".localized()
        itemPhotoTitleLabel.text = "item-photos".localized()
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

    @IBAction func cancelListing(_ sender: UIButton) {
        if viewModel.isEdit.value {
            viewModel.edit()
        } else {
            let cancelReasonViewController = CancelReasonViewController(nibName: "CancelReasonViewController", bundle: nil)
            cancelReasonViewController.view.frame.size.width = view.frame.size.width
            cancelReasonViewController.height = 440
            cancelReasonViewController.topCornerRadius = 12
            cancelReasonViewController.shouldDismissInteractivelty = false
            cancelReasonViewController.presentDuration = 0.2
            cancelReasonViewController.dismissDuration = 0.2
            cancelReasonViewController.delegate = self
            present(cancelReasonViewController, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func edit(_ sender: UIButton) {
        itemAmountTextField.isUserInteractionEnabled = sender.tag == 0
        itemDescriptionTextview.isUserInteractionEnabled = sender.tag == 0
        
        itemAmountTextField.layer.borderColor = UIColor.greenApp.cgColor
        itemDescriptionTextview.layer.borderColor = UIColor.greenApp.cgColor
        itemAmountTextField.layer.borderWidth = sender.tag == 0 ? 1 : 0
        itemDescriptionTextview.layer.borderWidth = sender.tag == 0 ? 1 : 0
        
        sender.backgroundColor = UIColor(hexString: "#A8A8A8")
        sender.isUserInteractionEnabled = false
        viewModel.isEdit.accept(true)
        
        if viewModel.isOnlineMethod.value {
            viewModel.isOnlineMethodEdit.accept(true)
        }
        
        if sender.tag == 0 {
            itemAmountTextField.text = "\(viewModel.data.value!.customerItem.yourPrice)"
            sender.tag = 1
        }
    }
    
    @IBAction func uploadPhoto(_ sender: UIButton) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = false
        pickerController.view.tag = sender.tag
        
        let actionSheet = UIAlertController(
            title: "Choose Media".localized(),
            message: nil,
            preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera".localized(), style: .default) { (action) in
            self.checkCameraPermission { isGranted in
                if isGranted {
                    DispatchQueue.main.async {
                        pickerController.sourceType = .camera
                        self.present(pickerController, animated: true, completion: nil)
                    }
                }
            }
        }
        
        let galleryAction = UIAlertAction(title: "Gallery".localized(), style: .default) { (action) in
            self.checkPermission { isGranted in
                if isGranted {
                    DispatchQueue.main.async {
                        pickerController.sourceType = .photoLibrary
                        self.present(pickerController, animated: true, completion: nil)
                    }
                }
            }
        }
        
        actionSheet.addAction(cameraAction)
        actionSheet.addAction(galleryAction)
        actionSheet.addAction(UIAlertAction(title: "cancel".localized(), style: .cancel, handler: nil))
        present(actionSheet, animated: true, completion: nil)
    }
    
    @objc func receivedNotification(notification: Notification) {
        let type = notification.userInfo!["type"] as? String ?? ""
        
        if !type.isEmpty {
            switch type {
            case "send_to_customer":
                navigationController?.popViewController(animated: true)
                
            default:
                break
            }
        }
    }
    
    func checkPermission(_ completion: @escaping(Bool) -> Void) {
        let currentStatus = PHPhotoLibrary.authorizationStatus()
        guard currentStatus != .authorized else {
            completion(true)
            return
        }

        PHPhotoLibrary.requestAuthorization { (authorizationStatus) -> Void in
          DispatchQueue.main.async {
            if authorizationStatus == .denied {
              self.presentAskPermissionAlert()
            } else if authorizationStatus == .authorized {
                completion(true)
            }
          }
        }
    }
    
    func presentAskPermissionAlert() {
        let alertController = UIAlertController(
            title: "Permission denied",
            message: "Please, allow the application to access to your photo library.",
            preferredStyle: .alert)

      let alertAction = UIAlertAction(title: "Ok", style: .default) { _ in
        if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.openURL(settingsURL)
        }
      }

      let cancelAction = UIAlertAction(title: "cancel".localized(), style: .cancel) { _ in
        self.dismiss(animated: true, completion: nil)
      }
        
        alertController.addAction(alertAction)
        alertController.addAction(cancelAction)

        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func checkCameraPermission(_ completion: @escaping(Bool) -> Void) {
        let cameraMediaType = AVMediaType.video
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: cameraMediaType)
            
        switch cameraAuthorizationStatus {
        case .denied:
            self.presentAskPermissionAlert()
            
        case .authorized:
            completion(true)
            
        case .restricted: break

        case .notDetermined:
            // Prompting user for the permission to use the camera.
            AVCaptureDevice.requestAccess(for: cameraMediaType) { granted in
                if granted {
                    completion(true)
                } else {
                    self.presentAskPermissionAlert()
                }
            }
        }
    }
}

// MARK: - Private Extension

fileprivate extension ListingDetailViewController {
    
    func setupUI() {
        cancelListingButton.layer.cornerRadius = 5
        galleryContainerView.layer.cornerRadius = 5
        confidentialGalleryContainerView.layer.cornerRadius = 5
        itemDescriptionTextview.layer.cornerRadius = 4
        containerView.layer.cornerRadius = 4
        containerView.clipsToBounds = true
        itemDescriptionTextview.clipsToBounds = true
        editButton.layer.cornerRadius = 4
        editButton.clipsToBounds = true
        galleryContainerView.clipsToBounds = true
        confidentialGalleryContainerView.clipsToBounds = true
        uploadPhotoContainer.layer.borderColor = UIColor(hexString: "#D5D5D5").cgColor
        uploadPhotoContainer.layer.borderWidth = 1.0
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 16
        layout.itemSize = CGSize(width: 144, height: 144)
        
        collectionView.setCollectionViewLayout(layout, animated: true)
        collectionView.register(UINib(nibName: "LocationPhotoCell", bundle: nil), forCellWithReuseIdentifier: "LocationPhotoCell")
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
                self.itemSeatLabel.text = value.customerItem.seat
                self.itemDateLabel.text = value.customerItem.date
                let statusType: SellStatus = SellStatus(rawValue: value.customerItem.statusId) ?? .giveToAgent
                
                let titleValue: String
                
                if value.customerItem.status == "Online - Listing" {
                    titleValue = value.customerItem.status
                } else {
                    titleValue = statusType == .listingOnAgent ? (value.customerItem.status.lowercased() == "listing" ? "listing-status".localized() : statusType.title) : statusType.title
                }
                
                self.itemStatustLabel.text = titleValue
                self.itemAmountTextField.text = value.customerItem.yourPrice.currencyFormat
                self.itemLocationLabel.text = value.customerItem.location
                self.itemDescriptionTextview.text = value.customerItem.description ?? "-"
                
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
        
        viewModel.isOnlineMethod.subscribe(onNext: { isOnlineMethod in
            if isOnlineMethod {
                self.onlineMethodView.isHidden = false
            } else {
                self.onlineMethodView.isHidden = true
                self.onlineMethodViewHeight.constant = 0
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        
        viewModel.isOnlineMethodEdit.subscribe(onNext: { isOnlineMethodEdit in
            if isOnlineMethodEdit {
                self.confidentialRight.constant = 20
                self.onlineMethodViewHeight.constant = 414
            } else {
                self.confidentialRight.constant = 72
                self.onlineMethodViewHeight.constant = 200
            }
            
            for view in self.confidentialPhotoViews {
                view.isHidden = !isOnlineMethodEdit
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        
        viewModel.isEdit.subscribe(onNext: { isEdit in
            self.confidentialInformationTextView.isUserInteractionEnabled = isEdit
            self.cancelListingButton.setTitle(isEdit ? "Save" : "cancel-listing".localized(), for: .normal)
        }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: disposeBag)
        
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
        
        viewModel.photos.bind(to: collectionView.rx.items(cellIdentifier: "LocationPhotoCell", cellType: LocationPhotoCell.self)) { (indexPath, data, cell) in
            cell.data = data
            cell.delegate = self
        }.disposed(by: disposeBag)
        
        itemAmountTextField
            .rx
            .text
            .bind(to: viewModel.yourPrice)
            .disposed(by: disposeBag)
        
        itemDescriptionTextview
            .rx
            .text
            .bind(to: viewModel.description)
            .disposed(by: disposeBag)
        
        confidentialInformationTextView
            .rx
            .text
            .bind(to: viewModel.confidentialInformation)
            .disposed(by: disposeBag)
        
        viewModel
            .confidentialInformation
            .bind(to: confidentialInformationTextView.rx.text)
            .disposed(by: disposeBag)
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

// MARK: - UINavigationControllerDelegate
extension ListingDetailViewController: UINavigationControllerDelegate {}

// MARK: - CancelReasonViewControllerDelegate

extension ListingDetailViewController: CancelReasonViewControllerDelegate {
    
    func cancelReasonViewController(didTapConfirm cancelReasonViewController: CancelReasonViewController, reasonId: Int, comment: String?) {
        viewModel.cancelListing(reasonId: reasonId, comment: comment)
    }
}

// MARK: - UIImagePickerControllerDelegate

extension ListingDetailViewController: UIImagePickerControllerDelegate {
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        dismiss(animated: true, completion: nil)
        
        if let image = info[.originalImage] as? UIImage,
            let compressedData = image.compressedData() {
            
            viewModel.uploadPhoto(imageData: compressedData)
        }
    }
}

// MARK: - LocationPhotoCellDelegate

extension ListingDetailViewController: LocationPhotoCellDelegate {
    
    func locationPhotoCell(cell didTapRemove: LocationPhotoCell, data: (Data?, String?, Int)) {
        if let index = viewModel.photos.value.firstIndex(where: { $0 == data }) {
            var photos = viewModel.photos.value
            photos.remove(at: index)
            viewModel.photos.accept(photos)
        }
    }
}
