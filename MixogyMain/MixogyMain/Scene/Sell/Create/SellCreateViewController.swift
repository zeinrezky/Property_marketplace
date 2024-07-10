//
//  SellCreateViewController.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 06/04/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import ActionSheetPicker_3_0
import Cartography
import DropDown
import EzPopup
import Photos
import MaterialComponents
import RxCocoa
import RxSwift
import SDWebImage
import SVProgressHUD
import UIKit
import UITextView_Placeholder

class SellCreateViewController: MixogyBaseViewController {

    @IBOutlet var itemNameLabel: UILabel!
    @IBOutlet var categoryLabel: UILabel!
    @IBOutlet var categoryContainerView: UIView!
    @IBOutlet var categoryImageView: UIImageView!
    @IBOutlet var yourPriceTextField: UITextField!
    @IBOutlet var borderedViews: [UIView]!
    @IBOutlet var youWillReceiveLabel: UILabel!
    @IBOutlet var adminFeeLabel: UILabel!
    @IBOutlet var quantiryLabel: UILabel!
    @IBOutlet var descriptionTextView: UITextView!
    @IBOutlet var confidentialTextView: UITextView!
    @IBOutlet var questionView: [UIView]!
    @IBOutlet var confidentialView: UIView!
    @IBOutlet var uploadPhotoContainer: UIView!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var stackView: UIStackView!
    @IBOutlet var placeTextField: MXTextField!
    @IBOutlet var dateTextField: MXTextField!
    @IBOutlet var movieDateTextField: MXTextField!
    @IBOutlet var movieTimeTextField: MXTextField!
    @IBOutlet var movieDateArrowImageView: UIView!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var movieTimeLabel: UILabel!
    @IBOutlet var dateButton: UIButton!
    @IBOutlet var mainUploadPhotoContainer: UIView!
    @IBOutlet var mainCollectionView: UICollectionView!
    @IBOutlet var itemTypeTextField: MXTextField!
    @IBOutlet var smallTypeTextField: MXTextField!
    @IBOutlet var quantityTextField: MXTextField!
    @IBOutlet var smallTypeArrowImageView: UIView!
    @IBOutlet var typeArrowImageView: UIView!
    @IBOutlet var itemTypeButton: UIButton!
    @IBOutlet var typeLabel: UILabel!
    @IBOutlet var collectionMethodLabel: UILabel!
    
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var submitButton: UIButton!
    @IBOutlet var timeLabel: UILabel!
    
    @IBOutlet var descriptioonLabel: UILabel!
    @IBOutlet var methodLabel: UILabel!
    @IBOutlet var mainImageViewTop: NSLayoutConstraint!
    @IBOutlet var confidentialViewHeight: NSLayoutConstraint!
    @IBOutlet var yourPriceLabel: UILabel!
    @IBOutlet var keepItemView: UIView!
    @IBOutlet var pickupView: UIView!
    @IBOutlet var onnlineMethodView: UIView!
    
    var disposeBag = DisposeBag()
    var viewModel = SellCreateViewModel()
    var shadowLayer = CAShapeLayer()
    var voucherShadowLayer = CAShapeLayer()
    var categoryShadowLayer = CAShapeLayer()
    var sectionAdded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupBinding()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setupLayer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.isHidden = false
        viewModel.fetchCollectionMethod()
        
        if viewModel.selectedItemCategoryData == nil {
            routeToSearch()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.isNavigationBarHidden = true
        navigationController?.navigationBar.isHidden = true
    }
    
