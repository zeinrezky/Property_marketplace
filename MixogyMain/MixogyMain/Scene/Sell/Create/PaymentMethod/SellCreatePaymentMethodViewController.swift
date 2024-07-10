//
//  SellCreatePaymentMethodViewController.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 04/04/21.
//  Copyright © 2021 Mixogy. All rights reserved.
//

import BottomPopup
import RxSwift
import RxCocoa
import SVProgressHUD
import UIKit

protocol SellCreatePaymentMethodViewControllerDelegate: class {
    func sellCreatePaymentMethodViewController(sellCreatePaymentMethodViewController didSelect: SellCreatePaymentMethodViewController, id: Int, name: String)
}

class SellCreatePaymentMethodViewController: BottomPopupViewController {

    @IBOutlet var topView: UIView!
    @IBOutlet var questionView: UIView!
    @IBOutlet var tableView: UITableView!
    
    var height: CGFloat?
    var topCornerRadius: CGFloat?
    var presentDuration: Double?
    var dismissDuration: Double?
    var shouldDismissInteractivelty: Bool?
    
    var disposeBag = DisposeBag()
    var viewModel = SellCreatePaymentMethodViewModel()
    weak var delegate: SellCreatePaymentMethodViewControllerDelegate?
    
    override func getPopupHeight() -> CGFloat {
        return height ?? CGFloat(UIScreen.main.bounds.size.height - 100)
    }
    
    override func getPopupTopCornerRadius() -> CGFloat {
        return topCornerRadius ?? CGFloat(12)
    }
    
    override func getPopupPresentDuration() -> Double {
        return presentDuration ?? 1.0
    }
    
    override func getPopupDismissDuration() -> Double {
        return dismissDuration ?? 1.0
    }
    
    override func shouldPopupDismissInteractivelty() -> Bool {
        return shouldDismissInteractivelty ?? true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupBinding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.fetchData()
    }
    
    @IBAction func selectData(_ sender: UIButton) {
        guard let selectedData = viewModel.selectedData else {
            return
        }
        
        delegate?.sellCreatePaymentMethodViewController(sellCreatePaymentMethodViewController: self, id: selectedData.0, name: selectedData.1)
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Private Extension

extension SellCreatePaymentMethodViewController {
    
    func setupUI() {
        questionView.layer.cornerRadius = 7
        questionView.clipsToBounds = true
        
        topView.layer.cornerRadius = 3
        topView.clipsToBounds = true
        
        tableView.register(UINib(nibName: "SellCollectionMethodCell", bundle: nil), forCellReuseIdentifier: "SellCollectionMethodCell")
    }
    
    func setupBinding() {
        viewModel.data.bind(to: tableView.rx.items(cellIdentifier: "SellCollectionMethodCell", cellType: SellCollectionMethodCell.self)) { (indexPath, data, cell) in
            cell.data = data
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
        
        tableView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
            if let data = self?.viewModel.data.value[indexPath.row] {
                if data.status == 1 {
                    self?.viewModel.selectedData = (data.id, data.name)
                } else {
                    self?.viewModel.selectedData = nil
                }
            }
        }).disposed(by: disposeBag)
    }
    
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "informaton".localized(), message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
