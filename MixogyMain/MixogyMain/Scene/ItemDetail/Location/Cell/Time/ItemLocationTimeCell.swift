//
//  ItemLocationTimeCell.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 20/08/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import UIKit

protocol ItemLocationTimeCellDelegate: class {
    func itemLocationTimeCell(didSelect itemLocationTimeCell: ItemLocationTimeCell, source: ItemLocationCollectionDateResponse)
}

class ItemLocationTimeCell: UITableViewCell {

    @IBOutlet var containerViews: [UIView]!
    @IBOutlet var dateLabels: [UILabel]!
    @IBOutlet var countLabels: [UILabel]!
    
    weak var delegate: ItemLocationTimeCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var data: [ItemLocationTimeCellViewModel]? {
        didSet {
            if let value = data {
                for i in 0..<containerViews.count {
                    if value.count > i {
                        containerViews[i].isHidden = false
                        containerViews[i].layer.cornerRadius = 8
                        containerViews[i].layer.borderColor = UIColor.black.cgColor
                        containerViews[i].layer.borderWidth = 1
                        dateLabels[i].text = value[i].date
                        countLabels[i].text = value[i].count
                        containerViews[i].clipsToBounds = true
                    }
                }
            }
        }
    }
    
    @IBAction func didTapped(_ sender: UIButton) {
        guard let value = data else {
            return
        }
        
        delegate?.itemLocationTimeCell(didSelect: self, source: value[sender.tag].source)
    }
}
