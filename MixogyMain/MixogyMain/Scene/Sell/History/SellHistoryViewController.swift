//
//  SellHistoryViewController.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 05/04/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import RxCocoa
import RxSwift
import SVProgressHUD
import UIKit

class SellHistoryViewController: MixogyBaseViewController {

    @IBOutlet var tableView: UITableView!
    
    var disposeBag = DisposeBag()
    var viewModel = SellHistoryViewModel()
    
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
    
    override func setupLanguage() {
        title = "sell-history".localized()
    }
    
    func routeToDetail(id: Int?) {
        let sellHistoryDetailViewController = SellHistoryDetailViewController(nibName: "SellHistoryDetailViewController", bundle: nil)
        sellHistoryDetailViewController.viewModel.id = id
        navigationController?.pushViewController(sellHistoryDetailViewController, animated: true)
    }
}

// MARK: - Private Extension

fileprivate extension SellHistoryViewController {
    
    func setupUI() {
        tableView.register(UINib(nibName: "SellHistoryCell", bundle: nil), forCellReuseIdentifier: "SellHistoryCell")
    }
    
    func setupBinding() {
        viewModel.data.bind(to: tableView.rx.items(cellIdentifier: "SellHistoryCell", cellType: SellHistoryCell.self)) { (indexPath, data, cell) in
            cell.data = data
        }.disposed(by: disposeBag)
        
        tableView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
            if let id = self?.viewModel.data.value[indexPath.row].id {
                self?.routeToDetail(id: id)
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
