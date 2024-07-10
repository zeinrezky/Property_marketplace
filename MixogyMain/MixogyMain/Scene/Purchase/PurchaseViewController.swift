//
//  PurchaseViewController.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 01/03/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import RxCocoa
import RxSwift
import SVProgressHUD
import UIKit

class PurchaseViewController: MixogyBaseViewController {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var myPurchaseLabel: UILabel!
    @IBOutlet var pendingLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var profileButton: UIButton!
    @IBOutlet var historyButton: UIButton!
    
    @IBOutlet var modeViews: [UIView]!
    @IBOutlet var modeImageViews: [UIImageView]!
    @IBOutlet var modeLabels: [UILabel]!
    
    var disposeBag = DisposeBag()
    var viewModel = PurchaseViewModel()
    var refreshControl = UIRefreshControl()
    var modeTag = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupBinding()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if Preference.auth != nil {
            viewModel.fetchData()
            viewModel.fetchPendingDataCounter()
            historyButton.isHidden = false
        } else {
            viewModel.data.accept([])
        }
        
        if let profile = Preference.profile,
            let url = URL(string: profile.photoURL) {
            profileButton.sd_setBackgroundImage(with: url, for: .normal, placeholderImage: UIImage(named: "DefaultPicture"))
        } else {
            profileButton.setBackgroundImage(UIImage(named: "DefaultPicture"), for: .normal)
        }
    }
    
    @IBAction func changeMode(_ sender: UIButton) {
        viewModel.mode.accept(PurchaseViewModel.PurchaseViewModelMode(rawValue: sender.tag) ?? .myPurchase)
        modeTag = sender.tag
    }
    
    @IBAction func routeProfile(_ sender: Any) {
        if Preference.auth != nil {
            let profileViewController = ProfileViewController(nibName: "ProfileViewController", bundle: nil)
            navigationController?.pushViewController(profileViewController, animated: true)
        } else {
            let mapViewController = LoginViewController(nibName: "LoginViewController", bundle: nil)
            navigationController?.pushViewController(mapViewController, animated: true)
        }
    }
    
    override func setupLanguage() {
        tabBarItem.title = "purchases".localized()
        titleLabel.text = "purchases".localized()
        modeLabels[0].text = "my-purchase".localized()
        modeLabels[1].text = "pending-payment".localized()
        historyButton.setTitle("see-history".localized(), for: .normal)
    }
    
    func routeToMyPurchaseDetail(id: Int?) {
        let myPurchaseViewController = MyPurchaseViewController(nibName: "MyPurchaseViewController", bundle: nil)
        myPurchaseViewController.viewModel.id = id
        navigationController?.pushViewController(myPurchaseViewController, animated: true)
    }
    
    func routeToWaitingDetail(id: Int?) {
        let requestWaitingViewController = RequestWaitingViewController(nibName: "RequestWaitingViewController", bundle: nil)
        requestWaitingViewController.viewModel.id = id
        navigationController?.pushViewController(requestWaitingViewController, animated: true)
    }
    
    func routeToRedeem(id: Int?) {
        let redeemViewController = RedeemViewController(nibName: "RedeemViewController", bundle: nil)
        redeemViewController.viewModel.id = id
        navigationController?.pushViewController(redeemViewController, animated: true)
    }
    
    func routeToRedeemed(id: Int?) {
        let redeemViewController = RedeemViewController(nibName: "RedeemViewController", bundle: nil)
        redeemViewController.viewModel.id = id
        redeemViewController.viewModel.isRedeemed.accept(true)
        redeemViewController.view.tag = 1
        navigationController?.pushViewController(redeemViewController, animated: true)
    }
    
    func routeToPurchaseDeliveryDetail(id: Int?) {
        let purchaseDeliveryViewController = PurchaseDeliveryViewController(nibName: "PurchaseDeliveryViewController", bundle: nil)
        purchaseDeliveryViewController.viewModel.id = id
        navigationController?.pushViewController(purchaseDeliveryViewController, animated: true)
    }
    
    func routeToGraceOnlineDetail(id: Int?) {
        let onlineGraceViewController = OnlineGraceViewController(nibName: "OnlineGraceViewController", bundle: nil)
        onlineGraceViewController.viewModel.id = id
        navigationController?.pushViewController(onlineGraceViewController, animated: true)
    }
}


// MARK: - PurchaseViewController

