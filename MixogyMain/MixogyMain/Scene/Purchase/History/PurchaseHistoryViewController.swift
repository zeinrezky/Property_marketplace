//
//  PurchaseHistoryViewController.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 30/03/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import RxCocoa
import RxSwift
import SVProgressHUD
import UIKit

class PurchaseHistoryViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    var disposeBag = DisposeBag()
    var viewModel = PurchaseHistoryViewModel()
    
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
        
        if isMovingToParent {
            navigationController?.popToRootViewController(animated: true)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel.fetchData()
    }
    
    func routeToMyPurchaseDetail(id: Int?) {
        let purchaseHistoryDetailViewController = PurchaseHistoryDetailViewController(nibName: "PurchaseHistoryDetailViewController", bundle: nil)
        purchaseHistoryDetailViewController.viewModel.id = id
        navigationController?.pushViewController(purchaseHistoryDetailViewController, animated: true)
    }
}

// MARK: - Private Extension

fileprivate extension PurchaseHistoryViewController {
    
    func setupUI() {
        title = "History"
        tableView.register(UINib(nibName: "PurchaseHistoryCell", bundle: nil), forCellReuseIdentifier: "PurchaseHistoryCell")
    }
    
    func setupBinding() {
        viewModel.data.bind(to: tableView.rx.items(cellIdentifier: "PurchaseHistoryCell", cellType: PurchaseHistoryCell.self)) { (indexPath, data, cell) in
            cell.data = data
        }.disposed(by: disposeBag)
        
        tableView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
            if let id = self?.viewModel.data.value[indexPath.row].id {
                self?.routeToMyPurchaseDetail(id: id)
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
    }
    
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "informaton".localized(), message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
