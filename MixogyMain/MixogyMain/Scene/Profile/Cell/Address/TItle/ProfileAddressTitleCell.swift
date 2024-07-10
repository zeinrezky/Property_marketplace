//
//  ProfileAddressTitleCell.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 22/03/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import UIKit

protocol ProfileAddressTitleCellDelegate: class {
    func profileAddressTitleCell(didTappAdd profileAddressTitleCell: ProfileAddressTitleCell)
}

class ProfileAddressTitleCell: MixogyBaseCell {

    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var addAddressButton: UIButton!
    
    weak var delegate: ProfileAddressTitleCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func setupLanguage() {
        addressLabel.text = "address".localized()
        addAddressButton.setTitle("profile-add-address".localized(), for: .normal)
    }
    
    @IBAction func didTappAdd(_ sender: UIButton) {
        delegate?.profileAddressTitleCell(didTappAdd: self)
    }
    
}
