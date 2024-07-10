//
//  LocationPhotoCell.swift
//  MixogyAdmin
//
//  Created by ABDUL AZIS H on 26/01/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import SDWebImage
import UIKit

protocol LocationPhotoCellDelegate: class {
    func locationPhotoCell(cell didTapRemove: LocationPhotoCell, data: (Data?, String?, Int))
}

class LocationPhotoCell: UICollectionViewCell {

    @IBOutlet var container: UIView!
    @IBOutlet var photo: UIImageView!
    
    weak var delegate: LocationPhotoCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        container.layer.borderColor = UIColor(hexString: "#D5D5D5").cgColor
        container.layer.borderWidth = 1.0
    }
    
    var data: (Data?, String?, Int)? {
        didSet {
            if let value = data {
                if let imageData = value.0 {
                    photo.image = UIImage(data: imageData)
                } else if let path = value.1,
                    let url = URL(string: path) {
                    photo.sd_setImage(
                        with: url,
                        placeholderImage: UIImage(named: "Camera"),
                        options: .refreshCached,
                        completed: nil
                    )
                }
            }
        }
    }
    
    @IBAction func clear(_ sender: Any) {
        if let data = data {
            delegate?.locationPhotoCell(cell: self, data: data)
        }
    }
}
