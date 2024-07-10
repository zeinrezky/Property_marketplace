//
//  ConfidentialPhotoGalleryCell.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 30/01/21.
//  Copyright © 2021 Mixogy. All rights reserved.
//

import UIKit

protocol ConfidentialPhotoGalleryCellDelegate: class {
    func confidentialPhotoGalleryCell(didTappedImage confidentialPhotoGalleryCell: ConfidentialPhotoGalleryCell, url: String?)
}

class ConfidentialPhotoGalleryCell: UITableViewCell {

    @IBOutlet var coverImageView: UIImageView!
    
    weak var delegate: ConfidentialPhotoGalleryCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
 
    var data: ConfidentialPhotoGalleryCellViewModel? {
        didSet {
            if let value = data {
                coverImageView.sd_setImage(
                    with: URL(string: value.photo ?? ""),
                    placeholderImage: nil,
                    options: .refreshCached
                )
            }
        }
    }
    
    @IBAction func didTappedImage(_ sender: UIButton) {
        delegate?.confidentialPhotoGalleryCell(didTappedImage: self, url: data?.photo)
    }
}
