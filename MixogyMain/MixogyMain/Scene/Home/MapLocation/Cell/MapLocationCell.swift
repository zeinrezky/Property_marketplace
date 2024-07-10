//
//  MapLocationCell.swift
//  MixogyAdmin
//
//  Created by ABDUL AZIS H on 20/02/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import UIKit

class MapLocationCell: UITableViewCell {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var distanceLabel: UILabel!
    @IBOutlet var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        containerView.layer.cornerRadius = 8
        containerView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var data: MapLocationCellViewModel? {
        didSet {
            if let value = data {
                titleLabel.text = value.title
                distanceLabel.text = value.distance
            }
        }
    }
}
