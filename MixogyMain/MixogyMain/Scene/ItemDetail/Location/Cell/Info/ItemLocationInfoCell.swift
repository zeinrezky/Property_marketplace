//
//  ItemLocationInfoCell.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 20/08/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import UIKit

protocol ItemLocationInfoCellDelegate: class {
    func itemLocationInfoCell(didSelect itemLocationInfoCell: ItemLocationInfoCell, index: Int)
}

class ItemLocationInfoCell: MixogyBaseCell {

    @IBOutlet var containerView: UIView!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var locationTitleLabel: UILabel!
    @IBOutlet var countLabel: UILabel!
    
    weak var delegate: ItemLocationInfoCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func setupLanguage() {
        locationTitleLabel.text = "location".localized()
    }
    
    var data: ItemLocationInfoCellViewModel? {
        didSet {
            if let value = data {
                locationLabel.text = value.location
                countLabel.text = value.count
                containerView.layer.cornerRadius = 7
                containerView.layer.borderColor = UIColor(hexString: "#393939").cgColor
                containerView.layer.borderWidth = 1.0
                containerView.clipsToBounds = true
                containerView.backgroundColor = value.selected ? UIColor(hexString: "#393939") : UIColor.white
                locationLabel.textColor = !value.selected ? UIColor(hexString: "#393939") : UIColor.white
                locationTitleLabel.textColor = !value.selected ? UIColor(hexString: "#393939") : UIColor.white
                countLabel.textColor = !value.selected ? UIColor(hexString: "#393939") : UIColor.white
                contentView.tag = value.index
            }
        }
    }
    
    @IBAction func didTapped(_ sender: UIButton) {
        delegate?.itemLocationInfoCell(didSelect: self, index: 0)
    }
}
