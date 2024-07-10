//
//  ItemCartViewController.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 06/03/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import Agrume
import CoreLocation
import RxCocoa
import RxSwift
import SVProgressHUD
import UIKit

class ItemCartViewController: MixogyBaseViewController {

    @IBOutlet var coverImageView: UIImageView!
    @IBOutlet var categoryLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var locationView: UIView!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var locationTitleLabel: UILabel!
    @IBOutlet var dateTitleLabel: UILabel!
    @IBOutlet var typeTitleLabel: UILabel!
    @IBOutlet var photoTitleLabel: UILabel!
    @IBOutlet var itemLocationLabel: UILabel!
    @IBOutlet var distanceLabel: UILabel!
    @IBOutlet var firstTrackLabel: UILabel!
    @IBOutlet var secondTrackLabel: UILabel!
    @IBOutlet var typeLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var seatLabel: UILabel!
    @IBOutlet var seatTitleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var descriptionTitleLabel: UILabel!
    @IBOutlet var originalPriceLabel: UILabel!
    @IBOutlet var sellerPriceLabel: UILabel!
    @IBOutlet var titleViews: [UIVisualEffectView]!
    @IBOutlet var frontImageView: UIImageView!
    @IBOutlet var backImageView: UIImageView!
    @IBOutlet var frontImageButton: UIButton!
    @IBOutlet var backImageButton: UIButton!
    @IBOutlet var cartBackgroundImageView: UIImageView!
    @IBOutlet var cartCountLabel: UILabel!
    @IBOutlet var cartView: UIView!
    
