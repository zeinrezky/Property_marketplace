//
//  RegisterViewController.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 05/03/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import EzPopup
import DropDown
import Photos
import RxCocoa
import RxSwift
import SKCountryPicker
import SVProgressHUD
import UIKit

class RegisterViewController: MixogyBaseViewController {

    @IBOutlet var countryImageView: UIImageView!
    @IBOutlet var countryLabel: UILabel!
    @IBOutlet var countryView: UIView!
    @IBOutlet var placeholderTextfields: [UITextField]!
    @IBOutlet var switcher: UISwitch!
    @IBOutlet var topHeight: NSLayoutConstraint!
    @IBOutlet var bottomViews: [UIView]!
    @IBOutlet var actionButton: [UIButton]!
    @IBOutlet var fullnameTextfield: UITextField!
    @IBOutlet var phoneNumberTextfield: UITextField!
    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var addressTextfield: UITextField!
    @IBOutlet var bankTextfield: UITextField!
    @IBOutlet var bankNumberTextfield: UITextField!
    @IBOutlet var ktpNumberTextfield: UITextField!
    @IBOutlet var ktpImageButton: UIButton!
    @IBOutlet var registerButton: UIButton!
    @IBOutlet var agreeButton: UIButton!
    @IBOutlet var acceptImageView: UIImageView!
    @IBOutlet var acceptView: UIView!
    
