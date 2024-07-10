//
//  ItemLocationHeaderCell.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 19/08/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import UIKit

class ItemLocationHeaderCell: UITableViewCell {

    @IBOutlet var coverImageView: UIImageView!
    @IBOutlet var categoryLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var containerView: UIVisualEffectView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        containerView.layer.cornerRadius = 4
        containerView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
 
    var data: ItemLocationHeaderCellViewModel? {
        didSet {
            if let value = data {
                coverImageView.sd_setImage(
                    with: URL(string: value.photoURL ?? ""),
                    placeholderImage: nil,
                    options: .refreshCached
                )
                
                categoryLabel.text = value.category
                nameLabel.text = value.name
            }
        }
    }
}