    var disposeBag = DisposeBag()
    var viewModel = ItemCartViewModel()
    var gradientLayer = CAGradientLayer()
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupBinding()
    }
    
    override func setupLanguage() {
        locationTitleLabel.text = "location".localized()
        typeTitleLabel.text = "type".localized()
        dateTitleLabel.text = viewModel.level ?? 0 == 5 ? "Valid Until" : "date".localized()
        seatTitleLabel.text = "seat".localized()
        photoTitleLabel.text = "photos".localized()
        descriptionTitleLabel.text = "item-description".localized()
    }
    
    @IBAction func back(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    func showImage(path: String) {
        guard let url = URL(string: path) else {
            return
        }
        let agrume = Agrume(url: url, background: .blurred(.light))
        agrume.show(from: self)
    }
    
    @IBAction func addToCart(sender: UIButton) {
        if Preference.auth != nil {
            if CartUtil.isExist(id: viewModel.id ?? 0) {
                viewModel.removeCart()
            } else {
                viewModel.addToCart()
            }
        } else {
            routeToLogin()
        }
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
    
    func routeToLogin() {
        let loginViewController = LoginViewController(nibName: "LoginViewController", bundle: nil)
        loginViewController.from = .cart
        navigationController?.pushViewController(loginViewController, animated: true)
    }
}

extension ItemCartViewController {
    
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
        
        locationView.layer.cornerRadius = 4
        locationView.layer.borderColor = UIColor(hexString: "#CFCFCF").cgColor
        locationView.layer.borderWidth = 0.5
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
                self.locationLabel.text = value.locationPickUp
                self.distanceLabel.text = Distance.format(distance: Double(value.distance))
                self.typeLabel.text = value.type
                self.dateLabel.text = value.date
                self.descriptionLabel.text = value.description ?? "-"
                if let seat = value.itemSeat, !seat.isEmpty {
                    self.seatLabel.text = seat
                } else {
                    self.seatLabel.isHidden = true
                    self.seatTitleLabel.isHidden = true
                }
                
                self.itemLocationLabel.text = value.location
                var attributedString = NSMutableAttributedString(string: value.originalPrice.currencyFormat)
                
                attributedString.addAttribute(
                    NSAttributedString.Key.strikethroughColor,
                    value: UIColor.black,
                    range: NSMakeRange(0, attributedString.length)
                )
                
                attributedString.addAttribute(
                    NSAttributedString.Key.strikethroughStyle,
                    value: NSNumber(value: NSUnderlineStyle.single.rawValue),
                    range: NSMakeRange(0, attributedString.length)
                )
                self.originalPriceLabel.attributedText = attributedString
                self.sellerPriceLabel.text = value.sellerPrice.currencyFormat
                self.sellerPriceLabel.textColor = UIColor(hexString: value.sellerPrice  > value.originalPrice ? "#E25D5D" : "#21A99B")
                self.frontImageView.sd_setImage(
                    with: URL(string: value.photos.frontSide ?? ""),
                    placeholderImage: nil,
                    options: .refreshCached
                )
                self.backImageView.sd_setImage(
                    with: URL(string: value.photos.backSide ?? ""),
                    placeholderImage: nil,
                    options: .refreshCached
                )
                
                var attributedStringValue = "• "
                if value.collectionMethods[0].lowercased() == "ready to pick" {
                    attributedStringValue += "ready-to-pick".localized()
                } else if value.collectionMethods[0].lowercased() == "online item" {
                    attributedStringValue += "Online Item".localized()
                } else {
                    attributedStringValue += "delivery".localized()
                }
                
                attributedString = NSMutableAttributedString(string: attributedStringValue)
                
                attributedString.addAttribute(
                    NSAttributedString.Key.foregroundColor,
                    value: UIColor(hexString: "#21A99B"),
                    range: (attributedStringValue as NSString).range(of: "• ")
                )
                
                self.firstTrackLabel.attributedText = attributedString
                
                attributedStringValue = value.collectionMethods.count > 1 ? "• " + (value.collectionMethods[1].lowercased() == "ready to pick" ? "ready-to-pick".localized() : "delivery".localized()) : "-"
                attributedString = NSMutableAttributedString(string: attributedStringValue)
                
                attributedString.addAttribute(
                    NSAttributedString.Key.foregroundColor,
                    value: UIColor(hexString: "#21A99B"),
                    range: (attributedStringValue as NSString).range(of: "• ")
                )
                
                self.secondTrackLabel.attributedText = attributedString
                
                let colorTop = UIColor(hexString: "#59D9EC").cgColor
                let colorMiddle = UIColor(hexString: "#9EFFA4").cgColor
                let colorBottom = UIColor(hexString: "#26FF43").cgColor
                
                if CartUtil.isExist(id: self.viewModel.id ?? 0) {
                    let bounds = CGRect(x: 0, y: 0, width: 60, height: 60)
                    self.gradientLayer = CAGradientLayer()
                    self.gradientLayer.colors = [colorTop, colorMiddle ,colorBottom]
                    self.gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
                    self.gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
                    self.gradientLayer.cornerRadius = 4
                    self.gradientLayer.frame = bounds
                    self.cartView.layer.insertSublayer(self.gradientLayer, at: 0)
                } else {
                    if self.gradientLayer.superlayer != nil {
                        self.gradientLayer.removeFromSuperlayer()
                    }
                }
                
                if value.collectionMethods.first(where: { $0.lowercased() == "ready to pick" }) != nil {
                    self.locationView.isHidden = false
                } else {
                    self.locationView.isHidden = true
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
        
        viewModel.isSuccess.subscribe(onNext: { isSuccess in
            if isSuccess {
                self.viewModel.fetchData()
                self.showAlert(message: "data-saved".localized())
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
    }
    
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "informaton".localized(), message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func routeToDirection(sender: UIButton) {
        if let value = viewModel.data.value {
            if let url = URL(string: "comgooglemaps://"), UIApplication.shared.canOpenURL(url) {
                if let url = URL(string: "comgooglemaps-x-callback://?saddr=&daddr=\(value.locationPickUpLatitude ?? "0.0"),\(value.locationPickUpLongitude ?? "0.0")&directionsmode=driving") {
                    UIApplication.shared.open(url, options: [:])
                }
            } else {
                if let url = URL(string: "https://www.google.co.in/maps/dir/?saddr=&daddr=\(value.locationPickUpLatitude ?? "0.0"),\(value.locationPickUpLongitude ?? "0.0")&directionsmode=driving") {
                    UIApplication.shared.open(url, options: [:])
                }
            }
        }
    }

}

// MARK: - CLLocationManagerDelegate

extension ItemCartViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let value: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        viewModel.userCoordinate = value
        viewModel.fetchData()
        
        if Preference.auth != nil {
            viewModel.fetchCartData()
        }
        
        locationManager.stopUpdatingLocation()
    }
}

