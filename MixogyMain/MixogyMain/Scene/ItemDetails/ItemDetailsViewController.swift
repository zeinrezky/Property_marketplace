//
//  ItemDetailsViewController.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 07/07/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import RxCocoa
import RxSwift
import SVProgressHUD
import UIKit

class ItemDetailsViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    var disposeBag = DisposeBag()
    var viewModel = ItemDetailsViewModel()
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupBinding()
        
        viewModel.fetchData()
    }
}

// MARK: - Private Extension

fileprivate extension ItemDetailsViewController {
    
    func setupUI() {
        title = "Item Details"
        tableView.register(UINib(nibName: "ItemDetailsCell", bundle: nil), forCellReuseIdentifier: "ItemDetailsCell")
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
        
        viewModel.data.bind(to: tableView.rx.items) { tableView, index, data in
            let cell: ItemDetailsCell = tableView.dequeueReusableCell(withIdentifier: "ItemDetailsCell") as! ItemDetailsCell
            cell.data = data
            return cell
        }.disposed(by: disposeBag)
        
    }
    
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "informaton".localized(), message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
