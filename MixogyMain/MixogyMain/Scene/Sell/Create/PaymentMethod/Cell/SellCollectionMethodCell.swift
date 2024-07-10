//
//  SellCollectionMethodCell.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 04/04/21.
//  Copyright © 2021 Mixogy. All rights reserved.
//

import UIKit

class SellCollectionMethodCell: UITableViewCell {

    @IBOutlet var availableLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var availableImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
 
    var data: SellCollectionMethodCellViewModel? {
        didSet {
            if let value = data {
                nameLabel.text = value.name
                availableLabel.text = value.status == 1 ? "Available" : "UnAvailable"
                availableImageView.image = UIImage(named: value.status == 1 ? "SellCollectionMethodSelected" : "SellCollectionMethod")
                selectionStyle = value.status == 1 ? .gray : .none
            }
        }
    }
}