    var disposeBag = DisposeBag()
    var viewModel = RegisterViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupBinding()
        switcher.isOn = false
        for bottomView in self.bottomViews {
            bottomView.isHidden = true
        }
        self.topHeight.constant = 360
    }
    
    override func setupLanguage() {
        fullnameTextfield.placeholder = "full-name".localized()
        phoneNumberTextfield.placeholder = "phone-number".localized()
        addressTextfield.placeholder = "address".localized()
        bankNumberTextfield.placeholder = "bank-number".localized()
        ktpNumberTextfield.placeholder = "ktp-number".localized()
        
        ktpImageButton.setTitle("upload-ktp".localized(), for: .normal)
        agreeButton.setTitle("i-agree-term".localized(), for: .normal)
        actionButton[0].setTitle("register".localized(), for: .normal)
        actionButton[1].setTitle("cancel".localized(), for: .normal)
    }
    
    @IBAction func countryCodeButtonClicked(_ sender: UIButton) {
        let countryController = CountryPickerWithSectionViewController.presentController(on: self) { (country: Country) in
            self.countryImageView.image = country.flag
            self.countryLabel.text = country.dialingCode
            self.viewModel.countryCode.accept(country.dialingCode)
        }

        countryController.detailColor = UIColor.red
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submit(_ sender: UIButton) {
        viewModel.submit()
    }
    
    @IBAction func changePhoto() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = false
        
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
    
    @IBAction func selectBank(_ sender: UIButton) {
        viewModel.fetchBank { bankList in
            let dropDown = DropDown()
            dropDown.anchorView = self.bankNumberTextfield
            dropDown.dataSource = bankList
            dropDown.cellNib = UINib(nibName: "TemplateOptionCell", bundle: nil)
            dropDown.show()
            dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                self.bankTextfield.text = item
                self.viewModel.bank.accept(item)
            }
        }
    }
    
    @IBAction func accept(_ sender: UIButton) {
        acceptImageView.tag = acceptImageView.tag == 0 ? 1 : 0
        acceptImageView.isHidden = acceptImageView.tag == 0
        registerButton.backgroundColor = acceptImageView.tag == 0 ? UIColor(hexString: "D2D2D2") : UIColor.greenApp
        registerButton.setTitleColor(acceptImageView.tag == 0 ? UIColor(hexString: "393939") : UIColor.white, for: .normal)
        registerButton.isUserInteractionEnabled = acceptImageView.tag == 1
    }
    
    func routeToOTP() {
        let otpViewController = OTPViewController(nibName: "OTPViewController", bundle: nil)
        otpViewController.viewModel.type = .register(viewModel.registerRequest)
        navigationController?.pushViewController(otpViewController, animated: true)
    }
    
    @IBAction func termsAndConditionDidtap(_ sender: UIButton) {
        viewModel.fetchTermsAndCondition { value in
            let termAndConditionViewController = TermAndConditionViewController()
            termAndConditionViewController.value = value
            
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
            DispatchQueue.main.async {
                UIApplication.shared.openURL(settingsURL)
            }
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

fileprivate extension RegisterViewController {
    
    func setupUI() {
        let colorTop = UIColor(hexString: "#2A2A2A").cgColor
        let colorMiddle = UIColor(hexString: "#585858").cgColor
        let colorBottom = UIColor(hexString: "#808080").cgColor

        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorMiddle ,colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = UIScreen.main.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        if let country = CountryManager.shared.currentCountry {
            countryLabel.text = country.dialingCode
            countryImageView.image = country.flag
            viewModel.countryCode.accept(country.dialingCode)
        }
        
        countryView.layer.cornerRadius = 5
        
        let placeholderColor = UIColor(hexString: "#D2D2D2")
        
        for placeholderTextfield in placeholderTextfields {
            placeholderTextfield.tintColor = .white
            placeholderTextfield.attributedPlaceholder = NSAttributedString(
                string: placeholderTextfield.placeholder ?? "",
                attributes: [NSAttributedString.Key.foregroundColor: placeholderColor]
            )
        }
        
        for actionButton in actionButton {
            actionButton.layer.cornerRadius = 5
        }
        
        acceptView.layer.cornerRadius = 5
        acceptView.layer.borderWidth = 1
        acceptView.layer.borderColor = UIColor.white.cgColor
        acceptImageView.image = acceptImageView.image?.withRenderingMode(.alwaysTemplate)
        acceptImageView.tintColor = .white
    }
    
    func setupBinding() {
        fullnameTextfield
            .rx
            .text
            .bind(to: viewModel.name)
            .disposed(by: disposeBag)
        
        phoneNumberTextfield
            .rx
            .text
            .bind(to: viewModel.phoneNumber)
            .disposed(by: disposeBag)
        
        addressTextfield
            .rx
            .text
            .bind(to: viewModel.address)
            .disposed(by: disposeBag)
        
        bankTextfield
            .rx
            .text
            .bind(to: viewModel.bank)
            .disposed(by: disposeBag)
        
        emailTextfield
            .rx
            .text
            .bind(to: viewModel.email)
            .disposed(by: disposeBag)
        
        bankNumberTextfield
            .rx
            .text
            .bind(to: viewModel.bankNumber)
            .disposed(by: disposeBag)
        
        ktpNumberTextfield
            .rx
            .text
            .bind(to: viewModel.ktpNumber)
            .disposed(by: disposeBag)
        
        switcher
            .rx
            .isOn
            .changed
            .distinctUntilChanged()
            .asObservable()
            .subscribe(onNext: { isOn in
                self.view.endEditing(true)
                
                for bottomView in self.bottomViews {
                    bottomView.isHidden = !isOn
                }
                
                if isOn {
                    self.topHeight.constant = 584
                } else {
                    self.topHeight.constant = 360
                }
                
                self.viewModel.isSeller.accept(isOn)
            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        
        viewModel.errorMessage.subscribe(onNext: { message in
            if let message = message {
                self.showAlert(message: message)
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        
        viewModel.isSuccess.subscribe(onNext: { isSuccess in
            if isSuccess {
                self.routeToOTP()
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        
        viewModel.isInvalid.subscribe(onNext: { isInvalid in
            if isInvalid {
                self.showAlert(message: "Form Tidak Lengkap")
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        
        viewModel.isEmailInvalid.subscribe(onNext: { isInvalid in
            if isInvalid {
                self.showAlert(message: "Format Email Salah")
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        
        viewModel.isLoading.subscribe(onNext: { isLoading in
            if isLoading {
                SVProgressHUD.show()
            } else {
                SVProgressHUD.dismiss()
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

// MARK: - UIImagePickerControllerDelegate

extension RegisterViewController: UIImagePickerControllerDelegate {
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        dismiss(animated: true, completion: nil)
        
        if let image = info[.originalImage] as? UIImage,
            let compressedData = image.compressedData() {
            viewModel.ktpImage.accept(compressedData.base64EncodedString())
            ktpImageButton.setBackgroundImage(image, for: .normal)
            ktpImageButton.setTitle("", for: .normal)
            ktpImageButton.layoutIfNeeded()
            ktpImageButton.subviews.first?.contentMode = .scaleAspectFill
        }
    }
}

// MARK: - UINavigationControllerDelegate
extension RegisterViewController: UINavigationControllerDelegate {}
