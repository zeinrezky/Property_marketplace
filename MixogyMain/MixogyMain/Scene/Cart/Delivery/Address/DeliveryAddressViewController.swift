//
//  DeliveryAddressViewController.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 14/03/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import RxCocoa
import RxSwift
import SVProgressHUD
import UIKit

protocol DeliveryAddressViewControllerDelegate: class {
    func deliveryAddressViewController(didSelect deliveryAddressViewController: DeliveryAddressViewController, title: String, id: Int)
}

class DeliveryAddressViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    var disposeBag = DisposeBag()
    var viewModel = DeliveryAddressViewModel()
    weak var delegate: DeliveryAddressViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupBinding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.isHidden = false
        
        viewModel.fetchData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.isNavigationBarHidden = true
        navigationController?.navigationBar.isHidden = true
    }
    
    @objc
    func routeToAddAddress() {
        let deliveryAddressAddViewController = DeliveryAddressAddViewController(nibName: "DeliveryAddressAddViewController", bundle: nil)
        navigationController?.pushViewController(deliveryAddressAddViewController, animated: true)
    }
    
    @objc
    func routeToAddressDetail(id: Int) {
        let deliveryAddressAddViewController = DeliveryAddressAddViewController(nibName: "DeliveryAddressAddViewController", bundle: nil)
        deliveryAddressAddViewController.viewModel.type = .see
        deliveryAddressAddViewController.viewModel.id = id
        deliveryAddressAddViewController.delegate = self
        navigationController?.pushViewController(deliveryAddressAddViewController, animated: true)
    }
}

// MARK: - Private Extension

fileprivate extension DeliveryAddressViewController {
    
    func setupUI() {
        title = "address".localized()
        
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        tableView.register(UINib(nibName: "DeliveryAddressCell", bundle: nil), forCellReuseIdentifier: "DeliveryAddressCell")
        
        let addBarButtonItem = UIBarButtonItem(
            title: "add".localized(),
            style: .plain,
            target: self,
            action: #selector(self.routeToAddAddress)
        )
        
        addBarButtonItem.tintColor = UIColor.greenApp
        navigationItem.rightBarButtonItem = addBarButtonItem
    }
    
    func setupBinding() {
        viewModel.data.bind(to: tableView.rx.items(cellIdentifier: "DeliveryAddressCell", cellType: DeliveryAddressCell.self)) { (_, data: DeliveryAddressCellViewModel, cell) in
            cell.data = data
        }.disposed(by: disposeBag)
        
        tableView.rx.itemSelected
        .subscribe(onNext: { indexPath in
            let id = self.viewModel.data.value[indexPath.row].id
            self.routeToAddressDetail(id: id)
        }).disposed(by: disposeBag)
        
        viewModel.isLoading.subscribe(onNext: { isLoading in
            if isLoading {
                SVProgressHUD.show()
            } else {
                SVProgressHUD.dismiss()
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
    }
}

// MARK: - DeliveryAddressAddViewControllerDelegate

extension DeliveryAddressViewController: DeliveryAddressAddViewControllerDelegate {
    
    func deliveryAddressAddViewController(
        didSelect deliveryAddressAddViewController: DeliveryAddressAddViewController,
        id: Int,
        title: String) {
        self.delegate?.deliveryAddressViewController(
            didSelect: self,
            title: title,
            id: id
        )
        self.navigationController?.popViewController(animated: true)
    }
}
