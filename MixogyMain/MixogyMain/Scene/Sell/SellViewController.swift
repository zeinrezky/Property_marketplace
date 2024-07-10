//
//  SellViewController.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 01/03/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import RxCocoa
import RxSwift
import SVProgressHUD
import UIKit

class SellViewController: MixogyBaseViewController {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var listingLabel: UILabel!
    @IBOutlet var listingTitleLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var paymentStatusLabel: UILabel!
    @IBOutlet var registerLabel: UILabel!
    @IBOutlet var registerTitleLabel: UILabel!
    @IBOutlet var profileButton: UIButton!
    @IBOutlet var historyButton: UIButton!
    @IBOutlet var sellItemButton: UIButton!
    @IBOutlet var registerView: UIView!
    
    @IBOutlet var modeViews: [UIView]!
    @IBOutlet var modeImageViews: [UIImageView]!
    @IBOutlet var modeLabels: [UILabel]!
    
    var disposeBag = DisposeBag()
    var viewModel = SellViewModel()
    var refreshControl = UIRefreshControl()
    var modeTag = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupBinding()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if Preference.profile?.isSeller ?? false || Preference.profile?.roleId ?? 0 == 5 {
            for modeView in self.modeViews {
                modeView.isHidden = false
            }
            
            viewModel.fetchData()
            viewModel.fetchCounter()
            registerView.isHidden = true
            historyButton.isHidden = false
            sellItemButton.isHidden = false
        } else {
            viewModel.data.accept([])
            for modeView in self.modeViews {
                modeView.isHidden = true
            }
            
            historyButton.isHidden = true
            sellItemButton.isHidden = true
            registerView.isHidden = false
        }
        
        if let profile = Preference.profile,
            let url = URL(string: profile.photoURL) {
            profileButton.sd_setBackgroundImage(with: url, for: .normal, placeholderImage: UIImage(named: "DefaultPicture"))
        } else {
            profileButton.setBackgroundImage(UIImage(named: "DefaultPicture"), for: .normal)
        }
    }
    
    override func setupLanguage() {
        tabBarItem.title = "sell-list".localized()
        titleLabel.text = "sell-list".localized()
        listingTitleLabel.text = "listing-tab".localized()
        registerTitleLabel.text = "payment-status".localized()
        registerLabel.text = "register-as-seller".localized()
        sellItemButton.setTitle("sell-item".localized(), for: .normal)
        historyButton.setTitle("see-history".localized(), for: .normal)
    }
    
    @IBAction func changeMode(_ sender: UIButton) {
        viewModel.mode.accept(SellViewModel.SellViewModelMode(rawValue: sender.tag) ?? .listing)
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
    
    @IBAction func routeOurAgent(_ sender: Any) {
        let ourAgentViewController = OurAgentViewController(nibName: "OurAgentViewController", bundle: nil)
        
        navigationController?.pushViewController(ourAgentViewController, animated: true)
    }
    
    @IBAction func routeToHistory(_ sender: UIButton) {
        let sellHistoryViewController = SellHistoryViewController(nibName: "SellHistoryViewController", bundle: nil)
        self.navigationController?.pushViewController(sellHistoryViewController, animated: true)
    }
    
    @IBAction func routeToRegister(_ sender: UIButton) {
        if Preference.auth != nil {
            let registerViewController = RegisterUpgradeViewController(nibName: "RegisterUpgradeViewController", bundle: nil)
            navigationController?.pushViewController(registerViewController, animated: true)
        } else {
            let mapViewController = LoginViewController(nibName: "LoginViewController", bundle: nil)
            navigationController?.pushViewController(mapViewController, animated: true)
        }
    }
    
    func routeToDetail(id: Int?) {
        let sellHistoryDetailViewController = SellHistoryDetailViewController(nibName: "SellHistoryDetailViewController", bundle: nil)
        sellHistoryDetailViewController.viewModel.id = id
        sellHistoryDetailViewController.viewModel.type = .paymentStatus
        navigationController?.pushViewController(sellHistoryDetailViewController, animated: true)
    }
    
    func routeToListingDetail(id: Int?) {
        let listingDetailViewController = ListingDetailViewController(nibName: "ListingDetailViewController", bundle: nil)
        listingDetailViewController.viewModel.id = id
        navigationController?.pushViewController(listingDetailViewController, animated: true)
    }
    
    func routeToGiveToAgentDetail(id: Int?) {
        let giveToAgentViewController = GiveToAgentViewController(nibName: "GiveToAgentViewController", bundle: nil)
        giveToAgentViewController.viewModel.id = id
        navigationController?.pushViewController(giveToAgentViewController, animated: true)
    }
    
    func routeToCancelListingDetail(id: Int?) {
        let cancelListingDetailViewController = CancelListingDetailViewController(nibName: "CancelListingDetailViewController", bundle: nil)
        cancelListingDetailViewController.viewModel.id = id
        navigationController?.pushViewController(cancelListingDetailViewController, animated: true)
    }
    
    func routeToOnHandDetail(id: Int?) {
        let cancelListingDetailViewController = CancelListingDetailViewController(nibName: "CancelListingDetailViewController", bundle: nil)
        cancelListingDetailViewController.viewModel.id = id
        navigationController?.pushViewController(cancelListingDetailViewController, animated: true)
    }
    
    func routeToSendItem(id: Int?) {
        let sendItemViewController = SendItemViewController(nibName: "SendItemViewController", bundle: nil)
        sendItemViewController.viewModel.id = id
        navigationController?.pushViewController(sendItemViewController, animated: true)
    }
    
    @IBAction func routeToSellItem(_ sender: UIButton) {
        let sellCreateViewController = SellCreateViewController(nibName: "SellCreateViewController", bundle: nil)
        navigationController?.pushViewController(sellCreateViewController, animated: true)
    }
}

