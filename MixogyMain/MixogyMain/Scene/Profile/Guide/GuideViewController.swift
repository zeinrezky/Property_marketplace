//
//  GuideViewController.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 09/09/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import UIKit

class GuideViewController: MixogyBaseViewController {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var desc1Label: UILabel!
    @IBOutlet var desc2Label: UILabel!
    @IBOutlet var buyButton: UIButton!
    @IBOutlet var sellButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupBuyLayer()
        setupSellLayer()
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
    
    override func setupLanguage() {
        desc1Label.text = "you-worry".localized()
        desc2Label.text = "here-some-guide".localized()
        
        sellButton.setTitle("how-to-sell-items".localized(), for: .normal)
        buyButton.setTitle("how-to-buy-items".localized(), for: .normal)
    }
    
    @IBAction func routeToBuyTutorial(_ sender: UIButton) {
        let tutorialViewController = TutorialViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal,
            options: nil
        )
        tutorialViewController.viewModel.mode.accept(.buy)
        navigationController?.pushViewController(tutorialViewController, animated: true)
    }
    
    @IBAction func routeToSellTutorial(_ sender: UIButton) {
        let tutorialViewController = TutorialViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal,
            options: nil
        )
        tutorialViewController.viewModel.mode.accept(.sell)
        navigationController?.pushViewController(tutorialViewController, animated: true)
    }
}

// MARK: - Private Extensionn

extension GuideViewController {
    
    func setupUI() {
        title = "Guides"
    }
    
    func setupBuyLayer() {
        var bounds = buyButton.bounds
        bounds.size.width = UIScreen.main.bounds.size.width - 100
        let shadowLayer = CAShapeLayer()
        shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: 9).cgPath
        shadowLayer.fillColor = UIColor.white.cgColor
        shadowLayer.shadowColor = UIColor.black.cgColor
        shadowLayer.shadowPath = shadowLayer.path
        shadowLayer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        shadowLayer.shadowOpacity = 0.2
        shadowLayer.shadowRadius = 3
        buyButton.layer.insertSublayer(shadowLayer, at: 0)
    }
    
    func setupSellLayer() {
        var bounds = sellButton.bounds
        bounds.size.width = UIScreen.main.bounds.size.width - 100
        let shadowLayer = CAShapeLayer()
        shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: 9).cgPath
        shadowLayer.fillColor = UIColor.white.cgColor
        shadowLayer.shadowColor = UIColor.black.cgColor
        shadowLayer.shadowPath = shadowLayer.path
        shadowLayer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        shadowLayer.shadowOpacity = 0.2
        shadowLayer.shadowRadius = 3
        sellButton.layer.insertSublayer(shadowLayer, at: 0)
    }
}
