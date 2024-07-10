//
//  ItemLocationDetailHeaderCell.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 20/08/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import UIKit

class ItemLocationDetailHeaderCell: UITableViewCell {

    @IBOutlet var titleView: UIView!
    @IBOutlet var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    var data: ItemLocationDetailHeaderCellViewModel? {
        didSet {
            if let value = data {
                titleView.layer.cornerRadius = 8
                titleView.clipsToBounds = true
                titleLabel.text = value.title
            }
        }
    }
}
