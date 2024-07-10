//
//  SellCreateSearchViewController.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 16/01/21.
//  Copyright © 2021 Mixogy. All rights reserved.
//

import RxCocoa
import RxSwift
import SVProgressHUD
import UIKit

protocol SellCreateSearchViewControllerDelegate: class {
    func sellCreateSearchViewController(didSelect sellCreateSearchViewController: SellCreateSearchViewController, data: SellCreateFilterResponse)
}

class SellCreateSearchViewController: UIViewController {

    @IBOutlet var containerView: UIView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchTextfield: UITextField!
    
    var shadowLayer = CAShapeLayer()
    var viewModel = SellCreateSearchViewModel()
    var disposeBag = DisposeBag()
    weak var delegate: SellCreateSearchViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupBinding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.isHidden = false
        
        self.viewModel.fetchItemCategory()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.isNavigationBarHidden = true
        navigationController?.navigationBar.isHidden = true
    }
    
    @objc
    @IBAction func routeToSuggestion(_ sender: UIButton) {
        let suggestionViewController = SuggestionViewController(nibName: "SuggestionViewController", bundle: nil)
        self.navigationController?.pushViewController(suggestionViewController, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        shadowLayer.path = UIBezierPath(roundedRect: containerView.bounds, cornerRadius: 0).cgPath
        shadowLayer.fillColor = UIColor.white.cgColor
        shadowLayer.shadowColor = UIColor.black.cgColor
        shadowLayer.shadowPath = shadowLayer.path
        shadowLayer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        shadowLayer.shadowOpacity = 0.2
        containerView.layer.insertSublayer(shadowLayer, at: 0)
    }
}

extension SellCreateSearchViewController {
    
    func setupUI() {
        title = "Search Sellable Item"
        
        let helpBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "Help"),
            style: .plain,
            target: self,
            action: #selector(self.routeToSuggestion(_:)))
        
        helpBarButtonItem.tintColor = .greenApp
        
        navigationItem.rightBarButtonItem = helpBarButtonItem
        let navigationBar = navigationController!.navigationBar
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 32, right: 0)
        tableView.register(UINib(nibName: "SellCreateSearchCell", bundle: nil), forCellReuseIdentifier: "SellCreateSearchCell")
    }
    
    func setupBinding() {
        searchTextfield
            .rx
            .controlEvent([.editingChanged])
            .asObservable().subscribe({ [unowned self] textfield in
            self.viewModel.keywords.accept(self.searchTextfield.text)
            self.viewModel.fetchItemCategory()
        }).disposed(by: disposeBag)
        
        viewModel.isLoading.subscribe(onNext: { isLoading in
            if isLoading {
                SVProgressHUD.show()
            } else {
                SVProgressHUD.dismiss()
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        
        viewModel.data.bind(to: tableView.rx.items) { tableView, index, data in
            let cell: SellCreateSearchCell = tableView.dequeueReusableCell(withIdentifier: "SellCreateSearchCell") as! SellCreateSearchCell
            cell.data = data
            return cell
        }.disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { indexPath in
                self.delegate?.sellCreateSearchViewController(didSelect: self, data: self.viewModel.itemCategoryData[indexPath.row])
                self.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)
    }
}
