//
//  ProfileAddressCell.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 22/03/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import UIKit

protocol ProfileAddressCellDelegate: class {
    func profileAddressCell(didTapEdit cell: ProfileAddressCell, id: Int)
}

class ProfileAddressCell: MixogyBaseCell {

    @IBOutlet var containerView: UIView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var editButton: UIButton!
    
    weak var delegate: ProfileAddressCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func setupLanguage() {
        addressLabel.text = "address".localized()
        editButton.setTitle("edit".localized(), for: .normal)
    }
    
    func setupUI() {
        containerView.layer.cornerRadius = 12
        containerView.layer.borderColor = UIColor(hexString: "#21A99B").cgColor
        containerView.layer.borderWidth = 1
    }
    
    var data: ProfileAddressCellViewModel? {
        didSet {
            if let value = data {
                nameLabel.text = value.name
            }
        }
    }
    
    @IBAction func didTapEdit(_ sender: UIButton) {
        guard let id = data?.id else {
            return
        }
        
        delegate?.profileAddressCell(didTapEdit: self, id: id)
    }
}
