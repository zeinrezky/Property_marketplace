//
//  PromoDetailViewController.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 01/03/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import AVFoundation
import Cartography
import CoreLocation
import PBJVideoPlayer
import RxCocoa
import RxSwift
import SVProgressHUD
import UIKit
import VersaPlayer

class PromoDetailViewController: UIViewController {

    @IBOutlet var leftView: UIVisualEffectView!
    @IBOutlet var cartView: UIVisualEffectView!
    @IBOutlet var effectViews: [UIVisualEffectView]!
    @IBOutlet var coverImageView: UIImageView!
    @IBOutlet var availableLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var placeNameLabel: UILabel!
    @IBOutlet var stackView: UIStackView!
    @IBOutlet var versaPlayerView: VersaPlayerView!
    @IBOutlet var videooBack: UIButton!
    
    var disposeBag = DisposeBag()
    var viewModel = PromoDetailViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupBinding()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if viewModel.data.value == nil {
            viewModel.fetchData()
        }
    }
    
    @IBAction func back(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func setopVideo(_ sender: Any) {
        videooBack.isHidden = true
        versaPlayerView.isHidden = true
    }
    
    
    @IBAction func addToCart() {
        let itemDetailViewController = ItemDetailViewController(nibName: "ItemDetailViewController", bundle: nil)
        itemDetailViewController.viewModel.id = viewModel.data.value?.itemId
        navigationController?.pushViewController(itemDetailViewController, animated: true)
    }
    
    @IBAction func routeToDirection(sender: UIButton) {
        if let value = viewModel.data.value {
            if let url = URL(string: "comgooglemaps://"), UIApplication.shared.canOpenURL(url) {
                if let url = URL(string: "comgooglemaps-x-callback://?saddr=&daddr=\(value.latitude),\(value.longitude)&directionsmode=driving") {
                    UIApplication.shared.open(url, options: [:])
                }
            } else {
                if let url = URL(string: "https://www.google.co.in/maps/dir/?saddr=&daddr=\(value.latitude),\(value.longitude)&directionsmode=driving") {
                    UIApplication.shared.open(url)
                }
            }
        }
    }
}

// MARK: - PromoDetailViewController

extension PromoDetailViewController {
    
    func setupUI() {
        for effectView in effectViews {
            effectView.layer.cornerRadius = 4
            effectView.clipsToBounds = true
        }
    }
    
