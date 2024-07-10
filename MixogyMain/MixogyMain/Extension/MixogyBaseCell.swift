//
//  MixogyBaseCell.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 28/10/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import UIKit

class MixogyBaseCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupLanguage()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.methodOfReceivedNotification(notification:)),
            name: Notification.Name(Constants.ChangeLanguageKey),
            object: nil
        )
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setupLanguage() {
        
    }
    
    @objc func methodOfReceivedNotification(notification: Notification) {
        setupLanguage()
    }
}
