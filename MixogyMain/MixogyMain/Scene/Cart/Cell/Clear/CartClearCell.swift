//
//  CartClearCell.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 27/03/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import UIKit

protocol CartClearCellDelegate: class {
    func cartClearCell(didTapClear cartClearCell: CartClearCell)
}

class CartClearCell: MixogyBaseCell {

    weak var delegate: CartClearCellDelegate?
    @IBOutlet var clearLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func setupLanguage() {
        clearLabel.text = "clear-all".localized()
    }
    
    @IBAction func clearDidTapped(_ sender: UIButton) {
        delegate?.cartClearCell(didTapClear: self)
    }
}
