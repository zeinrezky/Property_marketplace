//
//  SuggestionViewController.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 25/04/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import RxCocoa
import RxSwift
import SVProgressHUD
import UIKit
import UITextView_Placeholder

class SuggestionViewController: UIViewController {

    @IBOutlet var borderedViews: [UIView]!
    @IBOutlet var itemNameTextField: UITextField!
    @IBOutlet var descriptionTextView: UITextView!
    
    var disposeBag = DisposeBag()
    var viewModel = SuggestionViewModel()
    
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
    }
    
    @IBAction func submmitDidTapped(_ sender: UIButton) {
        viewModel.submit()
    }
}

// MARK: - SuggestionViewController

fileprivate extension SuggestionViewController {
    
    func setupUI () {
        title = "Suggestion"
        
        for view in self.borderedViews {
            view.layer.borderWidth = 1.0
            view.layer.borderColor = UIColor(hexString: "#D5D5D5").cgColor
        }
        descriptionTextView.placeholder = "Description"
        descriptionTextView.contentInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 0)
    }
    
    func setupBinding() {
        itemNameTextField
            .rx
            .text
            .bind(to: viewModel.name)
            .disposed(by: disposeBag)
        
        descriptionTextView
            .rx
            .text
            .bind(to: viewModel.description)
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
        
        viewModel.isSuccess.subscribe(onNext: { isSuccess in
            if isSuccess {
                let alertController = UIAlertController(title: "informaton".localized(), message: "data-saved".localized(), preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                    self.navigationController?.popViewController(animated: true)
                }
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        
        viewModel.isInvalid.subscribe(onNext: { isInvalid in
            if isInvalid {
                self.showAlert(message: "Form Tidak Lengkap")
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
