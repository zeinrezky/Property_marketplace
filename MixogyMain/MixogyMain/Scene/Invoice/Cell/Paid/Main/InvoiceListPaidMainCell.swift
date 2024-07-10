//
//  InvoiceListPaidMainCell.swift
//  MixogyAdmin
//
//  Created by ABDUL AZIS H on 09/02/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import UIKit

class InvoiceListPaidMainCell: UITableViewCell {

    @IBOutlet var containerView: UIView!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var amountLabel: UILabel!
    @IBOutlet var categoryLabel: UILabel!
    @IBOutlet var voucherLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        containerView.layer.cornerRadius = 8
        containerView.layer.borderColor = UIColor(hexString: "#DBDBDB").cgColor
        containerView.layer.borderWidth = 1
        containerView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var data: InvoiceListPaidMainCellViewModel? {
        didSet {
            if let value = data {
                dateLabel.text = value.date
                amountLabel.text = value.amount
                categoryLabel.text = value.itemList
                dateLabel.textColor = value.selected ? UIColor.white : UIColor(hexString: "#8E8E8E")
                categoryLabel.textColor = value.selected ? UIColor.white : UIColor(hexString: "#393939")
                amountLabel.textColor = value.selected ? UIColor.white : UIColor.greenApp
                containerView.backgroundColor = value.selected ? UIColor.greenApp : UIColor.white
                
                let voucherValue = "Payment Voucher No. " + value.voucherCode
                let attributedString = NSMutableAttributedString(
                    string: voucherValue,
                    attributes: [
                        NSAttributedString.Key.foregroundColor: value.selected ? UIColor.white : UIColor(hexString: "#8E8E8E")
                    ]
                )
                
                attributedString.addAttribute(
                    NSAttributedString.Key.foregroundColor,
                    value: value.selected ? UIColor.white : UIColor(hexString: "#393939"),
                    range: (voucherValue as NSString).range(of: value.voucherCode)
                )
                
                voucherLabel.attributedText = attributedString
            }
        }
    }
}
