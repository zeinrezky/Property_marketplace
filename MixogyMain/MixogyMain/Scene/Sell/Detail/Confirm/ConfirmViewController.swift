//
//  ConfirmViewController.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 15/04/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import BottomPopup
import UIKit

protocol ConfirmViewControllerDelegate: class {
    
    func confirmViewController(didTapConfirm confirmViewController: ConfirmViewController)
}

class ConfirmViewController: BottomPopupViewController {

    @IBOutlet var confirmButton: UIButton!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var titleLabel: UILabel!
    
    var height: CGFloat?
    var topCornerRadius: CGFloat?
    var presentDuration: Double?
    var dismissDuration: Double?
    var shouldDismissInteractivelty: Bool?
    
    weak var delegate: ConfirmViewControllerDelegate?
    
    var theTitle = ""
    
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.titleLabel.text = theTitle
    }
    
    @IBAction func cancelDidTapped(sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func confirmDidTapped(sender: UIButton) {
        delegate?.confirmViewController(didTapConfirm: self)
        self.dismiss(animated: true, completion: nil)
    }
    
    func setupUI() {
        confirmButton.layer.cornerRadius = 3
        confirmButton.clipsToBounds = true
        
        cancelButton.layer.borderColor = UIColor.greenApp.cgColor
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.cornerRadius = 3
        cancelButton.clipsToBounds = true
        
        confirmButton.setTitle("confirm".localized(), for: .normal)
        cancelButton.setTitle("cancel".localized(), for: .normal)
    }
}
