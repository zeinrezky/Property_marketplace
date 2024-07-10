//
//  PendingPurchaseCell.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 24/03/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import UIKit

protocol PendingPurchaseCellDelegate: class {
    func pendingPurchaseCell(
        didTap pendingPurchaseCell: PendingPurchaseCell,
        id: Int,
        amount: Int,
        orderId: String,
        vaNumber: String?,
        detail: String?,
        isGopay: Bool,
        qrURL: String?,
        paymentURL: String?)
}

class PendingPurchaseCell: UITableViewCell {

    @IBOutlet var coverImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var gracePeriodLabel: UILabel!
    @IBOutlet var statusLabel: UILabel!
    @IBOutlet var categoryLabel: UILabel!
    @IBOutlet var containerView: UIView!
    
    let shadowLayer = CAShapeLayer()
    weak var delegate: PendingPurchaseCellDelegate?
    
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
    
    var data: PendingPurchaseCellViewModel? {
        didSet {
            if let value = data {
                titleLabel.text = value.title
                statusLabel.text = value.status
                categoryLabel.text = value.category
                gracePeriodLabel.text = value.duration
                if let cover = value.cover {
                    coverImageView.sd_setImage(
                        with: URL(string: cover),
                        placeholderImage: nil,
                        options: .refreshCached
                    )
                } else {
                    coverImageView.image = UIImage()
                }
                
                if shadowLayer.superlayer != nil {
                    shadowLayer.removeFromSuperlayer()
                }
                
                var bounds = containerView.bounds
                bounds.size.width = UIScreen.main.bounds.size.width - 40
                shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: 12).cgPath
                shadowLayer.fillColor = UIColor.white.cgColor
                shadowLayer.shadowColor = UIColor.black.cgColor
                shadowLayer.shadowPath = shadowLayer.path
                shadowLayer.shadowOffset = CGSize(width: 0.0, height: 1.0)
                shadowLayer.shadowOpacity = 0.2
                shadowLayer.shadowRadius = 12
                containerView.layer.insertSublayer(shadowLayer, at: 0)
            }
        }
    }
    
    @IBAction func didTapped(_ sender: UIButton) {
        guard let id = data?.id,
            let amount = data?.amount,
            let orderId = data?.orderId else {
                return
        }
        
        delegate?.pendingPurchaseCell(
            didTap: self,
            id: id,
            amount: amount,
            orderId: orderId,
            vaNumber: data?.vaNumber,
            detail: data?.detail,
            isGopay: data?.isGopay ?? false,
            qrURL: data?.gopayQR,
            paymentURL: data?.gopayURL)
    }
}
