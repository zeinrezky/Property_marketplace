//
//  BatchPickupViewController.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 14/03/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import CoreLocation
import RxCocoa
import RxSwift
import SVProgressHUD
import UIKit

protocol BatchPickupViewControllerDelegate: class {
    func batchPickupViewController(didSelect batchPickupViewController: BatchPickupViewController, title: String, id: Int)
}

class BatchPickupViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    var disposeBag = DisposeBag()
    var viewModel = BatchPickupViewModel()
    var delegate: BatchPickupViewControllerDelegate?
    
    let locationManager = CLLocationManager()
    
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
}

// MARK: - Private Extension

fileprivate extension BatchPickupViewController {
    
    func setupUI() {
        title = "select-pickup-location".localized()
        
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        tableView.register(UINib(nibName: "BatchPickupCell", bundle: nil), forCellReuseIdentifier: "BatchPickupCell")
        
        locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    func setupBinding() {
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
        
        viewModel.data.bind(to: tableView.rx.items(cellIdentifier: "BatchPickupCell", cellType: BatchPickupCell.self)) { (_, data: BatchPickupCellViewModel, cell) in
            cell.data = data
        }.disposed(by: disposeBag)
        
        tableView.rx.itemSelected
        .subscribe(onNext: { indexPath in
            let id = self.viewModel.data.value[indexPath.row].id
            let title = self.viewModel.data.value[indexPath.row].title
            self.delegate?.batchPickupViewController(
                didSelect: self,
                title: title,
                id: id
            )
            self.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)
    }
    
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "informaton".localized(), message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}

// MARK: - CLLocationManagerDelegate

extension BatchPickupViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let value: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        viewModel.userCoordinate = value
        viewModel.fetchData()
        
        if Preference.auth != nil {
            viewModel.fetchData()
        }
        
        locationManager.stopUpdatingLocation()
    }
}
