//
//  ProfileViewController.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 21/03/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import Photos
import RxCocoa
import RxSwift
import SVProgressHUD
import UIKit

class ProfileViewController: MixogyBaseViewController {
    
    @IBOutlet var tableView: UITableView!
    
    var disposeBag = DisposeBag()
    var viewModel = ProfileViewModel()
    var shadowLayer: CAShapeLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupBinding()
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel.fetchData()
    }
    
    override func setupLanguage() {
        title = "profile".localized()
    }
}

// MARK: - Private Extensionn

extension ProfileViewController {
    
    func setupUI() {
        tableView.register(UINib(nibName: "ProfileInfoCell", bundle: nil), forCellReuseIdentifier: "ProfileInfoCell")
        tableView.register(UINib(nibName: "ProfileAddressCell", bundle: nil), forCellReuseIdentifier: "ProfileAddressCell")
        tableView.register(UINib(nibName: "ProfileAddressTitleCell", bundle: nil), forCellReuseIdentifier: "ProfileAddressTitleCell")
        tableView.register(UINib(nibName: "ProfileReceiptCell", bundle: nil), forCellReuseIdentifier: "ProfileReceiptCell")
        tableView.register(UINib(nibName: "ProfileTransactionCell", bundle: nil), forCellReuseIdentifier: "ProfileTransactionCell")
        tableView.register(UINib(nibName: "ProfileSettingCell", bundle: nil), forCellReuseIdentifier: "ProfileSettingCell")
    }
    
    func setupBinding() {
        viewModel.data.bind(to: tableView.rx.items) { tableView, index, item in
            switch item {
            case .info(let data):
                let cell: ProfileInfoCell = tableView.dequeueReusableCell(withIdentifier: "ProfileInfoCell") as! ProfileInfoCell
                cell.data = data
                cell.delegate = self
                return cell
                
            case .addressTitle:
                let cell: ProfileAddressTitleCell = tableView.dequeueReusableCell(withIdentifier: "ProfileAddressTitleCell") as! ProfileAddressTitleCell
                cell.delegate = self
                return cell
                
            case .address(let data):
                let cell: ProfileAddressCell = tableView.dequeueReusableCell(withIdentifier: "ProfileAddressCell") as! ProfileAddressCell
                cell.data = data
                cell.delegate = self
                return cell
                
            case .receipt(let data):
                let cell: ProfileReceiptCell = tableView.dequeueReusableCell(withIdentifier: "ProfileReceiptCell") as! ProfileReceiptCell
                cell.data = data
                return cell
                
            case .transaction:
                let cell: ProfileTransactionCell = tableView.dequeueReusableCell(withIdentifier: "ProfileTransactionCell") as! ProfileTransactionCell
                cell.delegate = self
                return cell
                
            case .setting(let radius):
                let cell: ProfileSettingCell = tableView.dequeueReusableCell(withIdentifier: "ProfileSettingCell") as! ProfileSettingCell
                cell.delegate = self
                cell.radius = radius
                return cell
            }
        }.disposed(by: disposeBag)
        
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
                self.showAlert(message: "data-saved".localized())
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
    }
    
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "informaton".localized(), message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
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

// MARK: - UIImagePickerControllerDelegate

extension ProfileViewController: UIImagePickerControllerDelegate {
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        dismiss(animated: true, completion: nil)
        
        if let image = info[.originalImage] as? UIImage,
            let compressedData = image.compressedData() {
            viewModel.photo = compressedData.base64EncodedString()
            viewModel.editPhoto()
        }
    }
}

// MARK: - UINavigationControllerDelegate
extension ProfileViewController: UINavigationControllerDelegate {}

// MARK: - ProfileInfoCellDelegate
extension ProfileViewController: ProfileInfoCellDelegate {
    
    func profileInfoCell(profileInfoCell didTapCamera: ProfileInfoCell) {
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
}

// MARK: - ProfileInfoCellDelegate
extension ProfileViewController: ProfileAddressTitleCellDelegate {
    
    func profileAddressTitleCell(didTappAdd profileAddressTitleCell: ProfileAddressTitleCell) {
        let deliveryAddressAddViewController = DeliveryAddressAddViewController(nibName: "DeliveryAddressAddViewController", bundle: nil)
        navigationController?.pushViewController(deliveryAddressAddViewController, animated: true)
    }
}

// MARK: - ProfileInfoCellDelegate
extension ProfileViewController: ProfileAddressCellDelegate {
    
    func profileAddressCell(didTapEdit cell: ProfileAddressCell, id: Int) {
        let deliveryAddressAddViewController = DeliveryAddressAddViewController(nibName: "DeliveryAddressAddViewController", bundle: nil)
        deliveryAddressAddViewController.viewModel.type = .edit
        deliveryAddressAddViewController.viewModel.id = id
        navigationController?.pushViewController(deliveryAddressAddViewController, animated: true)
    }
}

// MARK: - ProfileViewController

extension ProfileViewController: ProfileSettingCellDelegate {
    
    func profileSettingCell(didChangeRadius profileSettingCell: ProfileSettingCell, radius: Int) {
        viewModel.radius = radius
        viewModel.editRadius()
    }
    
    func profileSettingCell(didLogout profileSettingCell: ProfileSettingCell) {
        let loginController = LoginViewController(nibName: "LoginViewController", bundle: nil)
        loginController.view.tag = 1
        navigationController?.pushViewController(loginController, animated: true)
        viewModel.logout()
    }
    
    func profileSettingCell(didChangePassword profileSettingCell: ProfileSettingCell) {
        let changePasswordViewController = ChangePasswordViewController(nibName: "ChangePasswordViewController", bundle: nil)
        navigationController?.pushViewController(changePasswordViewController, animated: true)
    }
    
    func profileSettingCell(didOpenGuide profileSettingCell: ProfileSettingCell) {
        let guideViewController = GuideViewController(nibName: "GuideViewController", bundle: nil)
        navigationController?.pushViewController(guideViewController, animated: true)
    }
}

// MARK: - ProfileViewController

extension ProfileViewController: ProfileTransactionCellDelegate {
    
    func profileTransactionCell(didTap cell: ProfileTransactionCell) {
        let invoiceListViewController = InvoiceListViewController(nibName: "InvoiceListViewController", bundle: nil)
        navigationController?.pushViewController(invoiceListViewController, animated: true)
    }
}
