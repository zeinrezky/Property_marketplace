//
//  ItemDetailsCell.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 07/07/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import UIKit

class ItemDetailsCell: UITableViewCell {

    @IBOutlet var coverImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var seatLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var containerView: UIView!
    
    let shadowLayer = CAShapeLayer()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var data: ItemDetailsCellViewModel? {
        didSet {
            if let value = data {
                coverImageView.sd_setImage(
                    with: URL(string: value.photoURL ?? ""),
                    placeholderImage: nil,
                    options: .refreshCached
                )
                
                titleLabel.text = value.title
                locationLabel.text = value.location
                dateLabel.text = value.date
                seatLabel.text = value.seat
                priceLabel.text = value.price
            }
        }
    }
}
