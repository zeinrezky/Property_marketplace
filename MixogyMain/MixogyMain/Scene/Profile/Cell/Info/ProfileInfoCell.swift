//
//  ProfileInfoCell.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 21/03/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import SDWebImage
import UIKit

protocol ProfileInfoCellDelegate: class {
    func profileInfoCell(profileInfoCell didTapCamera: ProfileInfoCell)
}

class ProfileInfoCell: MixogyBaseCell {

    @IBOutlet var containerView: UIView!
    @IBOutlet var photoImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var phoneLabel: UILabel!
    @IBOutlet var nameTitleLabel: UILabel!
    @IBOutlet var phoneTitleLabel: UILabel!
    
    var shadowLayer: CAShapeLayer?
    weak var delegate: ProfileInfoCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
        setupLayer()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func setupLanguage() {
        nameTitleLabel.text = "name".localized()
        phoneTitleLabel.text = "phone-number".localized()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setupLayer()
    }
    
    func setupLayer() {
        if shadowLayer?.superlayer != nil {
            self.shadowLayer?.removeFromSuperlayer()
        }
        
        var bounds = containerView.bounds
        bounds.size.width = UIScreen.main.bounds.size.width - 40
        let shadowLayer = CAShapeLayer()
        shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: 12).cgPath
        shadowLayer.fillColor = UIColor.white.cgColor
        shadowLayer.shadowColor = UIColor.black.cgColor
        shadowLayer.shadowPath = shadowLayer.path
        shadowLayer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        shadowLayer.shadowOpacity = 0.2
        shadowLayer.shadowRadius = 3
        containerView.layer.insertSublayer(shadowLayer, at: 0)
        self.shadowLayer = shadowLayer
    }
    
    func setupUI() {
        photoImageView.layer.cornerRadius = 45
        photoImageView.clipsToBounds = true
    }
    
    @IBAction func changePhoto() {
        delegate?.profileInfoCell(profileInfoCell: self)
    }
    
    var data: ProfileInfoCellViewModel? {
        didSet {
            if let value = data {
                nameLabel.text = value.name
                phoneLabel.text = value.phone
                photoImageView.sd_setImage(
                    with: URL(string: value.cover),
                    placeholderImage: UIImage(named: "DefaultPicture"),
                    options: .refreshCached
                )
                
                setupLayer()
            }
        }
    }
}
