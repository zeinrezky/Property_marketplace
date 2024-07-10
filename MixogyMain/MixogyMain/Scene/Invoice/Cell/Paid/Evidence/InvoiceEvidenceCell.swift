//
//  InvoiceEvidenceCell.swift
//  MixogyAdmin
//
//  Created by ABDUL AZIS H on 15/02/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import UIKit

protocol InvoiceEvidenceCellDelegate: class {
    func invoiceEvidenceCell(didTappedEvidence invoiceEvidenceCell: InvoiceEvidenceCell, url: String?)
}

class InvoiceEvidenceCell: UITableViewCell {

    weak var delegate: InvoiceEvidenceCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var data: InvoiceEvidenceCellViewModel?
    
    @IBAction func evidenceDidTapped(_ sender: UIButton) {
        delegate?.invoiceEvidenceCell(didTappedEvidence: self, url: data?.imageURL)
    }
}
