//
//  OnBoardingViewController.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 28/02/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import UIKit

class OnBoardingViewController: UIViewController {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var beforeLabel: UILabel!
    @IBOutlet var afterLabel: UILabel!
    @IBOutlet var swipeView: UIView!
    @IBOutlet var chevron: UIImageView!
    @IBOutlet var beforeMarginLeft: NSLayoutConstraint!
    @IBOutlet var afterMarginLeft: NSLayoutConstraint!
    
    var categorytitle: String?
    var categoryAfterTitle: String?
    var categoryBeforeTitle: String?
    
    var isSwpeHide: Bool = false {
        didSet {
            swipeView.isHidden = isSwpeHide
        }
    }
    
    var hideBefore: Bool = false {
        didSet {
            beforeLabel.isHidden = hideBefore
        }
    }
    
    var hideTitle: Bool = false {
        didSet {
            titleLabel.isHidden = hideTitle
        }
    }
    
    var hideAfter: Bool = false {
        didSet {
            afterLabel.isHidden = hideAfter
        }
    }
    
    var beforeOpacity: CGFloat = 0.0 {
        didSet {
            beforeLabel.alpha = beforeOpacity
        }
    }
    
    var afterOpacity: CGFloat = 0.0 {
        didSet {
            afterLabel.alpha = afterOpacity
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        titleLabel.text = categorytitle
        afterLabel.text = categoryAfterTitle
        beforeLabel.text = categoryBeforeTitle
        titleLabel.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        afterLabel.isHidden = false
        beforeLabel.isHidden = false
        beforeLabel.alpha = 0.5
        afterLabel.alpha = 0.5
        titleLabel.isHidden = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        swipeView.isHidden = true
    }
}

// MARK: - OnBoardingViewController

fileprivate extension OnBoardingViewController {
    
    func setupUI() {
        swipeView.isHidden = isSwpeHide
        chevron.image = chevron.image?.withRenderingMode(.alwaysTemplate)
        chevron.tintColor = .white
    }
}
