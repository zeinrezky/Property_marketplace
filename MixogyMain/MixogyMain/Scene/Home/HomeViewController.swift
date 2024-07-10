//
//  HomeViewController.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 29/02/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import CoreLocation
import Cartography
import ImageSlideshow
import RxCocoa
import RxSwift
import SVProgressHUD
import UIKit

class HomeViewController: MixogyBaseViewController {

    @IBOutlet var profileButton: UIButton!
    @IBOutlet var navigationView: UIView!
    @IBOutlet var actionView: [UIView]!
    @IBOutlet var stackView: UIStackView!
    @IBOutlet var locationStackView: UIStackView!
    @IBOutlet var categoryLabel: UILabel!
    @IBOutlet var imageBanner: UIImageView!
    @IBOutlet var searchCollectionView: UICollectionView!
    @IBOutlet var winSlideShow: ImageSlideshow!
    @IBOutlet var topStackConstraint: NSLayoutConstraint!
    @IBOutlet var searchWidthConstraint: NSLayoutConstraint!
    @IBOutlet var searchTextfield: UITextField!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var searchTextfieldConstraint: NSLayoutConstraint!
    @IBOutlet var locationSearchWidthConstraint: NSLayoutConstraint!
    @IBOutlet var locationSearchTextfieldConstraint: NSLayoutConstraint!
    
    var disposeBag = DisposeBag()
    var viewModel = HomeViewModel()
    let locationManager = CLLocationManager()
    
    var shadowLayer: CAShapeLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupBinding()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let profile = Preference.profile,
            let url = URL(string: profile.photoURL) {
            profileButton.sd_setBackgroundImage(with: url, for: .normal, placeholderImage: UIImage(named: "DefaultPicture"))
        } else {
            profileButton.setBackgroundImage(UIImage(named: "DefaultPicture"), for: .normal)
        }
        
        if !viewModel.isLocationSearch {
            viewModel.fetchDataCategory()
            viewModel.fetchPromoData()
        }
        
        if Preference.auth != nil {
            viewModel.fetchCartData()
        }
        
        tabBarController?.selectedIndex = 1
        tabBarController?.selectedIndex = 0
    }
    
    override func setupLanguage() {
        tabBarItem.title = "home".localized()
    }
    
    @IBAction func selectNextCategory(_ sender: UIButton) {
        viewModel.selectNextCategory()
    }
    
    @IBAction func selectBeforeCategory(_ sender: UIButton) {
        viewModel.selectBeforeCategory()
    }
    
    @IBAction func search(_ sender: UIButton) {
        viewModel.isLocationSearch = false
        searchTextfield.becomeFirstResponder()
        searchTextfield.placeholder = "Search \(categoryLabel.text!)"
        locationLabel.text = ""
        viewModel.isSearch = true
        viewModel.keywords.accept("")
        viewModel.fetchSearchData()
    }
    
    @IBAction func unSearch(_ sender: UIButton) {
        searchTextfield.resignFirstResponder()
        viewModel.isSearch = false
        searchTextfield.text = ""
        viewModel.searchItem.accept([])
        viewModel.keywords.accept(nil)
    }
    
    @IBAction func locationUnSearch(_ sender: UIButton) {
        viewModel.isLocationSearch = false
        locationLabel.text = ""
        viewModel.searchItem.accept([])
        viewModel.keywords.accept(nil)
    }
    
    @IBAction func routeToMapLocation(_ sender: Any) {
        let mapViewController = MapLocationViewController(nibName: "MapLocationViewController", bundle: nil)
        mapViewController.delegate = self
        navigationController?.pushViewController(mapViewController, animated: true)
    }
    
    @IBAction func routeProfile(_ sender: Any) {
        if Preference.auth != nil {
            let profileViewController = ProfileViewController(nibName: "ProfileViewController", bundle: nil)
            navigationController?.pushViewController(profileViewController, animated: true)
        } else {
            let mapViewController = LoginViewController(nibName: "LoginViewController", bundle: nil)
            navigationController?.pushViewController(mapViewController, animated: true)
        }
    }
    
    @objc
    func routeToPromoDetail(_ sender: Any) {
        guard let id = viewModel.selectedPromoId else {
            return
        }
        
        let promoDetailViewController = PromoDetailViewController(nibName: "PromoDetailViewController", bundle: nil)
        promoDetailViewController.viewModel.id = id
        navigationController?.pushViewController(promoDetailViewController, animated: true)
    }
    
    @objc
    func routeToItemDetail(id: Int, typeId: Int, name: String, levelId: Int) {
        let itemLocationViewController = ItemLocationViewController(nibName: "ItemLocationViewController", bundle: nil)
        itemLocationViewController.viewModel.id = id
        itemLocationViewController.viewModel.typeId = typeId
        itemLocationViewController.viewModel.name = name
        itemLocationViewController.viewModel.levelId = levelId
        itemLocationViewController.hidesBottomBarWhenPushed = false
        navigationController?.pushViewController(itemLocationViewController, animated: true)
    }
    
    func routeToLocationDetail(id: Int, levelId: Int) {
        let itemDetailViewController = ItemDetailViewController(nibName: "ItemDetailViewController", bundle: nil)
        itemDetailViewController.viewModel.id = id
        itemDetailViewController.hidesBottomBarWhenPushed = false
        itemDetailViewController.viewModel.level = levelId
        navigationController?.pushViewController(itemDetailViewController, animated: true)
    }
}

