//
//  ItemLocationDetailInfoCell.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 20/08/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import UIKit

protocol ItemLocationDetailInfoCellDelegate: class {
    func itemLocationDetailInfoCell(didSelect itemLocationDetailInfoCell: ItemLocationDetailInfoCell, id: Int)
}

class ItemLocationDetailInfoCell: UITableViewCell {

    @IBOutlet var containerViews: [UIView]!
    @IBOutlet var timeLabels: [UILabel]!
    @IBOutlet var countLabels: [UILabel]!
    
    weak var delegate: ItemLocationDetailInfoCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var data: [ItemLocationDetailInfoCellViewModel]? {
        didSet {
            if let value = data {
                for i in 0..<containerViews.count {
                    if value.count > i {
                        containerViews[i].isHidden = false
                        containerViews[i].layer.cornerRadius = 8
                        containerViews[i].layer.borderColor = UIColor.black.cgColor
                        containerViews[i].layer.borderWidth = 1
                        timeLabels[i].text = value[i].time
                        countLabels[i].text = value[i].count
                        containerViews[i].clipsToBounds = true
                    }
                }
            }
        }
    }
    
    @IBAction func didTapped(_ sender: UIButton) {
        guard let data = data else {
            return
        }
        
        delegate?.itemLocationDetailInfoCell(didSelect: self, id: data[sender.tag].id)
    }
}
