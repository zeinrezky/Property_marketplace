//
//  ItemDetailViewController.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 06/03/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import Cartography
import CoreLocation
import RxCocoa
import RxSwift
import SVProgressHUD
import UIKit

class ItemDetailViewController: MixogyBaseViewController {

    @IBOutlet var coverImageView: UIImageView!
    @IBOutlet var categoryLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var locationTitleLabel: UILabel!
    @IBOutlet var typeTitleLabel: UILabel!
    @IBOutlet var dateTitleLabel: UILabel!
    @IBOutlet var originalPriceTitleLabel: UILabel!
    @IBOutlet var typeLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var availaibleLabel: UILabel!
    @IBOutlet var soldLabel: UILabel!
    @IBOutlet var availaibleTitlleLabel: UILabel!
    @IBOutlet var soldTitleLabel: UILabel!
    @IBOutlet var originalPriceLabel: UILabel!
    @IBOutlet var titleViews: [UIVisualEffectView]!
    @IBOutlet var stackView: UIStackView!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var cartBackgroundImageView: UIImageView!
    @IBOutlet var cartCountLabel: UILabel!
    
    var disposeBag = DisposeBag()
    var viewModel = ItemDetailViewModel()
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupBinding()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if Preference.auth != nil {
            if viewModel.userCoordinate != nil {
                viewModel.fetchData()
            }
        }
    }
    
    override func setupLanguage() {
        availaibleTitlleLabel.text = "available".localized()
        soldTitleLabel.text = "sold".localized()
        locationTitleLabel.text = "location".localized()
        typeTitleLabel.text = "type".localized()
        dateTitleLabel.text = viewModel.level ?? 0 == 5 ? "Valid Until" : "date".localized()
    }
    
    @IBAction func back(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func routeToCart(sender: UIButton) {
        if Preference.auth != nil {
//            (((UIApplication.shared.keyWindow?.rootViewController as! UINavigationController).viewControllers.first as! UITabBarController)).selectedIndex = 2
//            navigationController?.popToRootViewController(animated: true)
            let cartViewController = CartViewController(nibName: "CartViewController", bundle: nil)
            navigationController?.pushViewController(cartViewController, animated: true)
        } else {
            let loginViewController = LoginViewController(nibName: "LoginViewController", bundle: nil)
            loginViewController.from = .cart
            navigationController?.pushViewController(loginViewController, animated: true)
        }
    }
    
    @objc
    func addToCart(id: Int) {
        if Preference.auth != nil {
            viewModel.addToCart(id: id)
        } else {
            routeToLogin()
        }
    }
    
    func routeToLogin() {
        let loginViewController = LoginViewController(nibName: "LoginViewController", bundle: nil)
        loginViewController.from = .cart
        navigationController?.pushViewController(loginViewController, animated: true)
    }
    
    @objc
    func routeToDetailCart(id: Int) {
        let itemCartViewController = ItemCartViewController(nibName: "ItemCartViewController", bundle: nil)
        itemCartViewController.viewModel.id = id
        itemCartViewController.viewModel.level = viewModel.level
        navigationController?.hidesBottomBarWhenPushed = false
        navigationController?.pushViewController(itemCartViewController, animated: true)
    }
}

// MARK: - ItemDetailViewController

extension ItemDetailViewController {
    
    func setupUI() {
        
        for titleView in titleViews {
            titleView.layer.cornerRadius = 4
            titleView.clipsToBounds = true
        }
        
        locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
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
                    with: URL(string: value.photoUrl ?? ""),
                    placeholderImage: nil,
                    options: .refreshCached
                )
                
                self.categoryLabel.text = value.category
                self.nameLabel.text = value.name
                self.locationLabel.text = value.location
                self.typeLabel.text = value.type
                self.dateLabel.text = value.date
                self.originalPriceLabel.text = value.originalPrice.currencyFormat
                self.availaibleLabel.text = "\(value.available)"
                self.soldLabel.text = "\(value.sold)"
                
                while self.stackView.arrangedSubviews.count > 1 {
                    self.stackView.arrangedSubviews[1].removeFromSuperview()
                }
                
