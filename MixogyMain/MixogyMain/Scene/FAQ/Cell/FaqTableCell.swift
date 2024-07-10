//
//  FaqTableCell.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 17/10/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import UIKit

class FaqTableCell: UITableViewCell {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var detailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var data: FaqTableCellViewModel? {
        didSet {
            if let value = data {
                titleLabel.text = value.title
                detailLabel.text = value.detail
            }
        }
    }
}
