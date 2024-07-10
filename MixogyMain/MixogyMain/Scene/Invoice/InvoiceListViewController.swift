//
//  InvoiceListViewController.swift
//  MixogyAdmin
//
//  Created by ABDUL AZIS H on 08/02/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import RxCocoa
import RxSwift
import SVProgressHUD
import UIKit

class InvoiceListViewController: UIViewController {

    @IBOutlet var decoratedButton: [UIButton]!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var headerView: UIView!
    @IBOutlet var totalView: UIView!
    @IBOutlet var totalTitleLabel: UILabel!
    @IBOutlet var totalAmountLabel: UILabel!
    
    var disposeBag = DisposeBag()
    var viewModel = InvoiceListViewModel()
    var shadowLayer: CAShapeLayer?
    
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
}

// MARK: - Private Extension

fileprivate extension InvoiceListViewController {
    
    func setupUI() {
        title = "Transactions"
        
        for button in decoratedButton {
            button.layer.borderColor = UIColor.greenApp.cgColor
            button.layer.borderWidth = 1.0
            button.layer.cornerRadius = 5
            button.rx.tap.subscribe(onNext: {
                self.viewModel.mode.accept(InvoiceListViewModel.InvoiceListViewModelMode(rawValue: button.tag) ?? .pending)
                self.viewModel.fetchData()
            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        }
        
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        tableView.register(UINib(nibName: "InvoiceListPendingCell", bundle: nil), forCellReuseIdentifier: "InvoiceListPendingCell")
        tableView.register(UINib(nibName: "InvoiceListGeneratedCell", bundle: nil), forCellReuseIdentifier: "InvoiceListGeneratedCell")
        tableView.register(UINib(nibName: "InvoiceListPaidMainCell", bundle: nil), forCellReuseIdentifier: "InvoiceListPaidMainCell")
        tableView.register(UINib(nibName: "InvoiceListPaidItemCell", bundle: nil), forCellReuseIdentifier: "InvoiceListPaidItemCell")
        tableView.register(UINib(nibName: "InvoiceListAgentPaidItemCell", bundle: nil), forCellReuseIdentifier: "InvoiceListAgentPaidItemCell")
        tableView.register(UINib(nibName: "InvoiceEvidenceCell", bundle: nil), forCellReuseIdentifier: "InvoiceEvidenceCell")

        let headerShadowLayer = CAShapeLayer()
        headerShadowLayer.path = UIBezierPath(roundedRect: headerView.bounds, cornerRadius: 0).cgPath
        headerShadowLayer.fillColor = UIColor.white.cgColor
        headerShadowLayer.shadowColor = UIColor.black.cgColor
        headerShadowLayer.shadowPath = headerShadowLayer.path
        headerShadowLayer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        headerShadowLayer.shadowOpacity = 0.2
        headerShadowLayer.shadowRadius = 3
        headerView.layer.insertSublayer(headerShadowLayer, at: 0)
        
        totalView.layer.borderColor = UIColor.greenApp.cgColor
        totalView.layer.borderWidth = 1.0
        totalView.layer.cornerRadius = 4
        totalView.clipsToBounds = true
    }
    
    func setupBinding() {
        viewModel
            .mode
            .subscribe(onNext: { mode in
                for button in self.decoratedButton {
                    button.backgroundColor = button.tag == mode.rawValue ? UIColor.greenApp : UIColor.white
                    let titleColor = button.tag == mode.rawValue ? .white : UIColor(hexString: "#8E8E8E")
                    button.setTitleColor(titleColor, for: .normal)
                }
                
                self.totalTitleLabel.text = mode.title
            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        
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
        
        viewModel.data.bind(to: tableView.rx.items) { tableView, index, item in
            switch item {
            case .pending(let data):
                let cell: InvoiceListPendingCell = tableView.dequeueReusableCell(withIdentifier: "InvoiceListPendingCell") as! InvoiceListPendingCell
                cell.data = data
                return cell
                
            case .generated(let data):
                let cell: InvoiceListGeneratedCell = tableView.dequeueReusableCell(withIdentifier: "InvoiceListGeneratedCell") as! InvoiceListGeneratedCell
                cell.data = data
                return cell
                
                
            case .paidMain(let data):
                let cell: InvoiceListPaidMainCell = tableView.dequeueReusableCell(withIdentifier: "InvoiceListPaidMainCell") as! InvoiceListPaidMainCell
                cell.data = data
                return cell
                
            case .paidItem(let data):
                let cell: InvoiceListPaidItemCell = tableView.dequeueReusableCell(withIdentifier: "InvoiceListPaidItemCell") as! InvoiceListPaidItemCell
                cell.data = data
                return cell
                
            case .paidEvidence(let data):
                let cell: InvoiceEvidenceCell = tableView.dequeueReusableCell(withIdentifier: "InvoiceEvidenceCell") as! InvoiceEvidenceCell
                cell.data = data
                cell.delegate = self
                return cell
            }
        }.disposed(by: disposeBag)
        
        viewModel
            .total
            .bind(to: totalAmountLabel.rx.text)
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
        .subscribe(onNext: { [weak self] indexPath in
            self?.viewModel.selectData(index: indexPath.row)
        }).disposed(by: disposeBag)
    }
    
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "informaton".localized(), message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

// MARK: - InvoiceEvidenceCell

extension InvoiceListViewController: InvoiceEvidenceCellDelegate {
    
    func invoiceEvidenceCell(didTappedEvidence invoiceEvidenceCell: InvoiceEvidenceCell, url: String?) {
        let invoiceEvidenceViewController = InvoiceEvidenceViewController(nibName: "InvoiceEvidenceViewController", bundle: nil)
        invoiceEvidenceViewController.view.frame.size.width = view.frame.size.width
        invoiceEvidenceViewController.height = UIScreen.main.bounds.size.height - 100
        invoiceEvidenceViewController.topCornerRadius = 12
        invoiceEvidenceViewController.shouldDismissInteractivelty = true
        invoiceEvidenceViewController.presentDuration = 0.2
        invoiceEvidenceViewController.dismissDuration = 0.2
        invoiceEvidenceViewController.viewModel.imageURL.accept(url)
        present(invoiceEvidenceViewController, animated: true, completion: nil)
    }
}
