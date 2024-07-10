//
//  MixogyBaseViewController.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 28/10/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import UIKit

class MixogyBaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLanguage()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.methodOfReceivedNotification(notification:)),
            name: Notification.Name(Constants.ChangeLanguageKey),
            object: nil
        )
    }

    func setupLanguage() {
        
    }
    
    @objc func methodOfReceivedNotification(notification: Notification) {
        setupLanguage()
    }
}