    override func setupLanguage() {
        placeTextField.placeholder = "location".localized()
        dateTextField.placeholder = "date".localized()
//        validTextField.placeholder = "date".localized()
        movieTimeTextField.placeholder = "time".localized()
        itemTypeTextField.placeholder = "type".localized()
        yourPriceTextField.placeholder = "your-price".localized()
//        youWillReceiveTextField.placeholder = "you-will-receive".localized()
//        seatTextField.placeholder = "studio-and-item-seat".localized()
        
//        eventNameLabel.text = "search-item-name".localized()
        locationLabel.text = "location".localized()
        dateLabel.text = "date".localized()
        timeLabel.text = "time".localized()
        typeLabel.text = "type".localized()
        methodLabel.text = "method".localized()
//        radioLabels[1].text = "agent".localized()
//        radioLabels[0].text = "keep-item".localized()
//        ticketPhotosLabel.text = "ticket-photos".localized()
        yourPriceLabel.text = "your-price".localized()
//        yourReceiveLabel.text = "you-will-receive".localized()
//        seatLabel.text = "studio-and-item-seat".localized()
//        multipleItemLabel.text = "multiple-items".localized()
        descriptioonLabel.text = "description".localized()
//        frontSideLabel.text = "front-side".localized()
        submitButton.setTitle("add-to-list".localized(), for: .normal)
    }
    
    @IBAction func changeSellType(_ sender: UIButton) {
        viewModel.sellTypeId.accept(sender.tag)
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
    
    @IBAction func submit(_ sender: UIButton) {
        viewModel.submit()
    }
    
    @IBAction func selectType(_ sender: UIButton) {
        let dropDown = DropDown()
        dropDown.anchorView = self.itemTypeTextField
        dropDown.dataSource = viewModel.typeOptions.map { (type) -> String in
            return type.type
        }
        dropDown.cellNib = UINib(nibName: "TemplateOptionCell", bundle: nil)
        dropDown.show()
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.itemTypeTextField.text = item
            self.smallTypeTextField.text = item
            self.viewModel.typeId = self.viewModel.data.value!.types[index].id
            self.viewModel.type = item
        }
    }
    
