//
//  ConfidentialPhotoGalleryViewController.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 30/01/21.
//  Copyright © 2021 Mixogy. All rights reserved.
//

import Agrume
import BottomPopup
import RxSwift
import RxCocoa
import SDWebImage
import UIKit

class ConfidentialPhotoGalleryViewController: BottomPopupViewController {

    @IBOutlet var tableView: UITableView!
    
    var data = BehaviorRelay<[ConfidentialPhotoGalleryCellViewModel]>(value: [])
    var disposeBag = DisposeBag()
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    func setupUI() {
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 32, right: 0)
        tableView.register(UINib(nibName: "ConfidentialPhotoGalleryCell", bundle: nil), forCellReuseIdentifier: "ConfidentialPhotoGalleryCell")
        
        data.bind(to: tableView.rx.items) { tableView, index, data in
            let cell: ConfidentialPhotoGalleryCell = tableView.dequeueReusableCell(withIdentifier: "ConfidentialPhotoGalleryCell") as! ConfidentialPhotoGalleryCell
            cell.data = data
            cell.delegate = self
            return cell
        }.disposed(by: disposeBag)
    }
}

// MARK: - ConfidentialPhotoGalleryCellDelegate

extension ConfidentialPhotoGalleryViewController: ConfidentialPhotoGalleryCellDelegate {
    
    func confidentialPhotoGalleryCell(didTappedImage confidentialPhotoGalleryCell: ConfidentialPhotoGalleryCell, url: String?) {
        guard let value = url, let urlValue = URL(string: value) else {
            return
        }
        let agrume = Agrume(url: urlValue, background: .blurred(.light))
        agrume.show(from: self)
    }
}
