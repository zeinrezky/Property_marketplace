//
//  CancelReasonViewController.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 25/04/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import BottomPopup
import RxCocoa
import RxSwift
import SVProgressHUD
import UIKit

protocol CancelReasonViewControllerDelegate: class {
    
    func cancelReasonViewController(didTapConfirm cancelReasonViewController: CancelReasonViewController, reasonId: Int, comment: String?)
}

class CancelReasonViewController: MixogyBaseBottomPopupViewController {

    @IBOutlet var commentTextView: UITextView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var confirmButton: UIButton!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var titleLabel: UILabel!
    
    var height: CGFloat?
    var topCornerRadius: CGFloat?
    var presentDuration: Double?
    var dismissDuration: Double?
    var shouldDismissInteractivelty: Bool?
    
    var disposeBag = DisposeBag()
    var viewModel = CancelReasonViewModel()
    
    weak var delegate: CancelReasonViewControllerDelegate?
    
    override func getPopupHeight() -> CGFloat {
        return height ?? CGFloat(141)
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel.fetchData()
    }
    
    override func setupLanguage() {
        cancelButton.setTitle("cancel".localized(), for: .normal)
        confirmButton.setTitle("confirm".localized(), for: .normal)
        titleLabel.text = "reason".localized()
    }
    
    @IBAction func cancelDidTapped(sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func confirmDidTapped(sender: UIButton) {
        guard let reasonId = viewModel.reasonId else {
            return
        }
        
        self.delegate?.cancelReasonViewController(didTapConfirm: self, reasonId: reasonId, comment: viewModel.comment.value)
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - Private Extension

fileprivate extension CancelReasonViewController {

    func setupUI() {
        confirmButton.layer.cornerRadius = 3
        confirmButton.clipsToBounds = true
        
        cancelButton.layer.borderColor = UIColor.greenApp.cgColor
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.cornerRadius = 3
        cancelButton.clipsToBounds = true
        
        commentTextView.layer.cornerRadius = 8
        commentTextView.layer.borderColor = UIColor(hexString: "#B4B4B4").cgColor
        commentTextView.layer.borderWidth = 1.0
        commentTextView.contentInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 0)
        
        tableView.register(UINib(nibName: "CancelReasonCell", bundle: nil), forCellReuseIdentifier: "CancelReasonCell")
    }
    
    func setupBinding() {
        commentTextView
            .rx
            .text
            .bind(to: viewModel.comment)
            .disposed(by: disposeBag)
        
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
        
        viewModel.data.bind(to: tableView.rx.items(cellIdentifier: "CancelReasonCell", cellType: CancelReasonCell.self)) { (_, data: CancelReasonCellViewModel, cell) in
            cell.data = data
        }.disposed(by: disposeBag)
        
        tableView.rx.itemSelected
        .subscribe(onNext: { indexPath in
            self.viewModel.selectReason(index: indexPath.row)
        }).disposed(by: disposeBag)
    }
    
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "informaton".localized(), message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
