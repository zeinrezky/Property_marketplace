//
//  PurchaseCell.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 22/03/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import SDWebImage
import UIKit

protocol PurchaseCellDelegate: class {
    func purchaseCell(didTap purchaseCell: PurchaseCell, id: Int, status: String, statusId: Int)
}

class PurchaseCell: MixogyBaseCell {

    @IBOutlet var coverImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var itemNameLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var locationTitleLabel: UILabel!
    @IBOutlet var gracePeriodLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var dateTitleLabel: UILabel!
    @IBOutlet var gracePeriodTitleLabel: UILabel!
    @IBOutlet var statusLabel: UILabel!
    @IBOutlet var containerView: UIView!
    
    let shadowLayer = CAShapeLayer()
    weak var delegate: PurchaseCellDelegate?
    
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
    
    override func setupLanguage() {
        itemNameLabel.text = "item-name".localized()
        locationTitleLabel.text = "location".localized()
        dateTitleLabel.text = "date".localized()
        gracePeriodTitleLabel.text = "grace-period".localized()
    }
    
    var data: PurchaseCellViewModel? {
        didSet {
            if let value = data {
                coverImageView.sd_setImage(
                    with: URL(string: value.photoURL ?? ""),
                    placeholderImage: nil,
                    options: .refreshCached
                )
                let statusValue: PurchaseStatus = PurchaseStatus(rawValue: value.statusId) ?? .giveToAgent
                titleLabel.text = value.title
                locationLabel.text = value.location
                gracePeriodLabel.text = value.gracePeriod
                gracePeriodLabel.isHidden = statusValue != .onHand
                gracePeriodTitleLabel.isHidden = statusValue != .onHand
                dateLabel.text = value.date
                statusLabel.text = value.status
            }
        }
    }
    
    @IBAction func didTapped(_ sender: UIButton) {
        guard let id = data?.id,
            let status = data?.status,
            let statusId = data?.statusId else {
            return
        }
        
        delegate?.purchaseCell(didTap: self, id: id, status: status, statusId: statusId)
    }
}