    func setupBinding() {
        viewModel.isLoading.subscribe(onNext: { isLoading in
            if isLoading {
                SVProgressHUD.show()
            } else {
                SVProgressHUD.dismiss()
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        
        viewModel.data.subscribe(onNext: { data in
            if let value = data {
                self.coverImageView.sd_setImage(
                    with: URL(string: value.mainImageURL ?? ""),
                    placeholderImage: nil,
                    options: .refreshCached
                )
                
                self.availableLabel.text = "\(value.available) TICKETS LEFT"
                self.nameLabel.text = value.name
                self.placeNameLabel.text = value.placeName
                
                for topSection in value.sectionTop {
                    self.addSection(title: topSection.title, detail: topSection.text)
                }
                
                if !value.photos.isEmpty {
                    self.addPhoto(data: value.photos)
                }
                
                if !value.videos.isEmpty {
                    self.addVideo(data: value.videos)
                }
                
                self.addSection(title: "Website", detail: value.website)
                
                for bottomSection in value.sectionBottom {
                    self.addSection(title: bottomSection.title, detail: bottomSection.text)
                }
                
                self.cartView.isHidden = value.itemId == nil
                self.leftView.isHidden = value.itemId == nil
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        
        viewModel.errorMessage.subscribe(onNext: { message in
            if let message = message {
                self.showAlert(message: message)
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
    }
    
    func addSection(title: String?, detail: String?) {
        let containerView = UIView(frame: .zero)
        
        let titleLabel = UILabel(frame: .zero)
        titleLabel.font = UIFont(name: "Nunito-Bold", size: 12)
        titleLabel.textColor = .black
        titleLabel.text = title
        titleLabel.numberOfLines = 0
        
        let lineView = UIView(frame: .zero)
        lineView.backgroundColor = UIColor(hexString: "#D2D2D2")
        
        let detailLabel = UILabel(frame: .zero)
        detailLabel.font = UIFont(name: "Nunito-ExtraLight", size: 12)
        detailLabel.textColor = .black
        detailLabel.text = detail
        detailLabel.numberOfLines = 0
        
        containerView.addSubview(titleLabel)
        containerView.addSubview(lineView)
        containerView.addSubview(detailLabel)
        
        constrain(containerView, titleLabel, detailLabel, lineView) { containerView, titleLabel, detailLabel, lineView in
            titleLabel.left == containerView.left + 20
            titleLabel.right == containerView.right - 20
            detailLabel.left == containerView.left + 20
            detailLabel.right == containerView.right - 20
            lineView.left == containerView.left + 20
            lineView.right == containerView.right - 20
            titleLabel.top == containerView.top
            lineView.top == titleLabel.bottom + 4
            lineView.height == 1
            detailLabel.top == lineView.bottom + 16
            detailLabel.bottom == containerView.bottom - 16
        }
        
        stackView.addArrangedSubview(containerView)
    }
    
    func addPhoto(data: [PromoDetailMediaResponse]) {
        let containerView = UIView(frame: .zero)
        
        let titleLabel = UILabel(frame: .zero)
        titleLabel.font = UIFont(name: "Nunito-Bold", size: 12)
        titleLabel.textColor = .black
        titleLabel.text = "Gallery".localized()
        titleLabel.numberOfLines = 0
        
        let lineView = UIView(frame: .zero)
        lineView.backgroundColor = UIColor(hexString: "#D2D2D2")
        
        let photoWidth = (UIScreen.main.bounds.size.width - 80) / 3
        
        let photoButton1 = UIButton(frame: .zero)
        photoButton1.layer.cornerRadius = 5
        photoButton1.clipsToBounds = true
        
        if data.count > 0, let url1 = URL(string: data[0].url ?? "") {
            photoButton1.sd_setBackgroundImage(with: url1, for: .normal)
            photoButton1.rx.tap.subscribe(onNext: {
                self.showGallery(data: data)
            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.disposeBag)
        }
        
        let photoButton2 = UIButton(frame: .zero)
        photoButton2.layer.cornerRadius = 5
        photoButton2.clipsToBounds = true
        
        if data.count > 1, let url2 = URL(string: data[1].url ?? "") {
            photoButton2.sd_setBackgroundImage(with: url2, for: .normal)
            photoButton2.rx.tap.subscribe(onNext: {
                self.showGallery(data: data)
            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.disposeBag)
        }
        
        let photoButton3 = UIButton(frame: .zero)
        photoButton3.layer.cornerRadius = 5
        photoButton3.clipsToBounds = true
        if data.count > 2, let url3 = URL(string: data[2].url ?? "") {
            photoButton3.sd_setBackgroundImage(with: url3, for: .normal)
            photoButton3.rx.tap.subscribe(onNext: {
                self.showGallery(data: data)
            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.disposeBag)
        }
        
        containerView.addSubview(titleLabel)
        containerView.addSubview(lineView)
        containerView.addSubview(photoButton1)
        containerView.addSubview(photoButton2)
        containerView.addSubview(photoButton3)
        
        constrain(containerView, titleLabel, photoButton1, lineView, photoButton2, photoButton3) { containerView, titleLabel, photoButton1, lineView, photoButton2, photoButton3 in
            titleLabel.left == containerView.left + 20
            titleLabel.right == containerView.right - 20
            photoButton1.left == containerView.left + 20
            photoButton1.width == photoWidth
            photoButton1.height == photoWidth
            photoButton2.width == photoWidth
            photoButton2.height == photoWidth
            photoButton3.width == photoWidth
            photoButton3.height == photoWidth
            photoButton3.right == containerView.right - 20
            photoButton2.centerX == containerView.centerX
            lineView.left == containerView.left + 20
            lineView.right == containerView.right - 20
            titleLabel.top == containerView.top + 8
            lineView.top == titleLabel.bottom + 4
            lineView.height == 1
            photoButton1.top == lineView.bottom + 16
            photoButton2.top == lineView.bottom + 16
            photoButton3.top == lineView.bottom + 16
            photoButton1.bottom == containerView.bottom - 24
        }
        
        stackView.addArrangedSubview(containerView)
    }
    
    func addVideo(data: [PromoDetailVideoResponse]) {
        let containerView = UIView(frame: .zero)
        
        let titleLabel = UILabel(frame: .zero)
        titleLabel.font = UIFont(name: "Nunito-Bold", size: 12)
        titleLabel.textColor = .black
        titleLabel.text = "Video"
        titleLabel.numberOfLines = 0
        
        let lineView = UIView(frame: .zero)
        lineView.backgroundColor = UIColor(hexString: "#D2D2D2")
        
        let photoWidth = (UIScreen.main.bounds.size.width - 80) / 3
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: photoWidth, height: photoWidth)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.register(UINib(nibName: "PromoDetailPhotoCell", bundle: nil), forCellWithReuseIdentifier: "PromoDetailPhotoCell")
        
        let videoURL = BehaviorRelay<[(URL?, String?)]>(value: data.map({ (video) -> (URL?, String?) in
            return (URL(string: video.thumbnail ?? ""), video.url)
        }))
        
        videoURL.bind(to: collectionView.rx.items(cellIdentifier: "PromoDetailPhotoCell", cellType: PromoDetailPhotoCell.self)) { (indexPath, data, cell) in
            cell.imageView.sd_setImage(
                with: data.0,
                placeholderImage: nil,
                options: .refreshCached
            )
            
            cell.imageView.layer.cornerRadius = 5
            cell.imageView.clipsToBounds = true
            
            cell.button.rx.tap.subscribe(onNext: {
                if let url = data.1, let path = URL(string: url) {
                    self.versaPlayerView.isHidden = false
                    self.videooBack.isHidden = false
                    let item = VersaPlayerItem(url: path)
                    self.versaPlayerView.set(item: item)
                }
    
            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.disposeBag)
        }.disposed(by: disposeBag)
        
        containerView.addSubview(titleLabel)
        containerView.addSubview(lineView)
        containerView.addSubview(collectionView)
        
        constrain(containerView, titleLabel, lineView, collectionView) { containerView, titleLabel, lineView, collectionView in
            titleLabel.left == containerView.left + 20
            titleLabel.right == containerView.right - 20
            collectionView.left == containerView.left + 20
            collectionView.right == containerView.right - 20
            lineView.left == containerView.left + 20
            lineView.right == containerView.right - 20
            
            titleLabel.top == containerView.top + 8
            lineView.top == titleLabel.bottom + 4
            lineView.height == 1
            collectionView.top == lineView.bottom + 16
            collectionView.height == photoWidth
            collectionView.bottom == containerView.bottom - 24
        }
        
        stackView.addArrangedSubview(containerView)
    }
    
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "informaton".localized(), message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showGallery(data: [PromoDetailMediaResponse]) {
        let promoDetailPhotoViewController = PromoDetailPhotoViewController(nibName: "PromoDetailPhotoViewController", bundle: nil)
        promoDetailPhotoViewController.url.accept(data.map({(media) -> URL? in
            return URL(string: media.url ?? "")
        }))
        promoDetailPhotoViewController.modalPresentationStyle = .overCurrentContext
        present(promoDetailPhotoViewController, animated: false, completion: nil)
    }
    
    func showVideo(data: [PromoDetailVideoResponse]) {
        
    }
}
