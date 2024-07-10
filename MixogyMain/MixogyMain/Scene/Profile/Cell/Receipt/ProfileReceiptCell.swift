//
//  ProfileReceiptCell.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 22/03/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import UIKit

class ProfileReceiptCell: MixogyBaseCell {

    @IBOutlet var containerView: UIView!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var amountLabel: UILabel!
    @IBOutlet var paymentReceiveLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func setupLanguage() {
        paymentReceiveLabel.text = "profile-payment-receive".localized()
    }
    
    func setupUI() {
        containerView.layer.cornerRadius = 12
        containerView.layer.borderColor = UIColor(hexString: "#21A99B").cgColor
        containerView.layer.borderWidth = 1
    }
    
    var data: ProfilePaymentReceiveRespoonse? {
        didSet {
            if let value = data,
                let amount = value.amount,
                let date = value.date {
                amountLabel.text = amount.currencyFormat
                dateLabel.text = date
            }
        }
    }
}
