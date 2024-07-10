//
//  CancelReasonCell.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 25/04/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import UIKit

class CancelReasonCell: UITableViewCell {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var radioView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var data: CancelReasonCellViewModel? {
        didSet {
            if let value = data {
                titleLabel.text = value.title
                titleLabel.font = value.selected ? UIFont(name: "Nunito-Bold", size: 20) : UIFont(name: "Nunito-Regular", size: 20)
                radioView.backgroundColor = value.selected ? UIColor(hexString: "#4DD2A7") : .white
                radioView.layer.cornerRadius = 10
                radioView.layer.borderColor = UIColor(hexString: "#DDDDDD").cgColor
                radioView.layer.borderWidth = 1
            }
        }
    }
}
