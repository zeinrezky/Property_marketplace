//
//  InvoiceEvidenceViewController.swift
//  MixogyAdmin
//
//  Created by ABDUL AZIS H on 15/02/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import BottomPopup
import RxCocoa
import RxSwift
import SDWebImage
import UIKit

class InvoiceEvidenceViewController: BottomPopupViewController {

    @IBOutlet var topView: UIView!
    @IBOutlet var evidenceImageView: UIImageView!
    
    var height: CGFloat?
    var topCornerRadius: CGFloat?
    var presentDuration: Double?
    var dismissDuration: Double?
    var shouldDismissInteractivelty: Bool?
    
    var disposeBag = DisposeBag()
    var viewModel = InvoiceEvidenceViewModel()
    
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
    
}

// MARK: - Private Extension

extension InvoiceEvidenceViewController {
    
    func setupUI() {
        topView.layer.cornerRadius = 3
        topView.clipsToBounds = true
    }
    
    func setupBinding() {
        viewModel.imageURL.subscribe(onNext: { imageURL in
            if let url = URL(string: imageURL ?? "") {
//                self.evidenceImageView.sd_setImage(
//                    with: url,
//                    placeholderImage: nil,
//                    options: .refreshCached,
//                    context: nil
//                )
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
    }
}
