//
//  RateAgentViewController.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 22/10/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import BottomPopup
import RxCocoa
import RxSwift
import SVProgressHUD
import UIKit

protocol RateAgentViewControllerDelegate: class {
    func rateAgentViewController(didSuccess rateAgentViewController: RateAgentViewController)
}

class RateAgentViewController: MixogyBaseBottomPopupViewController {

    @IBOutlet var ratingView: [UIView]!
    @IBOutlet var ratingImages: [UIImageView]!
    @IBOutlet var descriptionTextView: UITextView!
    @IBOutlet var submitButton: UIButton!
    @IBOutlet var titleLabel: UILabel!
    
    var height: CGFloat?
    var topCornerRadius: CGFloat?
    var presentDuration: Double?
    var dismissDuration: Double?
    var shouldDismissInteractivelty: Bool?
    
    var disposeBag = DisposeBag()
    var viewModel = RateAgentViewModel()
    weak var delegate: RateAgentViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupBinding()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        delegate?.rateAgentViewController(didSuccess: self)
    }
    
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
    
    override func setupLanguage() {
        titleLabel.text = "rate-our-agent".localized()
        submitButton.setTitle("submit".localized(), for: .normal)
    }
    
    @IBAction func selectRate(_ sender: UIButton) {
        viewModel.rating = sender.tag + 1
        resetRate()
    }
}

// MARK: - Private Extension

fileprivate extension RateAgentViewController {
    
    func setupUI() {
        for ratingViews in ratingView {
            ratingViews.layer.borderColor = UIColor.greenApp.cgColor
            ratingViews.layer.borderWidth = 1
            let fullWidth = ((UIScreen.main.bounds.size.width - 32) / 5) - 14
            ratingViews.layer.cornerRadius = fullWidth / 2
            ratingViews.clipsToBounds = true
        }
        
        for ratingImage in ratingImages {
            ratingImage.image = ratingImage.image?.withRenderingMode(.alwaysTemplate)
            ratingImage.tintColor = UIColor(hexString: "#D2D2D2")
        }
        
        descriptionTextView.layer.borderWidth = 1.0
        descriptionTextView.layer.borderColor = UIColor(hexString: "#D5D5D5").cgColor
        descriptionTextView.contentInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 0)
    }
    
    func setupBinding() {
        descriptionTextView
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
        
        viewModel.isSuccess.subscribe(onNext: { isSuccess in
            if isSuccess {
                let alertController = UIAlertController(title: "informaton".localized(), message: "data-saved".localized(), preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                    self.delegate?.rateAgentViewController(didSuccess: self)
                    self.dismiss(animated: true, completion: nil)
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
        
        submitButton.rx.tap.subscribe(onNext: {
            self.viewModel.submit()
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
    }
    
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "informaton".localized(), message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func resetRate() {
        for ratingImage in ratingImages {
            ratingImage.image = ratingImage.image?.withRenderingMode(.alwaysTemplate)
            ratingImage.tintColor =  UIColor(hexString: ratingImage.tag < viewModel.rating ?? 0 ? "#038465" : "#D2D2D2")
        }
        
        for ratingViews in ratingView {
            ratingViews.backgroundColor =  UIColor(hexString: ratingViews.tag < viewModel.rating ?? 0 ? "#4DD2A7" : "#FFF")
        }
    }
}