// MARK: - Private Extension

fileprivate extension HomeViewController {
    
    func setupUI() {
        for view in actionView {
            view.layer.cornerRadius = 5
            view.clipsToBounds = true
        }
        
        profileButton.layer.cornerRadius = 17
        profileButton.layer.borderWidth = 1
        profileButton.layer.borderColor = UIColor.white.cgColor
        profileButton.clipsToBounds = true
        
        navigationView.layer.cornerRadius = 7
        navigationView.clipsToBounds = true
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: (UIScreen.main.bounds.size.width - 40) / 2, height: 191)
        
        searchCollectionView.collectionViewLayout = layout
        searchCollectionView.backgroundColor = .clear
        searchCollectionView.register(UINib(nibName: "HomeCategoryCell", bundle: nil), forCellWithReuseIdentifier: "HomeCategoryCell")
        
        locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    func setupBinding() {
        viewModel
            .selectedCategoryValue
            .bind(to: categoryLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.selectedCategoryImageValue.subscribe(onNext: { image in
            if let url = URL(string: image ?? "") {
                self.imageBanner.sd_setImage(with: url, placeholderImage: nil, options: .refreshCached)
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        
        viewModel.isLoading.subscribe(onNext: { isLoading in
            if isLoading {
                SVProgressHUD.show()
            } else {
                SVProgressHUD.dismiss()
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        
        viewModel.errorMessage.subscribe(onNext: { message in
            if let message = message {
                self.showAlert(message: message)
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        
        viewModel.promoData.subscribe(onNext: { promoData in
            if !promoData.isEmpty && !self.viewModel.isSearch && !self.viewModel.isLocationSearch {
                self.winSlideShow.setImageInputs(promoData.map { (photo) -> InputSource in
                    return SDWebImageSource(
                        urlString: photo.1?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "",
                        placeholder: UIImage()
                    )!
                })
                
                self.winSlideShow.layer.cornerRadius = 8
                self.winSlideShow.clipsToBounds = true
                self.winSlideShow.backgroundColor = .clear
                self.winSlideShow.isHidden = false
                self.winSlideShow.slideshowInterval = 3
                self.winSlideShow.contentScaleMode = .scaleAspectFill
                self.winSlideShow.delegate = self
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        
        viewModel.nearBySelected.subscribe(onNext: { nearBySelected in
            self.resetStackView()
            
            if !nearBySelected {
                self.categoryDetail()
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        
        viewModel.search.subscribe(onNext: { isSearch in
            self.topStackConstraint.constant = isSearch ? self.view.frame.size.height - 56 : 287
            self.searchWidthConstraint.constant = isSearch ? UIScreen.main.bounds.size.width - 122 : 37
            self.winSlideShow.isHidden = isSearch
            self.navigationView.isHidden = isSearch
            self.searchTextfieldConstraint.constant = isSearch ? 8 : -114
            self.searchCollectionView.isHidden = !isSearch
            
            if isSearch && self.stackView.arrangedSubviews.count > 1 {
                self.stackView.arrangedSubviews[1].removeFromSuperview()
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        
        viewModel.locationSearch.subscribe(onNext: { isLocationSearch in
            self.topStackConstraint.constant = isLocationSearch ? self.view.frame.size.height - 56 : 287
            self.locationSearchWidthConstraint.constant = isLocationSearch ? UIScreen.main.bounds.size.width - 122 : 37
            self.winSlideShow.isHidden = isLocationSearch
            self.navigationView.isHidden = isLocationSearch
            self.locationSearchTextfieldConstraint.constant = isLocationSearch ? 8 : -133
            self.locationStackView.isHidden = !isLocationSearch
            
            if isLocationSearch && self.stackView.arrangedSubviews.count > 1 {
                self.stackView.arrangedSubviews[1].removeFromSuperview()
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        
        searchTextfield
            .rx
            .text
            .throttle(2, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: { text in
            if let value = text {
                self.viewModel.keywords.accept(value)
                self.viewModel.fetchSearchData()
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        
        viewModel.searchItem.bind(to: searchCollectionView.rx.items(cellIdentifier: "HomeCategoryCell", cellType: HomeCategoryCell.self)) { (indexPath, data, cell) in
            cell.data = data
            cell.width = Int(((UIScreen.main.bounds.size.width - 40)/2) - 8)
        }.disposed(by: disposeBag)
        
        searchCollectionView
        .rx
        .itemSelected
            .subscribe(onNext:{ indexPath in
                if self.viewModel.categoryItem.value[indexPath.row].levelId == 5 {
                    self.routeToLocationDetail(id: self.viewModel.categoryItem.value[indexPath.row].id, levelId: self.viewModel.categoryItem.value[indexPath.row].levelId)
                } else {
                    self.routeToItemDetail(
                        id: self.viewModel.searchItem.value[indexPath.row].categoryId,
                        typeId: self.viewModel.searchItem.value[indexPath.row].typeId,
                        name: self.viewModel.searchItem.value[indexPath.row].name,
                        levelId: self.viewModel.categoryItem.value[indexPath.row].levelId
                    )
                }
            }).disposed(by: disposeBag)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.routeToPromoDetail(_:)))
        winSlideShow.addGestureRecognizer(tap)
        
        viewModel.nearByItem.subscribe(onNext: { nearByItems in
            if !self.viewModel.isLocationSearch {
                self.resetStackView()
                self.topStackConstraint.constant = self.viewModel.search.value ? 75 : 287
                
                for nearByItem in nearByItems {
                    self.addCategorySection(title: nearByItem.0, list: nearByItem.1)
                }
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        
        viewModel.locationByItem.subscribe(onNext: { nearByItems in
            if self.viewModel.isLocationSearch {
                self.resetStackView()
                self.topStackConstraint.constant = CGFloat(nearByItems.count * 275)
                for nearByItem in nearByItems {
                    self.addCategoryLocationSection(title: nearByItem.0, list: nearByItem.1)
                }
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
    }
    
    func setupLayer() {
        guard shadowLayer == nil else {
            return
        }
        
        let shadowLayer = CAShapeLayer()
        shadowLayer.path = UIBezierPath(roundedRect: winSlideShow.bounds, cornerRadius: 8).cgPath
        shadowLayer.fillColor = UIColor.white.cgColor
        shadowLayer.shadowColor = UIColor.black.cgColor
        shadowLayer.shadowPath = shadowLayer.path
        shadowLayer.shadowOffset = CGSize(width: 1.0, height: 3.0)
        shadowLayer.shadowOpacity = 0.2
        shadowLayer.shadowRadius = 3
        winSlideShow.layer.insertSublayer(shadowLayer, at: 0)
    }
    
    func categoryDetail() {
        let categoryLabel = UILabel(frame: .zero)
        let containerView = UIView(frame: .zero)
        let lineView = UIView(frame: .zero)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: (UIScreen.main.bounds.size.width - 40) / 2, height: 191)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.register(UINib(nibName: "HomeCategoryCell", bundle: nil), forCellWithReuseIdentifier: "HomeCategoryCell")
        
        viewModel.categoryItem.bind(to: collectionView.rx.items(cellIdentifier: "HomeCategoryCell", cellType: HomeCategoryCell.self)) { (indexPath, data, cell) in
            cell.data = data
            cell.width = Int(((UIScreen.main.bounds.size.width - 40)/2) - 8)
        }.disposed(by: disposeBag)
        
        collectionView
        .rx
        .itemSelected
            .subscribe(onNext:{ indexPath in
                if self.viewModel.categoryItem.value[indexPath.row].levelId == 5 {
                    self.routeToLocationDetail(id: self.viewModel.categoryItem.value[indexPath.row].id, levelId: self.viewModel.categoryItem.value[indexPath.row].levelId)
                } else {
                    self.routeToItemDetail(
                    id: self.viewModel.categoryItem.value[indexPath.row].categoryId,
                    typeId: self.viewModel.categoryItem.value[indexPath.row].typeId,
                    name: self.viewModel.categoryItem.value[indexPath.row].name,
                    levelId: self.viewModel.categoryItem.value[indexPath.row].levelId
                    )
                }
            }).disposed(by: disposeBag)
        
        lineView.backgroundColor = UIColor(hexString: "#D2D2D2")
        
        
        categoryLabel.text = title
        categoryLabel.font = UIFont(name: "Nunito-SemiBold", size: 30)
        categoryLabel.numberOfLines = 0
        categoryLabel.textColor = UIColor(hexString: "#A7A7A7")
        
        containerView.addSubview(categoryLabel)
        containerView.addSubview(lineView)
        containerView.addSubview(collectionView)
        
        stackView.addArrangedSubview(containerView)
        
        constrain(containerView, categoryLabel) { containerView, categoryLabel in
            categoryLabel.right == containerView.right - 20
            categoryLabel.top == containerView.top + 8
        }
        
        constrain(containerView, collectionView, categoryLabel) { containerView, collectionView, categoryLabel in
            collectionView.right == containerView.right - 20
            collectionView.left == containerView.left + 20
            collectionView.top == categoryLabel.bottom + 12
            collectionView.height == UIScreen.main.bounds.size.height - 287
            collectionView.bottom == containerView.bottom - 12
        }
        
        constrain(containerView, lineView, categoryLabel) { containerView, lineView, categoryLabel in
            lineView.left == containerView.left + 20
            lineView.right == categoryLabel.left - 16
            lineView.centerY == categoryLabel.centerY
            lineView.height == 1
        }
    }
    
    func addCategorySection(title: String, list: [HomeCategoryCellViewModel]) {
        let categoryLabel = UILabel(frame: .zero)
        let containerView = UIView(frame: .zero)
        containerView.backgroundColor = .white
        let lineView = UIView(frame: .zero)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 8
        layout.itemSize = CGSize(width: 168, height: 191)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.register(UINib(nibName: "HomeCategoryCell", bundle: nil), forCellWithReuseIdentifier: "HomeCategoryCell")
        let data = BehaviorRelay<[HomeCategoryCellViewModel]>(value: list)
        
        data.bind(to: collectionView.rx.items(cellIdentifier: "HomeCategoryCell", cellType: HomeCategoryCell.self)) { (indexPath, data, cell) in
            cell.data = data
            cell.width = 160
        }.disposed(by: disposeBag)
        
        collectionView
        .rx
        .itemSelected
            .subscribe(onNext:{ indexPath in
                let value = list[indexPath.row]
                if value.levelId == 5 {
                    self.routeToLocationDetail(id: value.id, levelId: value.levelId)
                } else {
                    self.routeToItemDetail(id: value.categoryId,
                    typeId: value.typeId,
                    name: value.name,
                    levelId: value.levelId)
                }
            }).disposed(by: disposeBag)
        
        lineView.backgroundColor = UIColor(hexString: "#D2D2D2")
        
        categoryLabel.text = title
        categoryLabel.font = UIFont(name: "Nunito-SemiBold", size: 30)
        categoryLabel.numberOfLines = 0
        categoryLabel.textColor = UIColor(hexString: "#A7A7A7")
        
        let emptyView = UIView(frame: .zero)

        let emptyImageView = UIImageView(frame: .zero)
        emptyImageView.image = UIImage(named: "EmptyNearBy")
        
        let emptyLabel = UILabel(frame: .zero)
        emptyLabel.text = "nearby-empty".localized()
        emptyLabel.textColor = UIColor(hexString: "#ABABAB")
        emptyLabel.font = UIFont(name: "Nunito-Regular", size: 17)
        
        emptyView.addSubview(emptyImageView)
        emptyView.addSubview(emptyLabel)
        
        containerView.addSubview(categoryLabel)
        containerView.addSubview(lineView)
        containerView.addSubview(collectionView)
        containerView.addSubview(emptyView)
        
        stackView.addArrangedSubview(containerView)
        
        constrain(containerView, categoryLabel) { containerView, categoryLabel in
            categoryLabel.right == containerView.right - 20
            categoryLabel.top == containerView.top + 8
        }
        
        constrain(containerView, collectionView, categoryLabel) { containerView, collectionView, categoryLabel in
            collectionView.right == containerView.right - 20
            collectionView.left == containerView.left + 20
            collectionView.top == categoryLabel.bottom + 12
            collectionView.height == 191
            collectionView.bottom == containerView.bottom - 12
        }
        
        constrain(containerView, lineView, categoryLabel) { containerView, lineView, categoryLabel in
            lineView.left == containerView.left + 20
            lineView.right == categoryLabel.left - 16
            lineView.centerY == categoryLabel.centerY
            lineView.height == 1
        }
        
        constrain(containerView, emptyView, emptyImageView, emptyLabel) { containerView, emptyView, emptyImageView, emptyLabel in
            emptyImageView.width == 70
            emptyImageView.height == 70
            emptyLabel.top == emptyImageView.bottom + 6
            emptyLabel.left == emptyView.left
            emptyLabel.right == emptyView.right
            emptyLabel.bottom == emptyView.bottom
            emptyImageView.top == emptyView.top
            emptyImageView.centerX == emptyView.centerX
            emptyView.centerX == containerView.centerX
            emptyView.centerY == containerView.centerY
        }
        
        emptyView.isHidden = !list.isEmpty
    }
    
    func addCategoryLocationSection(title: String, list: [HomeCategoryCellViewModel]) {
        let categoryLabel = UILabel(frame: .zero)
        let containerView = UIView(frame: .zero)
        containerView.backgroundColor = .white
        let lineView = UIView(frame: .zero)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 8
        layout.itemSize = CGSize(width: 168, height: 191)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.register(UINib(nibName: "HomeCategoryCell", bundle: nil), forCellWithReuseIdentifier: "HomeCategoryCell")
        let data = BehaviorRelay<[HomeCategoryCellViewModel]>(value: list)
        
        data.bind(to: collectionView.rx.items(cellIdentifier: "HomeCategoryCell", cellType: HomeCategoryCell.self)) { (indexPath, data, cell) in
            cell.data = data
            cell.width = 160
        }.disposed(by: disposeBag)
        
        collectionView
        .rx
        .itemSelected
            .subscribe(onNext:{ indexPath in
                if self.viewModel.categoryItem.value[indexPath.row].levelId == 5 {
                    self.routeToLocationDetail(id: self.viewModel.categoryItem.value[indexPath.row].id, levelId: self.viewModel.categoryItem.value[indexPath.row].levelId)
                } else {
                    self.routeToItemDetail(id: list[indexPath.row].categoryId,
                    typeId: list[indexPath.row].typeId,
                    name: list[indexPath.row].name,
                    levelId: self.viewModel.categoryItem.value[indexPath.row].levelId)
                }
            }).disposed(by: disposeBag)
        
        lineView.backgroundColor = UIColor(hexString: "#D2D2D2")
        
        categoryLabel.text = title
        categoryLabel.font = UIFont(name: "Nunito-SemiBold", size: 30)
        categoryLabel.numberOfLines = 0
        categoryLabel.textColor = UIColor(hexString: "#A7A7A7")
        
        let emptyView = UIView(frame: .zero)

        let emptyImageView = UIImageView(frame: .zero)
        emptyImageView.image = UIImage(named: "EmptyNearBy")
        
        let emptyLabel = UILabel(frame: .zero)
        emptyLabel.text = "nearby-empty".localized()
        emptyLabel.textColor = UIColor(hexString: "#ABABAB")
        emptyLabel.font = UIFont(name: "Nunito-Regular", size: 17)
        
        emptyView.addSubview(emptyImageView)
        emptyView.addSubview(emptyLabel)
        
        containerView.addSubview(categoryLabel)
        containerView.addSubview(lineView)
        containerView.addSubview(collectionView)
        containerView.addSubview(emptyView)
        
        locationStackView.addArrangedSubview(containerView)
        
        constrain(containerView, categoryLabel) { containerView, categoryLabel in
            categoryLabel.right == containerView.right - 20
            categoryLabel.top == containerView.top + 8
        }
        
        constrain(containerView, collectionView, categoryLabel) { containerView, collectionView, categoryLabel in
            collectionView.right == containerView.right - 20
            collectionView.left == containerView.left + 20
            collectionView.top == categoryLabel.bottom + 12
            collectionView.height == 191
            collectionView.bottom == containerView.bottom - 12
        }
        
        constrain(containerView, lineView, categoryLabel) { containerView, lineView, categoryLabel in
            lineView.left == containerView.left + 20
            lineView.right == categoryLabel.left - 16
            lineView.centerY == categoryLabel.centerY
            lineView.height == 1
        }
        
        constrain(containerView, emptyView, emptyImageView, emptyLabel) { containerView, emptyView, emptyImageView, emptyLabel in
            emptyImageView.width == 70
            emptyImageView.height == 70
            emptyLabel.top == emptyImageView.bottom + 6
            emptyLabel.left == emptyView.left
            emptyLabel.right == emptyView.right
            emptyLabel.bottom == emptyView.bottom
            emptyImageView.top == emptyView.top
            emptyImageView.centerX == emptyView.centerX
            emptyView.centerX == containerView.centerX
            emptyView.centerY == containerView.centerY
        }
        
        emptyView.isHidden = !list.isEmpty
    }
    
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "informaton".localized(), message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func resetStackView() {
        for _ in 1..<stackView.arrangedSubviews.count {
            stackView.arrangedSubviews[1].removeFromSuperview()
        }
        
        for _ in 0..<locationStackView.arrangedSubviews.count {
            locationStackView.arrangedSubviews[0].removeFromSuperview()
        }
    }
}

// MARK: - MapLocationViewControllerDelegate

extension HomeViewController: MapLocationViewControllerDelegate {
    
    func mapLocationViewController(
        mapLocationViewController didFinish: MapLocationViewController,
        addressName: String,
        id: Int) {
        viewModel.isSearch = false
        searchTextfield.text = ""
        viewModel.isLocationSearch = true
        viewModel.locationSearchId = id
        viewModel.fetchLocationData()
        locationLabel.text = addressName
    }
}

// MARK: - ImageSliderDelegate

extension HomeViewController: ImageSlideshowDelegate {
    
    func imageSlideshow(_ imageSlideshow: ImageSlideshow, didChangeCurrentPageTo page: Int) {
        viewModel.selectPromoId(index: page)
    }
}

// MARK: - CLLocationManagerDelegate

extension HomeViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let value: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        viewModel.userCoordinate = value
        locationManager.stopUpdatingLocation()
    }
}
