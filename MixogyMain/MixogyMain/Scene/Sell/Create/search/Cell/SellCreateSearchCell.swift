//
//  SellCreateSearchCell.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 17/01/21.
//  Copyright © 2021 Mixogy. All rights reserved.
//

import UIKit

class SellCreateSearchCell: UITableViewCell {

    @IBOutlet var coverImageView: UIImageView!
    @IBOutlet var categoryLabel: UILabel!
    @IBOutlet var namelabel: UILabel!
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if shadowLayer.superlayer != nil {
            shadowLayer.removeFromSuperlayer()
        }
        
        var bounds = containerView.bounds
        bounds.size.width = UIScreen.main.bounds.size.width - 40
        shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: 4).cgPath
        shadowLayer.fillColor = UIColor.white.cgColor
        shadowLayer.shadowColor = UIColor.black.cgColor
        shadowLayer.shadowPath = shadowLayer.path
        shadowLayer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        shadowLayer.shadowOpacity = 0.2
        shadowLayer.shadowRadius = 3
        containerView.layer.insertSublayer(shadowLayer, at: 0)
    }
    
    var data: SellCreateSearchCellViewModel? {
        didSet {
            if let value = data {
                coverImageView.sd_setImage(
                    with: URL(string: value.photo ?? ""),
                    placeholderImage: nil,
                    options: .refreshCached
                )
                
                categoryLabel.text = value.category
                namelabel.text = value.name
                layoutSubviews()
            }
        }
    }
}
