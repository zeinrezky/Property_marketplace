//
//  PromoDetailViewController.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 07/03/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class PromoDetailPhotoViewController: UIViewController {

    var url = BehaviorRelay<[URL?]>(value: [])
    
    @IBOutlet var mainImageView: UIImageView!
    @IBOutlet var collectionView: UICollectionView!
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    func setupUI() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissSelf))
        view.addGestureRecognizer(tap)
        
        guard !url.value.isEmpty else {
            return
        }
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 9
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: 99, height: 82)
        
        collectionView.collectionViewLayout = layout
        collectionView.backgroundColor = .clear
        collectionView.register(UINib(nibName: "PromoDetailPhotoCell", bundle: nil), forCellWithReuseIdentifier: "PromoDetailPhotoCell")
        
        if let url = url.value.first {
            mainImageView.sd_setImage(
                with: url,
                placeholderImage: nil,
                options: .refreshCached
            )
        }
        
        url.bind(to: collectionView.rx.items(cellIdentifier: "PromoDetailPhotoCell", cellType: PromoDetailPhotoCell.self)) { (indexPath, data, cell) in
            cell.imageView.sd_setImage(
                with: data,
                placeholderImage: nil,
                options: .refreshCached
            )
            
            cell.button.rx.tap.subscribe(onNext: {
                self.mainImageView.sd_setImage(
                    with: data,
                    placeholderImage: nil,
                    options: .refreshCached
                )
            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.disposeBag)
        }.disposed(by: disposeBag)
    }
    
    @objc
    func dismissSelf() {
        dismiss(animated: false, completion: nil)
    }
}
