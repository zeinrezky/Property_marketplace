//
//  MixogyBaseBottomPopupViewController.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 01/11/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import BottomPopup
import UIKit

class MixogyBaseBottomPopupViewController: BottomPopupViewController {

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
