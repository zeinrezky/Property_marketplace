//
//  OurAgentGeneralCell.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 18/10/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import UIKit

protocol OurAgentGeneralCellDelegate: class {
    func ourAgentCell(didTapChat ourAgentCell: OurAgentGeneralCell, id: Int)
}

class OurAgentGeneralCell: MixogyBaseCell {

    @IBOutlet var coverImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var nameTitleLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var locationTitleLabel: UILabel!
    @IBOutlet var containerView: UIView!
    @IBOutlet var locationView: UIView!
    @IBOutlet var callButton: UIButton!
    @IBOutlet var chatButton: UIView!
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    
    let shadowLayer = CAShapeLayer()
    weak var delegate: OurAgentGeneralCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        coverImageView.layer.cornerRadius = 20
        coverImageView.clipsToBounds = true
        locationView.layer.borderColor = UIColor(hexString: "#CFCFCF").cgColor
        locationView.layer.cornerRadius = 7
        locationView.clipsToBounds = true
        locationView.layer.borderWidth = 1
        callButton.layer.cornerRadius = 7
        callButton.clipsToBounds = true
        chatButton.layer.cornerRadius = 7
        chatButton.clipsToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if shadowLayer.superlayer != nil {
            shadowLayer.removeFromSuperlayer()
        }
        
        var bounds = containerView.bounds
        bounds.size.width = UIScreen.main.bounds.size.width - 40
        shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: 7).cgPath
        shadowLayer.fillColor = UIColor.white.cgColor
        shadowLayer.shadowColor = UIColor.black.cgColor
        shadowLayer.shadowPath = shadowLayer.path
        shadowLayer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        shadowLayer.shadowOpacity = 0.2
        shadowLayer.shadowRadius = 7
        containerView.layer.insertSublayer(shadowLayer, at: 0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    override func setupLanguage() {
        nameTitleLabel.text = "agent-name".localized()
        locationTitleLabel.text = "location".localized()
        callButton.setTitle("call".localized(), for: .normal)
    }
 
    var data: OurAgentCellViewModel? {
        didSet {
            if let value = data {
                coverImageView.sd_setImage(
                    with: URL(string: value.photoURL ?? ""),
                    placeholderImage: nil,
                    options: .refreshCached
                )
                
                nameLabel.text = value.name
                locationLabel.text = value.locationPickUp ?? "" + " " + value.distance
                if containerView.tag == 1 {
                    heightConstraint.constant = 85
                    callButton.isHidden = true
                    chatButton.isHidden = true
                }
            }
        }
    }
    
    @IBAction func didTapChat(_ sender: UIButton) {
        guard let value = data else {
            return
        }
        
        delegate?.ourAgentCell(didTapChat: self, id: value.id)
    }
    
    @IBAction func didTapCall(_ sender: UIButton) {
        guard let value = data else {
            return
        }
        
        let phone = value.phone.replacingOccurrences(of: "+", with: "")
        
        if let url = URL(string: "tel://\(phone)"){
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    @IBAction func didTapLocation(_ sender: UIButton) {
        if let value = data {
            if let url = URL(string: "comgooglemaps://"), UIApplication.shared.canOpenURL(url) {
                if let url = URL(string: "comgooglemaps-x-callback://?saddr=&daddr=\(value.latitude),\(value.longitude)&directionsmode=driving") {
                    UIApplication.shared.open(url, options: [:])
                }
            } else {
                if let url = URL(string: "https://www.google.co.in/maps/dir/?saddr=&daddr=\(value.latitude),\(value.longitude)&directionsmode=driving") {
                    UIApplication.shared.open(url, options: [:])
                }
            }
        }
    }
    
}
