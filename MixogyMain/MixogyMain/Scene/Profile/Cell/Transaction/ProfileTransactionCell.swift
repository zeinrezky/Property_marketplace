//
//  ProfileTransactionCell.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 22/03/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import UIKit

protocol ProfileTransactionCellDelegate: class {
    func profileTransactionCell(didTap cell: ProfileTransactionCell)
}

class ProfileTransactionCell: MixogyBaseCell {

    @IBOutlet var containerView: UIView!
    @IBOutlet var seeTransactionLabel: UILabel!
    weak var delegate: ProfileTransactionCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func setupLanguage() {
        seeTransactionLabel.text = "profile-see-transaction".localized()
    }
    
    func setupUI() {
        containerView.layer.cornerRadius = 12
        containerView.layer.borderColor = UIColor(hexString: "#21A99B").cgColor
        containerView.layer.borderWidth = 1
    }
    
    @IBAction func didTap(_ sender: UIButton) {
        delegate?.profileTransactionCell(didTap: self)
    }
}