                for customerItem in value.customerItems.sorted(by: { $0.sellerPrice ?? 0 < $1.sellerPrice ?? 0 }) {
                    self.addItem(data: customerItem)
                }
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        
        viewModel.errorMessage.subscribe(onNext: { message in
            if let message = message {
                self.showAlert(message: message)
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        
        viewModel.cartCount.subscribe(onNext: { cartCount in
            self.cartCountLabel.text = cartCount
            
            if let cartCount = cartCount {
                self.cartBackgroundImageView.image = UIImage(named: !cartCount.isEmpty ? "FilledCart" : "CartTabBar")
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
    }
    
    func addItem(data: CustomerItem) {
        let stack = UIView(frame: .zero)
        let containerView = CustomerItemView(frame: .zero)
        let button = UIButton(frame: .zero)
        
        let sellerPriceTitleLabel = UILabel(frame: .zero)
        sellerPriceTitleLabel.text = "seller-price".localized()
        sellerPriceTitleLabel.textColor = UIColor(hexString: "#717171")
        sellerPriceTitleLabel.font = UIFont(name: "Nunito-ExtraLight", size: 12)
        
        let sellerPriceLabel = UILabel(frame: .zero)
        sellerPriceLabel.text = data.sellerPrice?.currencyFormat
        sellerPriceLabel.textColor = UIColor(hexString: (data.sellerPrice ?? 0) > (viewModel.data.value?.originalPrice ?? 0) ? "#E25D5D" : "#21A99B")
        sellerPriceLabel.font = UIFont(name: "Nunito-Regular", size: 14)
        sellerPriceLabel.numberOfLines = 0
        
        let distanceTitleLabel = UILabel(frame: .zero)
        distanceTitleLabel.text = "distance-to-agent".localized()
        distanceTitleLabel.textColor = UIColor(hexString: "#717171")
        distanceTitleLabel.font = UIFont(name: "Nunito-ExtraLight", size: 12)
        distanceTitleLabel.isHidden = data.sellTypeId == 2
        
        let distanceLabel = UILabel(frame: .zero)
        distanceLabel.text = Distance.format(distance: Double(data.distanceToAgent ?? 0))
        distanceLabel.textColor = UIColor(hexString: "#393939")
        distanceLabel.font = UIFont(name: "Nunito-Regular", size: 14)
        distanceLabel.numberOfLines = 0
        distanceLabel.isHidden = data.sellTypeId == 2
        
        let decriptionTitleLabel = UILabel(frame: .zero)
        decriptionTitleLabel.text = "decsription".localized()
        decriptionTitleLabel.textColor = UIColor(hexString: "#717171")
        decriptionTitleLabel.font = UIFont(name: "Nunito-ExtraLight", size: 12)
        decriptionTitleLabel.isHidden = data.sellTypeId == 2
        
        let decriptionLabel = UILabel(frame: .zero)
        decriptionLabel.text = data.description
        decriptionLabel.textColor = UIColor(hexString: "#393939")
        decriptionLabel.font = UIFont(name: "Nunito-Regular", size: 14)
        decriptionLabel.numberOfLines = 2
        
        let addonTitleLabel = UILabel(frame: .zero)
        addonTitleLabel.text = "added-on".localized()
        addonTitleLabel.textColor = UIColor(hexString: "#717171")
        addonTitleLabel.font = UIFont(name: "Nunito-ExtraLight", size: 12)
        
        let addonLabel = UILabel(frame: .zero)
        addonLabel.text = data.addedOn
        addonLabel.textColor = UIColor(hexString: "#393939")
        addonLabel.font = UIFont(name: "Nunito-Regular", size: 14)
        addonLabel.numberOfLines = 0
        
        let seatTitleLabel = UILabel(frame: .zero)
        seatTitleLabel.text = "item-seat".localized()
        seatTitleLabel.textColor = UIColor(hexString: "#717171")
        seatTitleLabel.font = UIFont(name: "Nunito-ExtraLight", size: 12)
        
        let secondTrackLabel = UILabel(frame: .zero)
        let seatLabel = UILabel(frame: .zero)
        seatLabel.text = data.itemSeat ?? "-"
        seatLabel.textColor = UIColor(hexString: "#393939")
        seatLabel.font = UIFont(name: "Nunito-Regular", size: 14)
        seatLabel.numberOfLines = 0
        
        let firstTrackLabel = UILabel(frame: .zero)
        firstTrackLabel.textColor = UIColor(hexString: "##717171")
        firstTrackLabel.font = UIFont(name: "Nunito-Light", size: 10)
        
        if let collection = data.collectionMethods {
            var value = "• "
            if collection[0].lowercased() == "ready to pick" {
                value += "ready-to-pick".localized()
            } else if collection[0].lowercased() == "online item" {
                value += "Online Item".localized()
            } else {
                value += "delivery".localized()
            }
            
            var attributedString = NSMutableAttributedString(string: value)
            
            attributedString.addAttribute(
                NSAttributedString.Key.foregroundColor,
                value: UIColor(hexString: "#21A99B"),
                range: (value as NSString).range(of: "• ")
            )
            
            firstTrackLabel.attributedText = attributedString
            
            value = collection.count > 1 ? "• " + (collection[1].lowercased() == "ready to pick" ? "ready-to-pick".localized() : "delivery".localized()) : "-"
            attributedString = NSMutableAttributedString(string: value)
            
            secondTrackLabel.textColor = UIColor(hexString: "#717171")
            secondTrackLabel.font = UIFont(name: "Nunito-Light", size: 10)
            
            attributedString.addAttribute(
                NSAttributedString.Key.foregroundColor,
                value: UIColor(hexString: "#21A99B"),
                range: (value as NSString).range(of: "• ")
            )
            
            secondTrackLabel.attributedText = attributedString
        }
        
        let cartView = UIView(frame: .zero)
        let cartImageView = UIImageView(frame: .zero)
        let cartButton = UIButton(frame: .zero)
        cartImageView.image = UIImage(named: "Cart")?.withRenderingMode(.alwaysTemplate)
        cartView.addSubview(cartImageView)
        
        if CartUtil.isExist(id: data.id) {
            let colorTop = UIColor(hexString: "#59D9EC").cgColor
            let colorMiddle = UIColor(hexString: "#9EFFA4").cgColor
            let colorBottom = UIColor(hexString: "#26FF43").cgColor
            let bounds = CGRect(x: 0, y: 0, width: 28, height: 22)
            let gradientLayer = CAGradientLayer()
            gradientLayer.colors = [colorTop, colorMiddle ,colorBottom]
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
            gradientLayer.cornerRadius = 7
            gradientLayer.frame = bounds
            cartView.layer.insertSublayer(gradientLayer, at: 0)
            cartImageView.tintColor = .white
        } else {
            cartView.layer.cornerRadius = 4
            cartView.layer.borderColor = UIColor(hexString: "#C7C7C7").cgColor
            cartView.layer.borderWidth = 1
            cartView.clipsToBounds = true
            cartImageView.tintColor = UIColor(hexString: "#C7C7C7")
        }
        
        containerView.addSubview(sellerPriceTitleLabel)
        containerView.addSubview(sellerPriceLabel)
        containerView.addSubview(distanceTitleLabel)
        containerView.addSubview(distanceLabel)
        containerView.addSubview(addonTitleLabel)
        containerView.addSubview(addonLabel)
        containerView.addSubview(seatTitleLabel)
        containerView.addSubview(seatLabel)
        containerView.addSubview(firstTrackLabel)
        containerView.addSubview(secondTrackLabel)
        containerView.addSubview(cartView)
        containerView.addSubview(button)
        containerView.addSubview(cartButton)
        containerView.addSubview(decriptionTitleLabel)
        containerView.addSubview(decriptionLabel)
        
        stack.addSubview(containerView)
        
        constrain(cartView, cartImageView) { cartView, cartImageView in
            cartImageView.left == cartView.left + 8
            cartImageView.right == cartView.right - 8
            cartImageView.top == cartView.top + 5
            cartImageView.bottom == cartView.bottom - 5
            cartImageView.height == 12
            cartImageView.width == 12
        }
        
        constrain(stack, containerView) { stack, containerView in
            containerView.left == stack.left + 20
            containerView.right == stack.right - 20
            containerView.top == stack.top + 5
            containerView.bottom == stack.bottom - 5
        }
        
        constrain(
        containerView,
        sellerPriceTitleLabel,
        sellerPriceLabel,
        distanceTitleLabel,
        distanceLabel,
        addonTitleLabel,
        addonLabel,
        seatTitleLabel,
        seatLabel) { containerView, sellerPriceTitleLabel, sellerPriceLabel, distanceTitleLabel,  distanceLabel, addonTitleLabel, addonLabel, seatTitleLabel, seatLabel in
            sellerPriceTitleLabel.left == containerView.left + 12
            sellerPriceTitleLabel.top == containerView.top + 10
            sellerPriceLabel.left == containerView.left + 12
            sellerPriceLabel.top == sellerPriceTitleLabel.bottom
            distanceTitleLabel.left == containerView.left + 12
            distanceTitleLabel.top == sellerPriceLabel.bottom + 4
            distanceLabel.left == containerView.left + 12
            distanceLabel.top == distanceTitleLabel.bottom
            addonTitleLabel.centerX == containerView.centerX
            sellerPriceTitleLabel.right == containerView.centerX - 8
            sellerPriceTitleLabel.right == sellerPriceLabel.right
            distanceTitleLabel.right == sellerPriceLabel.right
            distanceLabel.right == sellerPriceLabel.right
            addonLabel.left == addonTitleLabel.left
            addonLabel.top == sellerPriceLabel.top
            addonTitleLabel.top == sellerPriceTitleLabel.top
            seatTitleLabel.left == addonTitleLabel.left
            seatTitleLabel.top == sellerPriceLabel.bottom + 4
            seatLabel.left == addonTitleLabel.left
            seatLabel.top == seatTitleLabel.bottom
        }
            
        constrain(
        containerView,
        distanceLabel,
        decriptionTitleLabel, decriptionLabel, cartView) { containerView,  distanceLabel, decriptionTitleLabel, decriptionLabel, cartView in
            decriptionTitleLabel.left == containerView.left + 12
            decriptionTitleLabel.top == distanceLabel.bottom + 4
            decriptionLabel.left == containerView.left + 12
            decriptionLabel.top == decriptionTitleLabel.bottom
            decriptionLabel.bottom == containerView.bottom - 8
            decriptionLabel.right == cartView.left - 12
        }
        
        constrain(containerView, firstTrackLabel, secondTrackLabel, sellerPriceTitleLabel, cartView, cartButton) { containerView, firstTrackLabel, secondTrackLabel, sellerPriceTitleLabel, cartView, cartButton in
            firstTrackLabel.top == sellerPriceTitleLabel.top
            firstTrackLabel.right == containerView.right - 12
            secondTrackLabel.top == firstTrackLabel.bottom + 2
            secondTrackLabel.right == firstTrackLabel.right
            cartView.right == firstTrackLabel.right
            cartView.bottom == containerView.bottom - 12
            cartButton.right == firstTrackLabel.right
            cartButton.bottom == containerView.bottom - 12
        }
        
        constrain(containerView, button) { containerView, button in
            button.top == containerView.top
            button.right == containerView.right
            button.left == containerView.left
            button.bottom == containerView.bottom
        }
        
        button.rx.tap.subscribe(onNext: {
            self.routeToDetailCart(id: data.id)
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        
        cartButton.rx.tap.subscribe(onNext: {
            SVProgressHUD.show()
            if CartUtil.isExist(id: data.id) {
                if let layera = cartView.layer.sublayers?.first {
                    layera.removeFromSuperlayer()
                }
                
                cartImageView.tintColor = .white
                cartImageView.tintColor = UIColor(hexString: "#C7C7C7")
                cartView.layer.cornerRadius = 4
                cartView.layer.borderColor = UIColor(hexString: "#C7C7C7").cgColor
                cartView.layer.borderWidth = 1
                self.viewModel.removeCart(id: data.id)
            } else {
                let colorTop = UIColor(hexString: "#59D9EC").cgColor
                let colorMiddle = UIColor(hexString: "#9EFFA4").cgColor
                let colorBottom = UIColor(hexString: "#26FF43").cgColor
                let bounds = CGRect(x: 0, y: 0, width: 28, height: 22)
                let gradientLayer = CAGradientLayer()
                gradientLayer.colors = [colorTop, colorMiddle ,colorBottom]
                gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
                gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
                gradientLayer.cornerRadius = 7
                gradientLayer.frame = bounds
                cartView.layer.insertSublayer(gradientLayer, at: 0)
                cartImageView.tintColor = .white
                self.addToCart(id: data.id)
            }
            
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        
        stackView.addArrangedSubview(stack)
    }
    
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "informaton".localized(), message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

// MARK: - CLLocationManagerDelegate

extension ItemDetailViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let value: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        viewModel.userCoordinate = value
        viewModel.fetchData()
        locationManager.stopUpdatingLocation()
    }
}
