//
//  InboxViewController.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 01/03/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class InboxViewController: MixogyBaseViewController {

   @IBOutlet var tableView: UITableView!
    
    var disposeBag = DisposeBag()
    var viewModel = InboxViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupBinding()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel.fetchData()
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
        tabBarItem.title = "inbox".localized()
    }
}

// MARK: - Private Extension

fileprivate extension InboxViewController {
    
    func setupUI() {
        title = "inbox".localized()
        
        tableView.contentInset = UIEdgeInsets(top: 22, left: 0, bottom: 0, right: 0)
        tableView.register(UINib(nibName: "InboxCell", bundle: nil), forCellReuseIdentifier: "InboxCell")
    }
    
    func setupBinding() {
        viewModel.data.bind(to: tableView.rx.items(cellIdentifier: "InboxCell", cellType: InboxCell.self)) { (_, data: InboxCellViewModel, cell) in
            cell.data = data
        }.disposed(by: disposeBag)
    }
}
