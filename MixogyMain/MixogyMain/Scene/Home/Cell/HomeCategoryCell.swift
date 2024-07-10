//
//  HomeCategoryCell.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 01/03/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import SDWebImage
import UIKit

class HomeCategoryCell: UICollectionViewCell {

    @IBOutlet var containerView: UIView!
    @IBOutlet var bottomView: UIView!
    @IBOutlet var coverImageView: UIImageView!
    @IBOutlet var titleView: UIVisualEffectView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var priceBeforeLabel: UILabel!
    @IBOutlet var typeLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var countLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var typeView: UIView!
    @IBOutlet var countView: UIView!
    @IBOutlet var maskingView: UIView!
    
    let shadowLayer = CAShapeLayer()
    var width: Int = 0 {
        didSet {
            
            let bounds = CGRect(x: 0, y: 0, width: width, height: 183)
            coverImageView.roundCorners(bounds: bounds, corners: [.topLeft, .topRight], radius: 7)
            maskingView.roundCorners(bounds: bounds, corners: [.topLeft, .topRight], radius: 7)
            bottomView.roundCorners(bounds: bounds, corners: [.bottomLeft, .bottomRight], radius: 7)
            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: 7).cgPath
            shadowLayer.fillColor = UIColor.white.cgColor
            shadowLayer.shadowColor = UIColor.black.cgColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = CGSize(width: 1.0, height: 1.0)
            shadowLayer.shadowOpacity = 0.2
            shadowLayer.shadowRadius = 3

            containerView.layer.insertSublayer(shadowLayer, at: 0)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setupUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
    }

    func setupUI() {
        titleView.layer.cornerRadius = 3
        titleView.clipsToBounds = true
        
        let typeBlurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let typeBlurEffectView = UIVisualEffectView(effect: typeBlurEffect)
        typeBlurEffectView.frame = typeView.bounds
        typeBlurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        typeBlurEffectView.layer.cornerRadius = 3
        typeBlurEffectView.clipsToBounds = true
        typeView.insertSubview(typeBlurEffectView, at: 0)
        typeView.layer.cornerRadius = 3
        typeView.clipsToBounds = true
        
        let countBlurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let countBlurEffectView = UIVisualEffectView(effect: countBlurEffect)
        countBlurEffectView.frame = countView.bounds
        countBlurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        countBlurEffectView.layer.cornerRadius = 3
        countBlurEffectView.clipsToBounds = true
        countView.insertSubview(countBlurEffectView, at: 0)
        countView.layer.cornerRadius = 3
        countView.clipsToBounds = true
        let attributedString = NSMutableAttributedString(string: "Rp5.000.000")
        
        attributedString.addAttribute(
            NSAttributedString.Key.strikethroughColor,
            value: UIColor.black,
            range: NSMakeRange(0, attributedString.length)
        )
        
        attributedString.addAttribute(
            NSAttributedString.Key.strikethroughStyle,
            value: NSNumber(value: NSUnderlineStyle.single.rawValue),
            range: NSMakeRange(0, attributedString.length)
        )
        
        priceBeforeLabel.attributedText = attributedString
    }
    
    var data: HomeCategoryCellViewModel? {
        didSet {
            if let value = data {
                coverImageView.sd_setImage(
                    with: URL(string: value.photo ?? ""),
                    placeholderImage: nil,
                    options: .refreshCached
                )
                
                titleLabel.text = value.category
                nameLabel.text = value.name
                typeLabel.text = value.type
                priceBeforeLabel.text = value.originalPrice
                priceLabel.text = Int(value.count) ?? 0 < 1 ? "Sold Out" : value.lowestPrice
                countLabel.text = Int(value.count) ?? 0 < 1 ? "Sold Out" : value.count
                priceLabel.textColor = UIColor(hexString: value.color)
            }
        }
    }
}
