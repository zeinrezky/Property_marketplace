//
//  SellCreatePlusCell.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 03/04/21.
//  Copyright © 2021 Mixogy. All rights reserved.
//

import UIKit

protocol SellCreatePlusCellDelegate: class {
    func sellCreatePlusCell(didSelect cell: SellCreatePlusCell)
}

class SellCreatePlusCell: UICollectionViewCell {

    @IBOutlet var containerView: UIView!
    
    weak var delegate: SellCreatePlusCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        containerView.layer.borderWidth = 1.0
        containerView.layer.borderColor = UIColor(hexString: "#D5D5D5").cgColor
    }

    @IBAction func didSelect(_ sender: UIButton) {
        delegate?.sellCreatePlusCell(didSelect: self)
    }
}
