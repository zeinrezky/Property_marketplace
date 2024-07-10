//
//  OurAgentCell.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 06/04/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import UIKit

protocol OurAgentCellDelegate: class {
    func ourAgentCell(didTapChat ourAgentCell: OurAgentCell, id: Int)
    func ourAgentCell(didTapSelect ourAgentCell: OurAgentCell, id: Int)
}

class OurAgentCell: UITableViewCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var agentLabel: UILabel!
    @IBOutlet var placeNameLabel: UILabel!
    @IBOutlet var distanceLabel: UILabel!
    @IBOutlet var containerView: UIView!
    @IBOutlet var locationContainerView: UIView!
    @IBOutlet var selectButton: UIButton!
    @IBOutlet var mapButton: UIButton!
    @IBOutlet var pinImageView: UIImageView!
    
    let shadowLayer = CAShapeLayer()
    weak var delegate: OurAgentCellDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        selectButton.layer.cornerRadius = 4
        selectButton.clipsToBounds = true
        mapButton.layer.cornerRadius = 4
        mapButton.clipsToBounds = true
        locationContainerView.layer.cornerRadius = 8
        locationContainerView.clipsToBounds = true
        locationContainerView.layer.borderColor = UIColor(hexString: "#CFCFCF").cgColor
        locationContainerView.layer.borderWidth = 1
        pinImageView.image = pinImageView.image?.withRenderingMode(.alwaysTemplate)
        pinImageView.tintColor = .white
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
        bounds.size.height = contentView.bounds.size.height - 12
        shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: 7).cgPath
        shadowLayer.fillColor = UIColor.white.cgColor
        shadowLayer.shadowColor = UIColor.black.cgColor
        shadowLayer.shadowPath = shadowLayer.path
        shadowLayer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        shadowLayer.shadowOpacity = 0.2
        shadowLayer.shadowRadius = 7
        containerView.layer.insertSublayer(shadowLayer, at: 0)
    }
    
    var data: OurAgentCellViewModel? {
        didSet {
            if let value = data {
                agentLabel.text = value.name
                placeNameLabel.text = value.address
                distanceLabel.text = value.distance
                titleLabel.text = value.locationPickUp
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
    
    @IBAction func didTapSelect(_ sender: UIButton) {
        guard let value = data else {
            return
        }
        
        delegate?.ourAgentCell(didTapSelect: self, id: value.id)
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