    @IBAction func selectLocation(_ sender: UIButton) {
        let dropDown = DropDown()
        dropDown.anchorView = self.placeTextField
        dropDown.dataSource = viewModel.locationOptions.map { (location) -> String in
            return location.place
        }
        dropDown.cellNib = UINib(nibName: "TemplateOptionCell", bundle: nil)
        dropDown.show()
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.placeTextField.text = item
            self.itemTypeTextField.text = self.viewModel.type
            self.smallTypeTextField.text = self.viewModel.type
            self.viewModel.selectedLocation = self.viewModel.locationOptions[index]
        }
    }
    
    @IBAction func changeTime(_ sender: Any) {
        let dropDown = DropDown()
        dropDown.anchorView = self.movieTimeTextField
        dropDown.dataSource = viewModel.timeOptions.map { (time) -> String in
            return time.time
        }
        dropDown.cellNib = UINib(nibName: "TemplateOptionCell", bundle: nil)
        dropDown.show()
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.movieTimeTextField.text = item
        }
    }
    
    @IBAction func changeDate(_ sender: Any) {
        let dropDown = DropDown()
        dropDown.anchorView = self.dateTextField
        dropDown.dataSource = viewModel.dateOptions.map { (date) -> String in
            return date.date
        }
        dropDown.cellNib = UINib(nibName: "TemplateOptionCell", bundle: nil)
        dropDown.show()
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.dateTextField.text = item
            self.movieDateTextField.text = item
            self.viewModel.selectedDate = self.viewModel.dateOptions[index]
        }
    }
    
    @IBAction func routeToSearch() {
        let sellCreateSearchViewController = SellCreateSearchViewController(nibName: "SellCreateSearchViewController", bundle: nil)
        sellCreateSearchViewController.delegate = self
        self.navigationController?.pushViewController(sellCreateSearchViewController, animated: true)
    }
    
    @IBAction func chooseCollection() {
        routeeToPaymentMethod()
    }
    
    @IBAction func routeToFAQ(_ sender: UIButton) {
        let faqViewController = FAQViewController(nibName: "FAQViewController", bundle: nil)
        navigationController?.pushViewController(faqViewController, animated: true)
    }
    
    @IBAction func routeToDescrionOnlineMethod(_ sender: UIButton) {
        if let delivery = self.viewModel.collectionMethodResponseList.value
            .first(where: { $0.id == sender.tag }){
            let termAndConditionViewController = TermAndConditionViewController()
            termAndConditionViewController.value = delivery.description
            termAndConditionViewController.titleValue = delivery.name
            
            let popupVC = PopupViewController(
                contentController: termAndConditionViewController,
                popupWidth: UIScreen.main.bounds.size.width - 48,
                popupHeight: UIScreen.main.bounds.size.height/2)
            self.present(popupVC, animated: true)
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
    
    func routeeToPaymentMethod() {
        let sellCreatePaymentMethodViewController = SellCreatePaymentMethodViewController(nibName: "SellCreatePaymentMethodViewController", bundle: nil)
        sellCreatePaymentMethodViewController.view.frame.size.width = view.frame.size.width
        sellCreatePaymentMethodViewController.height = 540
        sellCreatePaymentMethodViewController.topCornerRadius = 12
        sellCreatePaymentMethodViewController.shouldDismissInteractivelty = true
        sellCreatePaymentMethodViewController.presentDuration = 0.2
        sellCreatePaymentMethodViewController.dismissDuration = 0.2
        sellCreatePaymentMethodViewController.delegate = self
        present(sellCreatePaymentMethodViewController, animated: true, completion: nil)
    }
}

// MARK: - Private Extension
fileprivate extension SellCreateViewController {
    
    func setupUI() {
        title = "add-item".localized()
        
        for view in self.borderedViews {
            view.layer.borderWidth = 1.0
            view.layer.borderColor = UIColor(hexString: "#D5D5D5").cgColor
        }
        
        descriptionTextView.placeholder = "description".localized()
        descriptionTextView.font = UIFont(name: "Nunito-Bold", size: 12)
        descriptionTextView.contentInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 0)

        confidentialTextView.placeholder = "username, password, website link, extra information".localized()
        confidentialTextView.contentInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 0)
        
        uploadPhotoContainer.layer.borderColor = UIColor(hexString: "#D5D5D5").cgColor
        uploadPhotoContainer.layer.borderWidth = 1.0
        
        for question in questionView {
            question.layer.cornerRadius = 7
            question.clipsToBounds = true
        }
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 16
        layout.itemSize = CGSize(width: 144, height: 144)
        
        collectionView.setCollectionViewLayout(layout, animated: true)
        collectionView.register(UINib(nibName: "LocationPhotoCell", bundle: nil), forCellWithReuseIdentifier: "LocationPhotoCell")
        
        let mainLayout = UICollectionViewFlowLayout()
        mainLayout.scrollDirection = .horizontal
        mainLayout.minimumLineSpacing = 0
        mainLayout.minimumInteritemSpacing = 16
        mainLayout.itemSize = CGSize(width: 144, height: 144)
        
        mainCollectionView.setCollectionViewLayout(mainLayout, animated: true)
        mainCollectionView.register(UINib(nibName: "LocationPhotoCell", bundle: nil), forCellWithReuseIdentifier: "LocationPhotoCell")
    }
    
    func setupLayer() {
        if categoryShadowLayer.superlayer != nil {
            return
        }
        
        let categoryBounds = categoryContainerView.bounds
        categoryShadowLayer.path = UIBezierPath(roundedRect: CGRect(x: categoryBounds.origin.x, y: categoryBounds.origin.y, width: UIScreen.main.bounds.size.width - 40, height: categoryBounds.size.height), cornerRadius: 4).cgPath
        categoryShadowLayer.fillColor = UIColor.white.cgColor
        categoryShadowLayer.shadowColor = UIColor.lightGray.cgColor
        categoryShadowLayer.shadowPath = voucherShadowLayer.path
        categoryShadowLayer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        categoryShadowLayer.shadowOpacity = 0.8
        categoryShadowLayer.shadowRadius = 3
        categoryContainerView.layer.insertSublayer(categoryShadowLayer, at: 0)
        
        if voucherShadowLayer.superlayer != nil {
            return
        }
    }
    
    func setupBinding() {
        yourPriceTextField
            .rx
            .controlEvent([.editingDidEnd])
            .asObservable().subscribe({ [unowned self] _ in
                if let value = self.yourPriceTextField.text {
                    let rawValue = value.removeCurrencyFormat
                    let price = Int(rawValue) ?? 0
                    self.viewModel.yourPrice = price
                    self.yourPriceTextField.text = price.currencyFormat
                    self.viewModel.fetchDetail()
                }
        }).disposed(by: disposeBag)
        
        descriptionTextView
            .rx
            .didEndEditing
            .subscribe({ [unowned self] _ in
                if let value = self.descriptionTextView.text {
                    self.viewModel.description.accept(value)
                }
        }).disposed(by: disposeBag)
        
        quantityTextField
            .rx
            .controlEvent([.editingDidEnd])
            .subscribe({ [unowned self] _ in
                if let value = self.quantityTextField.text {
                    self.viewModel.quantity.accept(value)
                }
        }).disposed(by: disposeBag)
        
        confidentialTextView
            .rx
            .didEndEditing
            .subscribe({ [unowned self] _ in
                if let value = self.confidentialTextView.text {
                    self.viewModel.confidental.accept(value)
                }
        }).disposed(by: disposeBag)
        
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
        
        viewModel.data.subscribe(onNext: { data in
            if let value = data {
                self.placeTextField.text = value.item.place
                self.placeTextField.backgroundColor = .white
                self.dateTextField.text = value.item.date
                self.movieDateTextField.text = value.item.date
                self.dateTextField.backgroundColor = .white
                self.movieTimeTextField.backgroundColor = .white
                self.movieTimeTextField.text = value.item.time
                self.itemTypeTextField.text = data?.types.first?.name
                self.smallTypeTextField.text = data?.types.first?.name
                self.itemTypeButton.isEnabled = true
                
                if let youWillreceive = value.item.youWillReceive {
                    self.youWillReceiveLabel.text = youWillreceive.currencyFormat
                } else {
                    self.youWillReceiveLabel.text = ""
                }
                
                if let adminFee = value.item.adminFee {
                    self.adminFeeLabel.isHidden = false
                    self.adminFeeLabel.text = "Admin Fee - \(adminFee.currencyFormat)"
                } else {
                    self.adminFeeLabel.text = ""
                }
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        
        viewModel.isInvalid.subscribe(onNext: { isInvalid in
            if isInvalid {
                self.showAlert(message: "Form Tidak Lengkap")
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        
        viewModel.collectionMethodResponseList.subscribe(onNext: { data in
            if let keepItem = data.first(where: { $0.id == 3 }),
                keepItem.status == 0 {
                self.keepItemView.isUserInteractionEnabled = false
                self.questionView[1].alpha = 0.2
            }
            
            if let keepItem = data.first(where: { $0.id == 4 }),
                keepItem.status == 0 {
                self.onnlineMethodView.isUserInteractionEnabled = false
                self.questionView[2].alpha = 0.2
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        
        viewModel.photos.bind(to: collectionView.rx.items(cellIdentifier: "LocationPhotoCell", cellType: LocationPhotoCell.self)) { (indexPath, data, cell) in
            cell.data = data
            cell.delegate = self
            cell.tag = 1
        }.disposed(by: disposeBag)
        
        viewModel.mainPhotos.bind(to: mainCollectionView.rx.items(cellIdentifier: "LocationPhotoCell", cellType: LocationPhotoCell.self)) { (indexPath, data, cell) in
            cell.data = data
            cell.delegate = self
            cell.tag = 0
        }.disposed(by: disposeBag)
        
        viewModel.isUploadSuccess.subscribe(onNext: { isSuccess in
            if isSuccess {
                let alertController = UIAlertController(title: "Information", message: "Photo telah diunggah", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
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

// MARK: - UIImagePickerControllerDelegate

extension SellCreateViewController: UIImagePickerControllerDelegate {
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        dismiss(animated: true, completion: nil)
        
        if let image = info[.originalImage] as? UIImage,
            let compressedData = image.compressedData() {
            
            if picker.view.tag == 0 {
                viewModel.uploadPhoto(imageData: compressedData, tag: 0)
            } else {
                viewModel.uploadPhoto(imageData: compressedData, tag: 1)
            }
        }
    }
}

// MARK: - UINavigationControllerDelegate
extension SellCreateViewController: UINavigationControllerDelegate {}

// MARK: - SellCreateSearchViewControllerDelegate

extension SellCreateViewController: SellCreateSearchViewControllerDelegate {
    
    func sellCreateSearchViewController(didSelect sellCreateSearchViewController: SellCreateSearchViewController, data: SellCreateFilterResponse) {
        itemNameLabel.text = data.name
        categoryLabel.text = data.categoryName
        categoryImageView.sd_setImage(
            with: URL(string: data.photoURL),
            placeholderImage: nil,
            options: .refreshCached
        )
        viewModel.selectedCategoryId = data.categoryId
        viewModel.selectedItemCategoryData = data
        viewModel.fetchFilterDetail()
        dateTextField.isHidden = false
        dateButton.isHidden = false
        itemTypeTextField.isHidden = false
        itemTypeButton.isHidden = false
        movieDateTextField.isHidden = true
        movieDateArrowImageView.isHidden = true
        smallTypeArrowImageView.isHidden = true
        smallTypeTextField.isHidden = true
        quantityTextField.isHidden = true
        typeArrowImageView.isHidden = false
        movieTimeTextField.isHidden = true
        movieTimeLabel.isHidden = true
        quantiryLabel.isHidden = true
        viewModel.levelId = data.levelId
        
        switch data.levelId {
        case 1:
            dateLabel.text = "Concert Date"
            
            if !sectionAdded {
                addSection(title: "Barcode")
                sectionAdded = true
            }
            
        case 2:
            dateLabel.text = "Date"
            dateTextField.isHidden = true
            dateButton.isHidden = true
            movieTimeTextField.isHidden = false
            movieTimeLabel.isHidden = false
            movieDateTextField.isHidden = false
            movieDateArrowImageView.isHidden = false
            quantiryLabel.isHidden = false
            quantiryLabel.text = "Studio Number"
            quantityTextField.isHidden = false
            quantityTextField.keyboardType = .default
            quantityTextField.placeholder = "Studio"
            itemTypeTextField.isHidden = true
            itemTypeButton.isHidden = true
            smallTypeTextField.isHidden = false
            smallTypeArrowImageView.isHidden = false
            typeArrowImageView.isHidden = true
            
            if !sectionAdded {
                addSection(title: "Seat")
                sectionAdded = true
            }
            
        case 3:
            dateLabel.text = "Event Date"
            if sectionAdded {
                stackView.removeArrangedSubview(stackView.arrangedSubviews[5])
                sectionAdded = false
            }
            
            dateTextField.isHidden = true
            dateButton.isHidden = true
            movieTimeTextField.isHidden = false
            movieTimeLabel.isHidden = false
            movieDateTextField.isHidden = false
            movieDateArrowImageView.isHidden = false
            
        case 4:
            dateLabel.text = "Validity Until Date"
            itemTypeTextField.isHidden = true
            itemTypeButton.isHidden = true
            smallTypeTextField.isHidden = false
            smallTypeArrowImageView.isHidden = false
            quantityTextField.isHidden = false
            quantityTextField.keyboardType = .numberPad
            quantityTextField.placeholder = "Quantity"
            typeArrowImageView.isHidden = true
            quantiryLabel.isHidden = false
            
            if sectionAdded {
                stackView.removeArrangedSubview(stackView.arrangedSubviews[5])
                sectionAdded = false
            }
            
            
        default:
            dateLabel.text = "Date"
            
            if sectionAdded {
                stackView.removeArrangedSubview(stackView.arrangedSubviews[5])
                sectionAdded = false
            }
        }
    }
    
    func addSection(title: String) {
        let containerView = UIView(frame: .zero)
        
        let titleLabel = UILabel(frame: .zero)
        titleLabel.text = title
        titleLabel.textColor = UIColor(hexString: "#393939")
        titleLabel.font = UIFont(name: "Nunito-ExtraLight", size: 12)
        titleLabel.numberOfLines = 0
        
        containerView.addSubview(titleLabel)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 10
        layout.itemSize = CGSize(width: 54, height: 37)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.register(UINib(nibName: "SellCreateMovieCell", bundle: nil), forCellWithReuseIdentifier: "SellCreateMovieCell")
        collectionView.register(UINib(nibName: "SellCreatePlusCell", bundle: nil), forCellWithReuseIdentifier: "SellCreatePlusCell")
        
        viewModel.multipleValue.bind(to: collectionView.rx.items) { collectionView, index, item in
            switch item {
            case .value(let data):
                let cell: SellCreateMovieCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SellCreateMovieCell", for: IndexPath(row: index, section: 0)) as! SellCreateMovieCell
                cell.value = data
                cell.contentView.tag = index
                cell.delegate = self
                return cell
                
            case .plus:
                let cell: SellCreatePlusCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SellCreatePlusCell", for: IndexPath(row: index, section: 0)) as! SellCreatePlusCell
                cell.delegate = self
                return cell
            }
        }.disposed(by: disposeBag)
        
        containerView.addSubview(collectionView)
        
        viewModel.multipleValue.subscribe(onNext: { multipleValue in
            let withCount = multipleValue.count * 64
            let screenWidth = UIScreen.main.bounds.size.width - 40
            let collectionSize = ((withCount / Int(screenWidth)) + 1) * 42
            
            constrain(containerView, titleLabel, collectionView) { containerView, titleLabel, collectionView in
                titleLabel.top == containerView.top + 14
                collectionView.height == CGFloat(collectionSize)
                collectionView.top == titleLabel.bottom + 5
                collectionView.left == containerView.left + 20
                collectionView.right == containerView.right - 20
                collectionView.bottom == containerView.bottom - 14
                titleLabel.left == containerView.left + 20
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        
        stackView.insertArrangedSubview(containerView, at: 5)
    }
}

// MARK: - LocationPhotoCellDelegate

extension SellCreateViewController: LocationPhotoCellDelegate {
    
    func locationPhotoCell(cell didTapRemove: LocationPhotoCell, data: (Data?, String?, Int)) {
        if didTapRemove.tag == 0 {
            if let index = viewModel.mainPhotos.value.firstIndex(where: { $0 == data }) {
                var photos = viewModel.mainPhotos.value
                photos.remove(at: index)
                viewModel.mainPhotos.accept(photos)
            }
        }
        
        if didTapRemove.tag == 1 {
            if let index = viewModel.photos.value.firstIndex(where: { $0 == data }) {
                var photos = viewModel.photos.value
                photos.remove(at: index)
                viewModel.photos.accept(photos)
            }
        }
    }
}

// MARK: - SellCreatePlusCellDelegate

extension SellCreateViewController: SellCreatePlusCellDelegate {
    
    func sellCreatePlusCell(didSelect cell: SellCreatePlusCell) {
        viewModel.addMultipleValue()
    }
}

// MARK: - SellCreatePlusCellDelegate

extension SellCreateViewController: SellCreatePaymentMethodViewControllerDelegate {
    
    func sellCreatePaymentMethodViewController(sellCreatePaymentMethodViewController didSelect: SellCreatePaymentMethodViewController, id: Int, name: String) {
        collectionMethodLabel.text = name
        viewModel.sellTypeId.accept(id)
        
        confidentialView.isHidden = id != 4
        confidentialViewHeight.constant = id == 4 ? 382 : 0
    }
}

// MARK: - SellCreateMovieCellDelegate

extension SellCreateViewController: SellCreateMovieCellDelegate {
    
    func sellCreateMovieCell(sellCreateMovieCell didFill: SellCreateMovieCell, text: String, index: Int) {
        viewModel.setMultipleValue(value: text, index: index)
    }
}
