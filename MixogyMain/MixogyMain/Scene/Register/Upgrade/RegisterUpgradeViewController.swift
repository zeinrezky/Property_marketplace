//
//  RegisterUpgradeViewController.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 22/04/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import DropDown
import Photos
import RxCocoa
import RxSwift
import SVProgressHUD
import UIKit

class RegisterUpgradeViewController: MixogyBaseViewController {

    @IBOutlet var placeholderTextfields: [UITextField]!
    @IBOutlet var actionButton: [UIButton]!
    @IBOutlet var addressTextfield: UITextField!
    @IBOutlet var bankTextfield: UITextField!
    @IBOutlet var bankNumberTextfield: UITextField!
    @IBOutlet var ktpNumberTextfield: UITextField!
    @IBOutlet var ktpImageButton: UIButton!
    
    var disposeBag = DisposeBag()
    var viewModel = RegisterUpgradeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupBinding()
    }
    
    override func setupLanguage() {
        addressTextfield.placeholder = "address".localized()
        bankNumberTextfield.placeholder = "bank-number".localized()
        ktpNumberTextfield.placeholder = "ktp-number".localized()
        
        ktpImageButton.setTitle("upload-ktp".localized(), for: .normal)
        actionButton[0].setTitle("register".localized(), for: .normal)
        actionButton[1].setTitle("cancel".localized(), for: .normal)
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submit(_ sender: UIButton) {
        viewModel.submit()
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
}

// MARK: - Private Extension

fileprivate extension RegisterUpgradeViewController {
    
    func setupUI() {
        let colorTop = UIColor(hexString: "#2A2A2A").cgColor
        let colorMiddle = UIColor(hexString: "#585858").cgColor
        let colorBottom = UIColor(hexString: "#808080").cgColor

        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorMiddle ,colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = UIScreen.main.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
        
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
    }
    
    func setupBinding() {
        
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
        
        viewModel.errorMessage.subscribe(onNext: { message in
            if let message = message {
                self.showAlert(message: message)
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        
        viewModel.isSuccess.subscribe(onNext: { isSuccess in
            if isSuccess {
                let tutorialViewController = TutorialViewController(
                    transitionStyle: .scroll,
                    navigationOrientation: .horizontal,
                    options: nil
                )
                tutorialViewController.viewModel.mode.accept(.sell)
                tutorialViewController.modalPresentationStyle = .fullScreen
                tutorialViewController.view.tag = 1
                tutorialViewController.pageDelegate = self
                self.present(tutorialViewController, animated: true)
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        
        viewModel.isInvalid.subscribe(onNext: { isInvalid in
            if isInvalid {
                self.showAlert(message: "Form Tidak Lengkap")
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

extension RegisterUpgradeViewController: UIImagePickerControllerDelegate {
    
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
        }
    }
}

// MARK: - UINavigationControllerDelegate

extension RegisterUpgradeViewController: UINavigationControllerDelegate {}

// MARK: - TutorialViewControllerDelegate

extension RegisterUpgradeViewController: TutorialViewControllerDelegate {
    
    func tutorialViewController(didExit tutorialViewController: TutorialViewController) {
        self.navigationController?.popToRootViewController(animated: true)
    }
}