// MARK: - Private Extension

fileprivate extension SellViewController {
    
    func setupUI() {
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 32, right: 0)
        tableView.register(UINib(nibName: "SellCell", bundle: nil), forCellReuseIdentifier: "SellCell")
        
        profileButton.layer.cornerRadius = 17
        profileButton.layer.borderWidth = 1
        profileButton.layer.borderColor = UIColor.white.cgColor
        profileButton.clipsToBounds = true
        
        historyButton.layer.cornerRadius = 7
        historyButton.layer.borderColor = UIColor.white.cgColor
        historyButton.layer.borderWidth = 1
        
        sellItemButton.layer.cornerRadius = 7
        sellItemButton.layer.borderColor = UIColor.white.cgColor
        sellItemButton.layer.borderWidth = 1
        
        registerView.layer.cornerRadius = 12
        registerView.clipsToBounds = true
        
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    func setupBinding() {
        viewModel
            .status
            .bind(to: paymentStatusLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel
            .list
            .bind(to: listingLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.isLoading.subscribe(onNext: { isLoading in
            self.refreshControl.endRefreshing()
            
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
            let cell: SellCell = tableView.dequeueReusableCell(withIdentifier: "SellCell") as! SellCell
            cell.data = data
            return cell
        }.disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { indexPath in
                let id = self.viewModel.data.value[indexPath.row].id
                let statusId = self.viewModel.data.value[indexPath.row].statusId
                
                let statusType: SellStatus = SellStatus(rawValue: statusId) ?? .giveToAgent
                
                switch self.viewModel.mode.value {
                case .listing:
                    switch statusType {
                    case .cancelListing:
                        self.routeToCancelListingDetail(id: id)
                        
                    case .listingOnAgent:
                        self.routeToListingDetail(id: id)
                        
                    case .giveToAgent:
                        self.routeToGiveToAgentDetail(id: id)
                        
                    case .sendItem, .onDelivery:
                        self.routeToSendItem(id: id)
                        
                    default:
                        break
                    }
                case .status:
                    self.routeToDetail(id: id)
                }
        }).disposed(by: disposeBag)
        
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
            
            if Preference.profile?.isSeller ?? false || Preference.profile?.roleId ?? 0 == 5 {
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
    
    @objc
    func refresh(_ sender: AnyObject) {
        viewModel.mode.accept(SellViewModel.SellViewModelMode(rawValue: modeTag) ?? .listing)
    }
}
