//
//  DeliveryAddressAddViewController.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 17/03/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import CoreLocation
import DropDown
import RxCocoa
import RxSwift
import SVProgressHUD
import UIKit
import UITextView_Placeholder

protocol DeliveryAddressAddViewControllerDelegate: class {
    func deliveryAddressAddViewController(didSelect deliveryAddressAddViewController: DeliveryAddressAddViewController, id: Int, title: String)
}

class DeliveryAddressAddViewController: MixogyBaseViewController {

    @IBOutlet var borderedView: [UIView]!
    @IBOutlet var addressTextView: UITextView!
    @IBOutlet var codeTextField: UITextField!
    @IBOutlet var phoneTextField: UITextField!
    @IBOutlet var placeNameLabel: UILabel!
    @IBOutlet var provinceTextField: UITextField!
    @IBOutlet var cityTextField: UITextField!
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var cancelButton: UIButton!
    
    @IBOutlet var editableTextField: [UIView]!
    
    var disposeBag = DisposeBag()
    var viewModel = DeliveryAddressAddViewModel()
    var shadowLayer: CAShapeLayer?
    
    weak var delegate: DeliveryAddressAddViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupBinding()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        switch viewModel.type {
        case .add:
            title = "add-address".localized()
            saveButton.setTitle("add".localized(), for: .normal)
            
        case .edit:
            title = "edit-address".localized()
            saveButton.setTitle("save".localized(), for: .normal)
            viewModel.fetchData()
            
        case .see:
            title = "detail-address".localized()
            saveButton.setTitle("select".localized(), for: .normal)
            viewModel.fetchData()
            
            for textfield in editableTextField {
                textfield.isUserInteractionEnabled = false
            }
        }
        
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
        cancelButton.setTitle("cancel".localized(), for: .normal)
        phoneTextField.placeholder = "phone-number".localized()
        provinceTextField.placeholder = "province".localized()
        cityTextField.placeholder = "city".localized()
    }
    
    @IBAction func provinceDidTapped(_ sender: Any) {
        viewModel.fetchProvince()
    }
    
    @IBAction func cityDidTapped(_ sender: Any) {
        viewModel.fetchCity()
    }
    
    @IBAction func submitDidTapped(_ sender: Any) {
        switch viewModel.type {
        case .see:
            guard let data = viewModel.data.value else {
                return
            }
            
            delegate?.deliveryAddressAddViewController(didSelect: self, id: data.id, title: data.code)
            navigationController?.popViewController(animated: true)
            
        default:
            viewModel.submit()
        }
    }
    
    @IBAction func cancelDidtapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func routeToMapLocation(_ sender: Any) {
        let mapViewController = MapViewController(nibName: "MapViewController", bundle: nil)
        mapViewController.delegate = self
        navigationController?.pushViewController(mapViewController, animated: true)
    }
}

// MARK: - Private Extension

fileprivate extension DeliveryAddressAddViewController {
    
    func setupUI() {
        for view in borderedView {
            view.layer.borderColor = UIColor(hexString: "#D5D5D5").cgColor
            view.layer.borderWidth = 1.0
        }
        
        addressTextView.placeholder = "address".localized()
        placeNameLabel.text = "choose-location".localized()
    }
    
    func setupBinding() {
        codeTextField
            .rx
            .text
            .bind(to: viewModel.code).disposed(by: disposeBag)
        
        phoneTextField
            .rx
            .text
            .bind(to: viewModel.phoneNumber).disposed(by: disposeBag)
        
        addressTextView
            .rx
            .text
            .bind(to: viewModel.detail).disposed(by: disposeBag)
        
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
        
        viewModel.provinceData.subscribe(onNext: { data in
            if !data.isEmpty {
                let dropDown = DropDown()
                dropDown.anchorView = self.provinceTextField
                dropDown.dataSource = data.map { (province) -> String in
                    return province.province
                }
                dropDown.cellNib = UINib(nibName: "TemplateOptionCell", bundle: nil)
                dropDown.show()
                dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                    self.provinceTextField.text = item
                    self.viewModel.provinceId = data[index].id
                }
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        
        viewModel.cityData.subscribe(onNext: { data in
            if !data.isEmpty {
                let dropDown = DropDown()
                dropDown.anchorView = self.cityTextField
                dropDown.dataSource = data.map { (city) -> String in
                    return city.city
                }
                dropDown.cellNib = UINib(nibName: "TemplateOptionCell", bundle: nil)
                dropDown.show()
                dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                    self.cityTextField.text = item
                    self.viewModel.cityId = data[index].id
                }
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
                self.codeTextField.text = value.code
                self.phoneTextField.text = value.phone
                self.placeNameLabel.text = value.placeName
                self.provinceTextField.text = value.provinceName
                self.cityTextField.text = value.cityName
                self.addressTextView.text = value.detail
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
    }
    
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "informaton".localized(), message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func setupLayer() {
        guard shadowLayer == nil else {
            return
        }
        
        let bounds = CGRect(
            x: saveButton.bounds.origin.x,
            y: saveButton.bounds.origin.y,
            width: view.frame.size.width - 40,
            height: 43
        )
        
        let bounds2 = CGRect(
            x: cancelButton.bounds.origin.x,
            y: cancelButton.bounds.origin.y,
            width: view.frame.size.width - 40,
            height: 43
        )
        
        let shadowLayer = CAShapeLayer()
        shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: 9).cgPath
        shadowLayer.fillColor = UIColor.white.cgColor
        shadowLayer.shadowColor = UIColor.black.cgColor
        shadowLayer.shadowPath = shadowLayer.path
        shadowLayer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        shadowLayer.shadowOpacity = 0.2
        shadowLayer.shadowRadius = 9
        saveButton.layer.insertSublayer(shadowLayer, at: 0)
        
        let shadowLayer2 = CAShapeLayer()
        shadowLayer2.path = UIBezierPath(roundedRect: bounds2, cornerRadius: 9).cgPath
        shadowLayer2.fillColor = UIColor.white.cgColor
        shadowLayer2.shadowColor = UIColor.black.cgColor
        shadowLayer2.shadowPath = shadowLayer2.path
        shadowLayer2.shadowOffset = CGSize(width: 0.0, height: 1.0)
        shadowLayer2.shadowOpacity = 0.2
        shadowLayer2.shadowRadius = 9
        cancelButton.layer.insertSublayer(shadowLayer2, at: 0)
        
        self.shadowLayer = shadowLayer
    }
}

// MARK: - MapViewControllerDelegate

extension DeliveryAddressAddViewController: MapViewControllerDelegate {
    
    func mapViewController(mapViewController didFinish: MapViewController, addressName: String, lattitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        placeNameLabel.text = addressName
        viewModel.lattitude = "\(lattitude)"
        viewModel.longitude = "\(longitude)"
        viewModel.placeName = addressName
    }
}
