//
//  GetHelpViewController.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 18/04/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import UIKit

class GetHelpViewController: UIViewController {

    @IBOutlet var borderedView: [UIView]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
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
    
    func setupUI() {
        title = "Get Help"
        
        for view in borderedView {
            view.layer.borderColor = UIColor(hexString: "#4DD2A7").cgColor
            view.layer.borderWidth = 0.5
        }
    }
    
    @IBAction func routeToFAQ(_ sender: UIButton) {
        let faqViewController = FAQViewController(nibName: "FAQViewController", bundle: nil)
        navigationController?.pushViewController(faqViewController, animated: true)
    }
    
    @IBAction func routeToCall(_ sender: UIButton) {
        let phone = "621123456"
        
        if let url = URL(string: "tel://\(phone)"){
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
}
