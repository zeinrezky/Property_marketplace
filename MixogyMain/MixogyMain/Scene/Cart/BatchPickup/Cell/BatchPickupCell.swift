//
//  BatchPickupCell.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 14/03/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import UIKit

class BatchPickupCell: MixogyBaseCell {

    @IBOutlet var containerView: UIView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var nameTitleLabel: UILabel!
    @IBOutlet var distanceLabel: UILabel!
    
    let shadowLayer = CAShapeLayer()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        if shadowLayer.superlayer != nil {
            shadowLayer.removeFromSuperlayer()
        }
        
        let bounds = UIScreen.main.bounds
        let containerBounds = containerView.bounds
        
        shadowLayer.path = UIBezierPath(roundedRect: CGRect(x: containerBounds.origin.x, y: containerBounds.origin.y, width: bounds.size.width - 40, height: 56), cornerRadius: 4).cgPath
        shadowLayer.fillColor = UIColor.white.cgColor
        shadowLayer.shadowColor = UIColor.black.cgColor
        shadowLayer.shadowPath = shadowLayer.path
        shadowLayer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        shadowLayer.shadowOpacity = 0.2
        shadowLayer.shadowRadius = 3
        containerView.layer.insertSublayer(shadowLayer, at: 0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func setupLanguage() {
        nameTitleLabel.text = "agent-name".localized()
    }
    
    var data: BatchPickupCellViewModel? {
        didSet {
            if let value = data {
                titleLabel.text = value.title
                distanceLabel.text = value.distance
            }
        }
    }
}