fileprivate extension PurchaseViewController {
    
    func setupUI() {
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 32, right: 0)
        tableView.register(UINib(nibName: "PurchaseCell", bundle: nil), forCellReuseIdentifier: "PurchaseCell")
        tableView.register(UINib(nibName: "PendingPurchaseCell", bundle: nil), forCellReuseIdentifier: "PendingPurchaseCell")
        
        profileButton.layer.cornerRadius = 17
        profileButton.layer.borderWidth = 1
        profileButton.layer.borderColor = UIColor.white.cgColor
        profileButton.clipsToBounds = true
        
        historyButton.layer.cornerRadius = 7
        historyButton.layer.borderColor = UIColor.white.cgColor
        historyButton.layer.borderWidth = 1
        
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    func setupBinding() {
        viewModel
            .myPurchase
            .bind(to: myPurchaseLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel
            .pending
            .bind(to: pendingLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.isLoading.subscribe(onNext: { isLoading in
            if isLoading {
                SVProgressHUD.show()
            } else {
                self.refreshControl.endRefreshing()
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
            case .myPurchase(let data):
                let cell: PurchaseCell = tableView.dequeueReusableCell(withIdentifier: "PurchaseCell") as! PurchaseCell
                cell.data = data
                cell.delegate = self
                return cell
                
            case .pending(let data):
                let cell: PendingPurchaseCell = tableView.dequeueReusableCell(withIdentifier: "PendingPurchaseCell") as! PendingPurchaseCell
                cell.data = data
                cell.delegate = self
                return cell
            }
        }.disposed(by: disposeBag)
        
        viewModel.mode.subscribe(onNext: { mode in
            for modeView in self.modeViews {
                modeView.layer.borderColor = UIColor.white.cgColor
                modeView.layer.borderWidth = 1
                modeView.layer.cornerRadius = 7
                modeView.backgroundColor = modeView.tag == mode.rawValue ? .white : .clear
            }
            
            for modeLabel in self.modeLabels {
                modeLabel.textColor = modeLabel.tag == mode.rawValue ? .lightGray : .white
            }
            
            for modeImageView in self.modeImageViews {
                modeImageView.image = modeImageView.image?.withRenderingMode(.alwaysTemplate)
                modeImageView.tintColor = modeImageView.tag == mode.rawValue ? .lightGray : .white
            }
            
            if Preference.auth != nil {
                self.viewModel.fetchData()
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
    }
    
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "informaton".localized(), message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func routeToHistory(_ sender: UIButton) {
        let purchaseHistoryViewController = PurchaseHistoryViewController(nibName: "PurchaseHistoryViewController", bundle: nil)
        self.navigationController?.pushViewController(purchaseHistoryViewController, animated: true)
    }
    
    @objc
    func refresh(_ sender: AnyObject) {
        viewModel.mode.accept(PurchaseViewModel.PurchaseViewModelMode(rawValue: modeTag) ?? .myPurchase)
    }
}

// MARK: - PurchaseCellDelegate

extension PurchaseViewController: PurchaseCellDelegate {
    
    func purchaseCell(didTap purchaseCell: PurchaseCell, id: Int, status: String, statusId: Int) {
        
        switch statusId {
        case 10:
            if status == "Redeemed " {
                routeToRedeemed(id: id)
            } else {
                routeToMyPurchaseDetail(id: id)
            }
            
        case 13:
            routeToPurchaseDeliveryDetail(id: id)
            
        case 11:
            if status == "Ready to Redeem " {
                routeToRedeem(id: id)
            } else {
                routeToWaitingDetail(id: id)
            }
            
        case 12, 14:
            routeToWaitingDetail(id: id)
            
        case 18:
            routeToGraceOnlineDetail(id: id)
            
        default:
            break
        }
    }
}

// MARK: - PendingPurchaseCellDelegate

extension PurchaseViewController: PendingPurchaseCellDelegate {
    
    func pendingPurchaseCell(
        didTap pendingPurchaseCell: PendingPurchaseCell,
        id: Int,
        amount: Int,
        orderId: String,
        vaNumber: String?,
        detail: String?,
        isGopay: Bool,
        qrURL: String?,
        paymentURL: String?) {
        
        if let vaNumber = vaNumber, let detail = detail {
            let paymentCreatedViewController = PaymentCreatedViewController(nibName: "PaymentCreatedViewController", bundle: nil)
            paymentCreatedViewController.viewModel.amount = amount
            paymentCreatedViewController.viewModel.vaNumber = vaNumber
            paymentCreatedViewController.viewModel.detail = detail
            paymentCreatedViewController.viewModel.id = id
            paymentCreatedViewController.viewModel.transactionCode = id
            
            self.navigationController?.pushViewController(paymentCreatedViewController, animated: true)
        } else if isGopay {
            let gopayViewController = GopayViewController(nibName: "GopayViewController", bundle: nil)
            gopayViewController.viewModel.amount = amount
            gopayViewController.viewModel.id = id
            gopayViewController.viewModel.qrURL = qrURL ?? ""
            gopayViewController.viewModel.gopayURL = paymentURL ?? ""
            gopayViewController.viewModel.transactionCode = id
            self.navigationController?.pushViewController(gopayViewController, animated: true)
        } else {
            let paymentMethodViewController = PaymentMethodViewController(nibName: "PaymentMethodViewController", bundle: nil)
            paymentMethodViewController.viewModel.amount = amount
            paymentMethodViewController.viewModel.transactionCode = orderId
            paymentMethodViewController.viewModel.transactionId = id
            paymentMethodViewController.viewModel.orderid = id
            self.navigationController?.pushViewController(paymentMethodViewController, animated: true)
        }
    }
}
