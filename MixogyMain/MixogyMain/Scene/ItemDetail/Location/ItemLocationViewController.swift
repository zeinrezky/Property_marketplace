//
//  ItemLocationViewController.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 19/08/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import RxCocoa
import RxSwift
import SVProgressHUD
import UIKit

class ItemLocationViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    var disposeBag = DisposeBag()
    var viewModel = ItemLocationViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupBinding()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel.fetchData()
    }
    
    @IBAction func back(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - ItemDetailViewController

extension ItemLocationViewController {
    
    func setupUI() {
        tableView.register(UINib(nibName: "ItemLocationHeaderCell", bundle: nil), forCellReuseIdentifier: "ItemLocationHeaderCell")
        
        tableView.register(UINib(nibName: "ItemLocationInfoCell", bundle: nil), forCellReuseIdentifier: "ItemLocationInfoCell")
        
        tableView.register(UINib(nibName: "ItemLocationTimeCell", bundle: nil), forCellReuseIdentifier: "ItemLocationTimeCell")
    }
    
    func setupBinding() {
        viewModel.isLoading.subscribe(onNext: { isLoading in
            if isLoading {
                SVProgressHUD.show()
            } else {
                SVProgressHUD.dismiss()
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        
        viewModel.data.bind(to: tableView.rx.items) { tableView, index, item in
            switch item {
            case .header(let data):
                let cell: ItemLocationHeaderCell = tableView.dequeueReusableCell(withIdentifier: "ItemLocationHeaderCell") as! ItemLocationHeaderCell
                cell.data = data
                return cell
            
            case .info(let data):
                let cell: ItemLocationInfoCell = tableView.dequeueReusableCell(withIdentifier: "ItemLocationInfoCell") as! ItemLocationInfoCell
                cell.data = data
                cell.delegate = self
                return cell
                
            case .time(let data):
                let cell: ItemLocationTimeCell = tableView.dequeueReusableCell(withIdentifier: "ItemLocationTimeCell") as! ItemLocationTimeCell
                cell.data = data
                cell.delegate = self
                return cell
                
            }
        }.disposed(by: disposeBag)
        
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
        self.present(alertController, animated: true, completion: nil)
    }
}

// MARK: - ItemLocationInfoCellDelegate

extension ItemLocationViewController: ItemLocationInfoCellDelegate {
    
    func itemLocationInfoCell(didSelect itemLocationInfoCell: ItemLocationInfoCell, index: Int) {
        if viewModel.levelId ?? 0 == 4 {
            if let data = viewModel.serverData.value, let itemId = data.collections[itemLocationInfoCell.contentView.tag].dates.first?.times.first?.types.first?.itemId {
                let itemDetailViewController = ItemDetailViewController(nibName: "ItemDetailViewController", bundle: nil)
                itemDetailViewController.viewModel.id = itemId
                itemDetailViewController.hidesBottomBarWhenPushed = false
                navigationController?.pushViewController(itemDetailViewController, animated: true)
            }
            return
        }
        
        viewModel.selectData(index: itemLocationInfoCell.contentView.tag)
    }
}

// MARK: - ItemLocationTimeCellDelegate

extension ItemLocationViewController: ItemLocationTimeCellDelegate {
    
    func itemLocationTimeCell(didSelect itemLocationTimeCell: ItemLocationTimeCell, source: ItemLocationCollectionDateResponse) {
        let itemLocationDetailViewController = ItemLocationDetailViewController(nibName: "ItemLocationDetailViewController", bundle: nil)
        itemLocationDetailViewController.view.frame.size.width = view.frame.size.width
        itemLocationDetailViewController.height = UIScreen.main.bounds.size.height - 100
        itemLocationDetailViewController.topCornerRadius = 12
        itemLocationDetailViewController.shouldDismissInteractivelty = true
        itemLocationDetailViewController.presentDuration = 0.2
        itemLocationDetailViewController.dismissDuration = 0.2
        itemLocationDetailViewController.viewModel.sourceData.accept(source)
        itemLocationDetailViewController.delegate = self
        present(itemLocationDetailViewController, animated: true, completion: nil)
    }
}

// MARK: - ItemLocationDetailViewControllerDelegate

extension ItemLocationViewController: ItemLocationDetailViewControllerDelegate {
    
    func itemLocationDetailViewController(didSelect itemLocationDetailViewController: ItemLocationDetailViewController, id: Int) {
        let itemDetailViewController = ItemDetailViewController(nibName: "ItemDetailViewController", bundle: nil)
        itemDetailViewController.viewModel.id = id
        itemDetailViewController.hidesBottomBarWhenPushed = false
        navigationController?.pushViewController(itemDetailViewController, animated: true)
    }
}
