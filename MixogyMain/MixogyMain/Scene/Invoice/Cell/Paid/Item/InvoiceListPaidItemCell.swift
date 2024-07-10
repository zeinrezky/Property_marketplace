//
//  InvoiceListPaidItemCell.swift
//  MixogyAdmin
//
//  Created by ABDUL AZIS H on 09/02/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import UIKit

class InvoiceListPaidItemCell: UITableViewCell {

    @IBOutlet var containerView: UIView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var amountLabel: UILabel!
    
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
    
    var data: InvoiceListPaidItemCellViewModel? {
        didSet {
            if let value = data {
                nameLabel.text = value.name
                amountLabel.text = value.amount
            }
        }
    }
}
