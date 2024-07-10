//
//  MapLocationNearBy.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 18/07/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import MapKit
import UIKit

protocol MapMarkerDelegate: class {
    func didTapInfoButton(data: NSDictionary)
}

class MapLocationNearBy: MKAnnotationView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var bottomArrow: UIImageView!
    @IBOutlet weak var containerView: UIView!
    
    weak var delegate: MapMarkerDelegate?
    
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    var count: String? {
        didSet {
            countLabel.text = count
        }
    }
    
    var distance: String? {
        didSet {
            distanceLabel.text = distance
        }
    }
    
    class func instanceFromNib() -> MapLocationNearBy {
        return UINib(nibName: "MapLocationNearBy", bundle: nil).instantiate(withOwner: self, options: nil).first as! MapLocationNearBy
    }
    
    func setup() {
        containerView.layer.cornerRadius = 5
        containerView.clipsToBounds = true
        bottomArrow.image = bottomArrow.image?.withRenderingMode(.alwaysTemplate)
        bottomArrow.tintColor = .white
    }
    
    @IBAction func didTapped(_ sender: UIButton) {
        print("miaww")
    }
}
