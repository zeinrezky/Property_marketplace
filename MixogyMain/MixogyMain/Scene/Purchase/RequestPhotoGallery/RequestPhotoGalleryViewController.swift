//
//  RequestPhotoGalleryViewController.swift
//  MixogyAdmin
//
//  Created by ABDUL AZIS H on 23/02/20.
//  Copyright © 2020 Mixogi. All rights reserved.
//

import Agrume
import BottomPopup
import SDWebImage
import UIKit

class RequestPhotoGalleryViewController: BottomPopupViewController {

    @IBOutlet var frontImageView: UIImageView?
    @IBOutlet var backImageView: UIImageView?
    @IBOutlet var indicatorView: UIView!
    @IBOutlet var frontLabel: UILabel!
    @IBOutlet var behindLabel: UILabel!
    
    var frontImage: URL?
    var backImage: URL?
    
    var height: CGFloat?
    var topCornerRadius: CGFloat?
    var presentDuration: Double?
    var dismissDuration: Double?
    var shouldDismissInteractivelty: Bool?
    
    override func getPopupHeight() -> CGFloat {
        return height ?? CGFloat(300)
    }
       
    override func getPopupTopCornerRadius() -> CGFloat {
        return topCornerRadius ?? CGFloat(12)
    }
       
    override func getPopupPresentDuration() -> Double {
        return presentDuration ?? 1.0
    }
    
    override func getPopupDismissDuration() -> Double {
        return dismissDuration ?? 1.0
    }
    
    override func shouldPopupDismissInteractivelty() -> Bool {
        return shouldDismissInteractivelty ?? true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setupUI()
    }
    
    @IBAction func showFrontImage() {
        guard let url = frontImage else {
            return
        }
        let agrume = Agrume(url: url, background: .blurred(.light))
        agrume.show(from: self)
    }
    
    @IBAction func showBackImage() {
        guard let url = backImage else {
            return
        }
        let agrume = Agrume(url: url, background: .blurred(.light))
        agrume.show(from: self)
    }

    func setupUI() {
        indicatorView.layer.cornerRadius = 2.5
        indicatorView.clipsToBounds = true
        frontImageView?.sd_setImage(
            with: frontImage,
            placeholderImage: nil,
            options: .refreshCached,
            completed: nil
        )
        
        backImageView?.sd_setImage(
            with: backImage,
            placeholderImage: nil,
            options: .refreshCached,
            completed: nil
        )
        
        frontLabel.text = "front".localized()
        behindLabel.text = "behind".localized()
    }
    
}
