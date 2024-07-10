//
//  CartViewController.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 01/03/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import Cartography
import EzPopup
import RxCocoa
import RxSwift
import SDWebImage
import SVProgressHUD
import UIKit

class CartViewController: MixogyBaseViewController {

    @IBOutlet var stackView: UIStackView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var clearLabel: UILabel!
    
    let deliveryFeeLabel = UILabel(frame: .zero)
    let transactionFeeLabel = UILabel(frame: .zero)
    let payLabel = UILabel(frame: .zero)
    let subTotalLabel = UILabel(frame: .zero)
    let deliveryAddressView = UIView(frame: .zero)
    let batchPickupAddressView = UIView(frame: .zero)
    let payView = UIView(frame: .zero)
    let deliveryAddressLabel = UILabel(frame: .zero)
    let batchPickupLabel = UILabel(frame: .zero)
    let batchPickupAddressLabel = UILabel(frame: .zero)
    
    var deliveryConstrain: ConstraintGroup?
    var disposeBag = DisposeBag()
    var viewModel = CartViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupBinding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.isHidden = false
        tabBarController?.tabBar.isHidden = false
        
        tabBarItem.title = nil
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.isNavigationBarHidden = true
        navigationController?.navigationBar.isHidden = true
        
        if isMovingToParent {
            navigationController?.popToRootViewController(animated: true)
        }
        
        tabBarItem.title = nil
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if view.tag == 0 {
            deliveryFeeLabel.text = 0.currencyFormat
            transactionFeeLabel.text = 0.currencyFormat
            payLabel.text = 0.currencyFormat
            viewModel.total = 0
            subTotalLabel.text = 0.currencyFormat
            viewModel.fetchData()
        } else {
            view.tag = 0
        }
        
        tabBarItem.title = nil
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let colorTop = UIColor(hexString: "#59D9EC").cgColor
        let colorMiddle = UIColor(hexString: "#9EFFA4").cgColor
        let colorBottom = UIColor(hexString: "#26FF43").cgColor
        let bounds = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width - 40, height: 36)
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorMiddle ,colorBottom]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
        gradientLayer.cornerRadius = 7
        gradientLayer.frame = bounds
        
        let shadowLayer = CAShapeLayer()
        shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: 7).cgPath
        shadowLayer.fillColor = UIColor.white.cgColor
        shadowLayer.shadowColor = UIColor.lightGray.cgColor
        shadowLayer.shadowPath = shadowLayer.path
        shadowLayer.shadowOpacity = 0.2
        shadowLayer.shadowRadius = 7

        payView.layer.insertSublayer(gradientLayer, at: 0)
        payView.layer.insertSublayer(shadowLayer, at: 0)
        
        let deliveryAddressViewShadowLayer = CAShapeLayer()
        deliveryAddressViewShadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: 7).cgPath
        deliveryAddressViewShadowLayer.fillColor = UIColor.white.cgColor
        deliveryAddressViewShadowLayer.shadowColor = UIColor.lightGray.cgColor
        deliveryAddressViewShadowLayer.shadowPath = deliveryAddressViewShadowLayer.path
        deliveryAddressViewShadowLayer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        deliveryAddressViewShadowLayer.shadowOpacity = 0.2
        deliveryAddressViewShadowLayer.shadowRadius = 3
        
        deliveryAddressView.layer.insertSublayer(deliveryAddressViewShadowLayer, at: 0)
        
        let batchPickupAddressViewShadowLayer = CAShapeLayer()
        batchPickupAddressViewShadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: 7).cgPath
        batchPickupAddressViewShadowLayer.fillColor = UIColor.white.cgColor
        batchPickupAddressViewShadowLayer.shadowColor = UIColor.lightGray.cgColor
        batchPickupAddressViewShadowLayer.shadowPath = batchPickupAddressViewShadowLayer.path
        batchPickupAddressViewShadowLayer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        batchPickupAddressViewShadowLayer.shadowOpacity = 0.2
        batchPickupAddressViewShadowLayer.shadowRadius = 3
        
        batchPickupAddressView.layer.insertSublayer(batchPickupAddressViewShadowLayer, at: 0)
    }
    
    override func setupLanguage() {
        navigationItem.title = "cart".localized()
        clearLabel.text = "clear-all".localized()
        tabBarItem.title = nil
    }
    
    @IBAction func clearAll(sender: UIButton) {
        viewModel.clearAll()
    }
    
    @objc
    func pay() {
        viewModel.pay()
    }
    
    @objc
    func rrouteToBatchPickup() {
        view.tag = 1
        let batchPickupViewController = BatchPickupViewController(nibName: "BatchPickupViewController", bundle: nil)
        batchPickupViewController.delegate = self
        navigationController?.pushViewController(batchPickupViewController, animated: true)
    }
    
    @objc
    func routeToAddress() {
        view.tag = 1
        let deliveryAddressViewController = DeliveryAddressViewController(nibName: "DeliveryAddressViewController", bundle: nil)
        deliveryAddressViewController.delegate = self
        navigationController?.pushViewController(deliveryAddressViewController, animated: true)
    }
}

// MARK: - CartViewController

fileprivate extension CartViewController {
    
    func setupUI() {
        tabBarItem.title = nil
    }
    
    func setupBinding() {
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
        
        viewModel.data.subscribe(onNext: { data in
            if let value = data, !value.customerItems.isEmpty {
                self.view.backgroundColor = UIColor(hexString: "#E5E5E5")

                while self.stackView.arrangedSubviews.count > 3 {
                    self.stackView.arrangedSubviews[1].removeFromSuperview()
                }
                
                for item in value.customerItems {
                    self.addItem(data: item)
                }

                self.addCollectionViewTitle()
                self.addCollectionViewAll()
                self.addDeliveryFee()
                self.addPayView()
                self.stackView.isHidden = false
            } else {
                self.view.backgroundColor = .white
                self.stackView.isHidden = true
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        
        viewModel.isSuccess.subscribe(onNext: { isSuccess in
            if isSuccess {
                self.navigationController?.popToRootViewController(animated: true)
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        
        viewModel.isRemoveCartSuccess.subscribe(onNext: { isSuccess in
            if isSuccess {
                self.viewModel.fetchData()
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        
        viewModel.isPaySuccess.subscribe(onNext: { isSuccess in
            if isSuccess {
                let paymentMethodViewController = PaymentMethodViewController(nibName: "PaymentMethodViewController", bundle: nil)
                paymentMethodViewController.viewModel.amount = self.viewModel.total
                paymentMethodViewController.viewModel.transactionCode = self.viewModel.checkourAddResponse?.orderId
                paymentMethodViewController.viewModel.orderid = self.viewModel.checkourAddResponse?.transactionId
                self.navigationController?.pushViewController(paymentMethodViewController, animated: true)
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        
        viewModel.deliveryFee.subscribe(onNext: { fee in
            if let value = self.viewModel.data.value, !value.customerItems.isEmpty {
                self.calculateFee(fee: fee)
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
    }
    
    func addItem(data: CartCustomerItemResponse) {
        let view = UIView(frame: .zero)
        view.backgroundColor = .white
        
        let coverImageView = UIImageView(frame: .zero)
        coverImageView.backgroundColor = .lightGray
        coverImageView.sd_setImage(
            with: URL(string: data.photoURL),
            placeholderImage: nil,
            options: .refreshCached
        )
        
        let titleLabel = UILabel(frame: .zero)
        titleLabel.text = data.name
        titleLabel.textColor = UIColor(hexString: "#393939")
        titleLabel.font = UIFont(name: "Nunito-Regular", size: 16)
        titleLabel.numberOfLines = 0
        
        let oldPriceLabel = UILabel(frame: .zero)
        oldPriceLabel.textColor = UIColor(hexString: "#21A99B")
        oldPriceLabel.font = UIFont(name: "Nunito-Regular", size: 8)
        oldPriceLabel.numberOfLines = 0
        
        var attributedString = NSMutableAttributedString(string: data.originalPrice.currencyFormat)
        
        attributedString.addAttribute(
            NSAttributedString.Key.strikethroughColor,
            value: UIColor(hexString: "#21A99B"),
            range: NSMakeRange(0, attributedString.length)
        )
        
        attributedString.addAttribute(
            NSAttributedString.Key.strikethroughStyle,
            value: NSNumber(value: NSUnderlineStyle.single.rawValue),
            range: NSMakeRange(0, attributedString.length)
        )
        
        oldPriceLabel.attributedText = attributedString
        
        let newPriceLabel = UILabel(frame: .zero)
        newPriceLabel.text = data.sellerPrice.currencyFormat
        newPriceLabel.textColor = UIColor(hexString: "#21A99B")
        newPriceLabel.font = UIFont(name: "Nunito-Regular", size: 14)
        newPriceLabel.numberOfLines = 0
        
        let collectionMethodLabel = UILabel(frame: .zero)
        collectionMethodLabel.textColor = UIColor(hexString: "#393939")
        collectionMethodLabel.font = UIFont(name: "Nunito-Regular", size: 10)
        collectionMethodLabel.numberOfLines = 0
        
        let attributedStringValue = "• " + (data.collectionMethods.first ?? "")
        attributedString = NSMutableAttributedString(string: attributedStringValue)
        
        attributedString.addAttribute(
            NSAttributedString.Key.foregroundColor,
            value: UIColor(hexString: "#21A99B"),
            range: (attributedStringValue as NSString).range(of: "• ")
        )
        
        collectionMethodLabel.attributedText = attributedString
        
        let checkView = UIView(frame: .zero)
        checkView.layer.cornerRadius = 5
        checkView.layer.borderColor = UIColor(hexString: "#464646").cgColor
        checkView.layer.borderWidth = 1.0
        
        let checkImageView = UIImageView(frame: .zero)
        
        let checkButton = UIButton(frame: .zero)
        checkButton.rx.tap.subscribe(onNext: {
            if checkButton.tag == 0 {
                self.viewModel.selectedData.append(data)
                checkButton.tag = 1
                checkView.backgroundColor = UIColor(hexString: "#464646")
                checkImageView.image = UIImage(named: "Check")?.withRenderingMode(.alwaysTemplate)
                checkView.tintColor = .white
            } else {
                self.viewModel.selectedData.removeAll(where: { $0.customerItemId == data.customerItemId })
                checkButton.tag = 0
                checkView.backgroundColor = .white
                checkImageView.image = UIImage()
                checkView.tintColor = .clear
            }
            
            self.calculateFee(fee: self.viewModel.deliveryFee.value)
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.disposeBag)
        
        checkView.addSubview(checkImageView)
        checkView.addSubview(checkButton)
        
        view.addSubview(coverImageView)
        view.addSubview(titleLabel)
        view.addSubview(oldPriceLabel)
        view.addSubview(newPriceLabel)
        view.addSubview(checkView)
        view.addSubview(collectionMethodLabel)
        
        constrain(coverImageView) { coverImageView in
            coverImageView.height == 55
            coverImageView.width == 55
        }
        
        constrain(newPriceLabel, collectionMethodLabel) { newPriceLabel, collectionMethodLabel in
            collectionMethodLabel.left == newPriceLabel.right + 16
            collectionMethodLabel.centerY == newPriceLabel.centerY
        }
        
        constrain(checkView, checkButton, checkImageView) { checkView, checkButton, checkImageView in
            checkView.height == 24
            checkView.width == 24
            checkButton.left == checkView.left
            checkButton.right == checkView.right
            checkButton.top == checkView.top
            checkButton.bottom == checkView.bottom
            checkImageView.left == checkView.left
            checkImageView.right == checkView.right
            checkImageView.top == checkView.top
            checkImageView.bottom == checkView.bottom
        }
        
        constrain(view, coverImageView, titleLabel, oldPriceLabel, newPriceLabel, checkView) { view, coverImageView, titleLabel, oldPriceLabel, newPriceLabel, checkView in
            titleLabel.top == view.top + 24
            oldPriceLabel.top == titleLabel.bottom + 4
            newPriceLabel.top == oldPriceLabel.bottom + 4
            newPriceLabel.bottom == view.bottom - 24
            checkView.centerY == view.centerY
            coverImageView.left == view.left + 20
            titleLabel.left == coverImageView.right + 16
            oldPriceLabel.left == coverImageView.right + 16
            newPriceLabel.left == coverImageView.right + 16
            checkView.right == view.right - 20
            titleLabel.right == checkView.left - 16
            oldPriceLabel.right == checkView.left - 16
            coverImageView.top == titleLabel.top
        }
        
        addSeparatorView()
        stackView.addArrangedSubview(view)
    }
    
    func addCollectionViewAll(isPickup: Bool = false, isDelivery: Bool = false, isBatch: Bool = false, isOnline: Bool = false) {
        
        if let pickup = viewModel.collectionMethodResponseList.first(where: { $0.id == 1 }), pickup.status == 1 {
            self.addCollectionMethodViewPickup(isPickup: isPickup)
        }
        
        if let batch = viewModel.collectionMethodResponseList.first(where: { $0.id == 2 }), batch.status == 1 {
            self.addCollectionMethodViewBatch(isBatch: isBatch)
        }
        
        if let delivery = viewModel.collectionMethodResponseList.first(where: { $0.id == 3 }), delivery.status == 1 {
            self.addCollectionMethodViewDelivery(isDelivery: isDelivery)
        }
        
        if let delivery = viewModel.collectionMethodResponseList.first(where: { $0.id == 4 }), delivery.status == 1 {
            self.addCollectionMethodViewOnline(isOnline: isOnline)
        }
    }
    
    func resetMethod() {
        let itemCount = self.viewModel.data.value?.customerItems.count ?? 0
        if let pickup = viewModel.collectionMethodResponseList.first(where: { $0.id == 1 }), pickup.status == 1 {
            for stack in self.stackView.arrangedSubviews {
                if stack.tag == 221 {
                    self.stackView.removeArrangedSubview(stack)
                    stack.removeFromSuperview()
                }
            }
        }
        
        if let batch = viewModel.collectionMethodResponseList.first(where: { $0.id == 2 }), batch.status == 1 {
            for stack in self.stackView.arrangedSubviews {
                if stack.tag == 222 {
                    self.stackView.removeArrangedSubview(stack)
                    stack.removeFromSuperview()
                }
            }
        }
        
        if let delivery = viewModel.collectionMethodResponseList.first(where: { $0.id == 3 }), delivery.status == 1 {
            for stack in self.stackView.arrangedSubviews {
                if stack.tag == 223 {
                    self.stackView.removeArrangedSubview(stack)
                    stack.removeFromSuperview()
                }
            }
        }
        
        if let delivery = viewModel.collectionMethodResponseList.first(where: { $0.id == 4 }), delivery.status == 1 {
            for stack in self.stackView.arrangedSubviews {
                if stack.tag == 224 {
                    self.stackView.removeArrangedSubview(stack)
                    stack.removeFromSuperview()
                }
            }
        }
    }
    
    func addCollectionViewTitle() {
        let containerView = UIView(frame: .zero)
        containerView.backgroundColor = .white
        
        let titleLabel = UILabel(frame: .zero)
        titleLabel.text = "collection-method".localized()
        titleLabel.textColor = UIColor(hexString: "#393939")
        titleLabel.font = UIFont(name: "Nunito-Regular", size: 18)
        
        let lineView = UIView(frame: .zero)
        lineView.backgroundColor = UIColor(hexString: "#E5E5E5")
        
        containerView.addSubview(titleLabel)
        containerView.addSubview(lineView)
        
        constrain(containerView, titleLabel, lineView) { containerView, titleLabel, lineView in
            titleLabel.right == containerView.right - 20
            titleLabel.left == containerView.left + 20
            titleLabel.top == containerView.top + 12
            lineView.top == titleLabel.bottom + 12
            lineView.height == 1
            lineView.left == containerView.left
            lineView.right == containerView.right
            lineView.bottom == containerView.bottom
        }
        
        stackView.addArrangedSubview(containerView)
    }
    
    func addCollectionMethodViewPickup(isPickup: Bool = false) {
        let containerView = UIView(frame: .zero)
        containerView.backgroundColor = .white
        
        let pickupButton = UIButton(frame: .zero)
        let pickupLabel = UILabel(frame: .zero)
        pickupLabel.text = "pickup".localized()
        pickupLabel.textColor = isPickup ? UIColor.greenApp : UIColor(hexString: "#C6C6C6")
        pickupLabel.font = UIFont(name: "Nunito-Regular", size: 18)
        
        let pickupCircleView = UIView(frame: .zero)
        pickupCircleView.layer.cornerRadius = 10
        pickupCircleView.layer.borderColor = UIColor(hexString: "#DDDDDD").cgColor
        pickupCircleView.layer.borderWidth = 1
        pickupCircleView.backgroundColor = isPickup ? UIColor.greenApp : UIColor.clear
        
        containerView.addSubview(pickupLabel)
        containerView.addSubview(pickupCircleView)
        containerView.addSubview(pickupButton)
        
        let questionLabel = UILabel(frame: .zero)
        questionLabel.text = "?"
        questionLabel.textColor = .white
        questionLabel.textAlignment = .center
        questionLabel.font = UIFont(name: "Nunito-Bold", size: 15)
        questionLabel.backgroundColor = UIColor(hexString: "#F5D63D")
        
        let questionButton = UIButton(frame: .zero)
        
        containerView.addSubview(questionLabel)
        containerView.addSubview(questionButton)
        
        constrain(pickupLabel, questionLabel, questionButton) { pickupLabel, questionLabel, questionButton in
            questionLabel.width == 16
            questionLabel.height == 16
            questionButton.width == 16
            questionButton.height == 16
            questionLabel.centerY == pickupLabel.centerY
            questionLabel.left == pickupLabel.right + 10
            questionButton.top == questionLabel.top
            questionButton.left == questionLabel.left
            questionButton.right == questionLabel.right
            questionButton.bottom == questionLabel.bottom
        }
        
        constrain(containerView, pickupLabel, pickupButton, pickupCircleView) { containerView, pickupLabel, pickupButton, pickupCircleView in
            pickupLabel.top == containerView.top + 12
            pickupLabel.left == containerView.left + 20
            pickupLabel.bottom == containerView.bottom
            pickupCircleView.height == 20
            pickupCircleView.width == 20
            pickupCircleView.right == containerView.right - 24
            pickupCircleView.centerY == pickupLabel.centerY
            pickupButton.left == containerView.left + 20
            pickupButton.right == containerView.right - 20
            pickupButton.top == pickupLabel.top
            pickupButton.bottom == pickupLabel.bottom
        }
        
        pickupButton.rx.tap.subscribe(onNext: {
            if !isPickup {
                self.viewModel.deliveryFee.accept(0)
                self.viewModel.agentId = nil
                self.viewModel.collectionMethodId = 1
                self.resetMethod()
                self.addCollectionViewAll(isPickup: true)
                self.addDeliveryFee()
                self.addPayView()
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.disposeBag)
        
        questionButton.rx.tap.subscribe(onNext: {
            if let delivery = self.viewModel.collectionMethodResponseList
                .first(where: { $0.id == 1 }){
                let termAndConditionViewController = TermAndConditionViewController()
                termAndConditionViewController.value = delivery.description
                termAndConditionViewController.titleValue = delivery.name
                
                let popupVC = PopupViewController(
                    contentController: termAndConditionViewController,
                    popupWidth: UIScreen.main.bounds.size.width - 48,
                    popupHeight: UIScreen.main.bounds.size.height/2)
                self.present(popupVC, animated: true)
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.disposeBag)
        
        containerView.tag = 221
        questionLabel.layer.cornerRadius = 8
        questionLabel.clipsToBounds = true
        stackView.addArrangedSubview(containerView)
    }
    
    func addCollectionMethodViewDelivery(isDelivery: Bool = false) {
        let containerView = UIView(frame: .zero)
        containerView.backgroundColor = .white
        
        let deliveryButton = UIButton(frame: .zero)
        let deliveryLabel = UILabel(frame: .zero)
        deliveryLabel.text = "delivery".localized()
        deliveryLabel.textColor = isDelivery ? UIColor.greenApp : UIColor(hexString: "#C6C6C6")
        deliveryLabel.font = UIFont(name: "Nunito-Regular", size: 18)
        
        let deliveryCircleView = UIView(frame: .zero)
        deliveryCircleView.layer.cornerRadius = 10
        deliveryCircleView.layer.borderColor = UIColor(hexString: "#DDDDDD").cgColor
        deliveryCircleView.layer.borderWidth = 1
        deliveryCircleView.backgroundColor = isDelivery ? UIColor.greenApp : UIColor.clear
        
        let deliveryAddressButton = UIButton(frame: .zero)
        deliveryAddressLabel.text = "address".localized()
        deliveryAddressLabel.textColor = UIColor(hexString: "#000000")
        deliveryAddressLabel.font = UIFont(name: "Nunito-Bold", size: 15)
        let deliveryAddressImageView = UIImageView(frame: .zero)
        deliveryAddressImageView.image = UIImage(named: "PlacePin")
        
        deliveryAddressView.addSubview(deliveryAddressLabel)
        deliveryAddressView.addSubview(deliveryAddressImageView)
        deliveryAddressView.addSubview(deliveryAddressButton)
        
        deliveryAddressButton.rx.tap.subscribe(onNext: {
            self.routeToAddress()
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.disposeBag)
        
        let questionLabel = UILabel(frame: .zero)
        questionLabel.text = "?"
        questionLabel.textColor = .white
        questionLabel.textAlignment = .center
        questionLabel.font = UIFont(name: "Nunito-Bold", size: 15)
        questionLabel.backgroundColor = UIColor(hexString: "#F5D63D")
        
        let questionButton = UIButton(frame: .zero)
        
        constrain(deliveryAddressView, deliveryAddressLabel, deliveryAddressImageView, deliveryAddressButton) {
            deliveryAddressView, deliveryAddressLabel, deliveryAddressImageView, deliveryAddressButton in
            deliveryAddressLabel.left == deliveryAddressView.left + 12
            deliveryAddressView.height == 36
            deliveryAddressImageView.width == 14
            deliveryAddressImageView.height == 20
            deliveryAddressLabel.centerY == deliveryAddressView.centerY
            deliveryAddressImageView.centerY == deliveryAddressView.centerY
            deliveryAddressImageView.right == deliveryAddressView.right - 12
            deliveryAddressButton.right == deliveryAddressView.right
            deliveryAddressButton.left == deliveryAddressView.left
            deliveryAddressButton.top == deliveryAddressView.top
            deliveryAddressButton.bottom == deliveryAddressView.bottom
        }
        
        containerView.addSubview(deliveryLabel)
        containerView.addSubview(deliveryCircleView)
        containerView.addSubview(deliveryButton)
        containerView.addSubview(deliveryAddressView)
        containerView.addSubview(questionLabel)
        containerView.addSubview(questionButton)
        
        constrain(
        containerView,
        deliveryLabel,
        deliveryCircleView,
        deliveryAddressView,
        deliveryButton) { containerView, deliveryLabel, deliveryCircleView, deliveryAddressView, deliveryButton in
            deliveryLabel.top == containerView.top + 12
            deliveryLabel.left == containerView.left + 20
            deliveryAddressView.top == deliveryLabel.bottom + (isDelivery ? 12 : -36)
            deliveryAddressView.left == containerView.left + 20
            deliveryAddressView.right == containerView.right - 20
            deliveryAddressView.bottom == containerView.bottom - 12
            deliveryCircleView.height == 20
            deliveryCircleView.width == 20
            deliveryCircleView.right == containerView.right - 24
            deliveryCircleView.centerY == deliveryLabel.centerY
            deliveryButton.left == containerView.left + 20
            deliveryButton.right == containerView.right - 20
            deliveryButton.top == deliveryLabel.top
            deliveryButton.bottom == deliveryLabel.bottom
        }
        
        deliveryButton.rx.tap.subscribe(onNext: {
            if !isDelivery {
                self.viewModel.deliveryFee.accept(0)
                self.viewModel.agentId = nil
                self.viewModel.collectionMethodId = 3
                self.resetMethod()
                self.addCollectionViewAll(isDelivery: true)
                self.addDeliveryFee()
                self.addPayView()
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.disposeBag)
        
        questionButton.rx.tap.subscribe(onNext: {
            if let delivery = self.viewModel.collectionMethodResponseList
                .first(where: { $0.id == 3 }){
                let termAndConditionViewController = TermAndConditionViewController()
                termAndConditionViewController.value = delivery.description
                termAndConditionViewController.titleValue = delivery.name
                
                let popupVC = PopupViewController(
                    contentController: termAndConditionViewController,
                    popupWidth: UIScreen.main.bounds.size.width - 48,
                    popupHeight: UIScreen.main.bounds.size.height/2)
                self.present(popupVC, animated: true)
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.disposeBag)
        
        constrain(deliveryLabel, questionLabel, questionButton) { deliveryLabel, questionLabel, questionButton in
            questionLabel.width == 16
            questionLabel.height == 16
            questionButton.width == 16
            questionButton.height == 16
            questionLabel.centerY == deliveryLabel.centerY
            questionLabel.left == deliveryLabel.right + 10
            questionButton.top == questionLabel.top
            questionButton.left == questionLabel.left
            questionButton.right == questionLabel.right
            questionButton.bottom == questionLabel.bottom
        }
        
        deliveryAddressView.isHidden = !isDelivery
        containerView.tag = 222
        questionLabel.layer.cornerRadius = 8
        questionLabel.clipsToBounds = true
        stackView.addArrangedSubview(containerView)
    }
    
    func addCollectionMethodViewBatch(isBatch: Bool = false) {
        let containerView = UIView(frame: .zero)
        containerView.backgroundColor = .white
        
        let batchPickupButton = UIButton(frame: .zero)
        batchPickupLabel.text = "batch-pickup".localized()
        batchPickupLabel.textColor = isBatch ? UIColor.greenApp : UIColor(hexString: "#C6C6C6")
        batchPickupLabel.font = UIFont(name: "Nunito-Regular", size: 18)
        
        let questionLabel = UILabel(frame: .zero)
        questionLabel.text = "?"
        questionLabel.textColor = .white
        questionLabel.textAlignment = .center
        questionLabel.font = UIFont(name: "Nunito-Bold", size: 15)
        questionLabel.backgroundColor = UIColor(hexString: "#F5D63D")
        
        let questionButton = UIButton(frame: .zero)
        
        let batchPickupCircleView = UIView(frame: .zero)
        batchPickupCircleView.layer.cornerRadius = 10
        batchPickupCircleView.layer.borderColor = UIColor(hexString: "#DDDDDD").cgColor
        batchPickupCircleView.layer.borderWidth = 1
        batchPickupCircleView.backgroundColor = isBatch ? UIColor.greenApp : UIColor.clear
        
        let batchPickupAddressButton = UIButton(frame: .zero)
        batchPickupAddressLabel.text = "pickup-location".localized()
        batchPickupAddressLabel.textColor = UIColor(hexString: "#000000")
        batchPickupAddressLabel.font = UIFont(name: "Nunito-Bold", size: 15)
        let batchPickupAddressImageView = UIImageView(frame: .zero)
        batchPickupAddressImageView.image = UIImage(named: "PlacePin")
        
        batchPickupAddressView.addSubview(batchPickupAddressLabel)
        batchPickupAddressView.addSubview(batchPickupAddressImageView)
        batchPickupAddressView.addSubview(batchPickupAddressButton)
        
        batchPickupAddressButton.rx.tap.subscribe(onNext: {
            self.rrouteToBatchPickup()
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.disposeBag)
        
        constrain(batchPickupAddressView, batchPickupAddressLabel, batchPickupAddressImageView, batchPickupAddressButton) {
            batchPickupAddressView, batchPickupAddressLabel, batchPickupAddressImageView, batchPickupAddressButton in
            batchPickupAddressLabel.left == batchPickupAddressView.left + 12
            batchPickupAddressView.height == 36
            batchPickupAddressView.width == 14
            batchPickupAddressLabel.centerY == batchPickupAddressView.centerY
            batchPickupAddressImageView.centerY == batchPickupAddressView.centerY
            batchPickupAddressImageView.right == batchPickupAddressView.right - 12
            batchPickupAddressButton.right == batchPickupAddressView.right
            batchPickupAddressButton.left == batchPickupAddressView.left
            batchPickupAddressButton.top == batchPickupAddressView.top
            batchPickupAddressButton.bottom == batchPickupAddressView.bottom
        }
        containerView.addSubview(batchPickupLabel)
        containerView.addSubview(questionLabel)
        containerView.addSubview(batchPickupCircleView)
        containerView.addSubview(batchPickupAddressView)
        containerView.addSubview(batchPickupButton)
        containerView.addSubview(questionButton)
        
        batchPickupAddressView.isHidden = !isBatch
        
        constrain(
        containerView,
        batchPickupLabel,
        batchPickupCircleView) { containerView, batchPickupLabel, batchPickupCircleView in
            batchPickupLabel.left == containerView.left + 20
            batchPickupLabel.top == containerView.top
            batchPickupCircleView.height == 20
            batchPickupCircleView.width == 20
            batchPickupCircleView.right == containerView.right - 24
            batchPickupCircleView.centerY == batchPickupLabel.centerY
        }
        
        constrain(batchPickupLabel, questionLabel, questionButton) { batchPickupLabel, questionLabel, questionButton in
            questionLabel.width == 16
            questionLabel.height == 16
            questionButton.width == 16
            questionButton.height == 16
            questionLabel.centerY == batchPickupLabel.centerY
            questionLabel.left == batchPickupLabel.right + 10
            questionButton.top == questionLabel.top
            questionButton.left == questionLabel.left
            questionButton.right == questionLabel.right
            questionButton.bottom == questionLabel.bottom
        }
        
        constrain(containerView, batchPickupLabel, batchPickupButton) { containerView,  batchPickupLabel, batchPickupButton in
            batchPickupButton.left == containerView.left + 20
            batchPickupButton.right == containerView.right - 20
            batchPickupButton.top == batchPickupLabel.top
            batchPickupButton.bottom == batchPickupLabel.bottom
        }
        
        constrain(containerView, batchPickupLabel, batchPickupAddressView) { containerView, batchPickupLabel, batchPickupAddressView in
            batchPickupAddressView.left == containerView.left + 20
            batchPickupAddressView.right == containerView.right - 20
            batchPickupAddressView.top == batchPickupLabel.bottom + (isBatch ? 12 : -36)
            batchPickupAddressView.bottom == containerView.bottom - 12
        }
        
        batchPickupButton.rx.tap.subscribe(onNext: {
            if !isBatch {
                self.viewModel.deliveryFee.accept(0)
                self.viewModel.agentId = nil
                self.viewModel.collectionMethodId = 2
                self.resetMethod()
                self.addCollectionViewAll(isBatch: true)
                self.addDeliveryFee()
                self.addPayView()
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.disposeBag)
        
        questionButton.rx.tap.subscribe(onNext: {
            if let delivery = self.viewModel.collectionMethodResponseList
                .first(where: { $0.id == 2 }){
                let termAndConditionViewController = TermAndConditionViewController()
                termAndConditionViewController.value = delivery.description
                termAndConditionViewController.titleValue = delivery.name
                
                let popupVC = PopupViewController(
                    contentController: termAndConditionViewController,
                    popupWidth: UIScreen.main.bounds.size.width - 48,
                    popupHeight: UIScreen.main.bounds.size.height/2)
                self.present(popupVC, animated: true)
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.disposeBag)
            
        questionLabel.layer.cornerRadius = 8
        questionLabel.clipsToBounds = true
        containerView.tag = 223
        stackView.addArrangedSubview(containerView)
    }
    
    func addCollectionMethodViewOnline(isOnline: Bool = false) {
        let containerView = UIView(frame: .zero)
        containerView.backgroundColor = .white
        
        let onlineItemButton = UIButton(frame: .zero)
        let onlineItemLabel = UILabel(frame: .zero)
        onlineItemLabel.text = "Online Item".localized()
        onlineItemLabel.textColor = isOnline ? UIColor.greenApp : UIColor(hexString: "#C6C6C6")
        onlineItemLabel.font = UIFont(name: "Nunito-Regular", size: 18)
        
        let questionLabel = UILabel(frame: .zero)
        questionLabel.text = "?"
        questionLabel.textColor = .white
        questionLabel.textAlignment = .center
        questionLabel.font = UIFont(name: "Nunito-Bold", size: 15)
        questionLabel.backgroundColor = UIColor(hexString: "#F5D63D")
        
        let questionButton = UIButton(frame: .zero)
        
        let onlineItemCircleView = UIView(frame: .zero)
        onlineItemCircleView.layer.cornerRadius = 10
        onlineItemCircleView.layer.borderColor = UIColor(hexString: "#DDDDDD").cgColor
        onlineItemCircleView.layer.borderWidth = 1
        onlineItemCircleView.backgroundColor = isOnline ? UIColor.greenApp : UIColor.clear
        
        containerView.addSubview(onlineItemLabel)
        containerView.addSubview(questionLabel)
        containerView.addSubview(onlineItemCircleView)
        containerView.addSubview(onlineItemButton)
        containerView.addSubview(questionButton)
        
        constrain(
        containerView,
        onlineItemLabel,
        onlineItemCircleView,
        onlineItemButton) { containerView, onlineItemLabel, onlineItemCircleView, onlineItemButton in
            onlineItemLabel.left == containerView.left + 20
            onlineItemLabel.top == containerView.top
            onlineItemLabel.bottom == containerView.bottom - 12
            onlineItemCircleView.height == 20
            onlineItemCircleView.width == 20
            onlineItemCircleView.right == containerView.right - 24
            onlineItemCircleView.centerY == onlineItemLabel.centerY
            onlineItemButton.left == containerView.left
            onlineItemButton.right == containerView.right
            onlineItemButton.top == containerView.top
            onlineItemButton.bottom == containerView.bottom
        }
        
        constrain(onlineItemLabel, questionLabel, questionButton) { onlineItemLabel, questionLabel, questionButton in
            questionLabel.width == 16
            questionLabel.height == 16
            questionButton.width == 16
            questionButton.height == 16
            questionLabel.centerY == onlineItemLabel.centerY
            questionLabel.left == onlineItemLabel.right + 10
            questionButton.top == questionLabel.top
            questionButton.left == questionLabel.left
            questionButton.right == questionLabel.right
            questionButton.bottom == questionLabel.bottom
        }
        
        onlineItemButton.rx.tap.subscribe(onNext: {
            if !isOnline {
                self.viewModel.deliveryFee.accept(0)
                self.viewModel.agentId = nil
                self.viewModel.collectionMethodId = 4
                self.resetMethod()
                self.addCollectionViewAll(isOnline: true)
                self.addDeliveryFee()
                self.addPayView()
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.disposeBag)
        
        questionButton.rx.tap.subscribe(onNext: {
            if let delivery = self.viewModel.collectionMethodResponseList
                .first(where: { $0.id == 4 }){
                let termAndConditionViewController = TermAndConditionViewController()
                termAndConditionViewController.value = delivery.description
                termAndConditionViewController.titleValue = delivery.name
                
                let popupVC = PopupViewController(
                    contentController: termAndConditionViewController,
                    popupWidth: UIScreen.main.bounds.size.width - 48,
                    popupHeight: UIScreen.main.bounds.size.height/2)
                self.present(popupVC, animated: true)
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.disposeBag)
            
        questionLabel.layer.cornerRadius = 8
        questionLabel.clipsToBounds = true
        containerView.tag = 224
        stackView.addArrangedSubview(containerView)
    }
    
    func addDeliveryFee() {
        let containerView = UIView(frame: .zero)
        containerView.backgroundColor = .white
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor.lightGray.cgColor
        shapeLayer.lineWidth = 1
        shapeLayer.lineDashPattern = [7, 3]

        let path = CGMutablePath()
        path.addLines(between: [CGPoint(x: 0, y: 0), CGPoint(x: UIScreen.main.bounds.size.width, y: 0)])
        shapeLayer.path = path
        containerView.layer.addSublayer(shapeLayer)
        
        let transactionFeeTitleLabel = UILabel(frame: .zero)
        transactionFeeTitleLabel.text = "transaction-fee".localized()
        transactionFeeTitleLabel.textColor = UIColor(hexString: "#717171")
        transactionFeeTitleLabel.font = UIFont(name: "Nunito-ExtraLight", size: 12)
        transactionFeeTitleLabel.numberOfLines = 0
        
        transactionFeeLabel.textColor = UIColor(hexString: "#717171")
        transactionFeeLabel.font = UIFont(name: "Nunito-Regular", size: 12)
        transactionFeeLabel.numberOfLines = 0
        
        let subTotalTitleLabel = UILabel(frame: .zero)
        subTotalTitleLabel.text = "subtotal".localized()
        subTotalTitleLabel.textColor = UIColor(hexString: "#717171")
        subTotalTitleLabel.font = UIFont(name: "Nunito-ExtraLight", size: 12)
        subTotalTitleLabel.numberOfLines = 0
        
        subTotalLabel.textColor = UIColor(hexString: "#393939")
        subTotalLabel.font = UIFont(name: "Nunito-Bold", size: 14)
        subTotalLabel.numberOfLines = 0
        
        let separatorView = UIView(frame: .zero)
        separatorView.backgroundColor = UIColor(hexString: "#E5E5E5")
        
        containerView.addSubview(transactionFeeTitleLabel)
        containerView.addSubview(transactionFeeLabel)
        containerView.addSubview(subTotalTitleLabel)
        containerView.addSubview(subTotalLabel)
        containerView.addSubview(separatorView)
        
        if (self.viewModel.collectionMethodId == 3) {
            let deliveryFeeTitleLabel = UILabel(frame: .zero)
            deliveryFeeTitleLabel.text = "delivery-fee".localized()
            deliveryFeeTitleLabel.textColor = UIColor(hexString: "#717171")
            deliveryFeeTitleLabel.font = UIFont(name: "Nunito-ExtraLight", size: 12)
            deliveryFeeTitleLabel.numberOfLines = 0
            
            deliveryFeeLabel.textColor = UIColor(hexString: "#717171")
            deliveryFeeLabel.font = UIFont(name: "Nunito-Regular", size: 12)
            deliveryFeeLabel.numberOfLines = 0
            
            containerView.addSubview(deliveryFeeTitleLabel)
            containerView.addSubview(deliveryFeeLabel)
            
            constrain(
            containerView,
            deliveryFeeTitleLabel,
            deliveryFeeLabel,
            transactionFeeTitleLabel,
            transactionFeeLabel,
            subTotalTitleLabel,
            subTotalLabel,
            separatorView) {containerView, deliveryFeeTitleLabel, deliveryFeeLabel, transactionFeeTitleLabel, transactionFeeLabel, subTotalTitleLabel, subTotalLabel, separatorView in
                deliveryFeeTitleLabel.top == containerView.top + 24
                deliveryFeeTitleLabel.left == containerView.left + 20
                deliveryFeeLabel.top == containerView.top + 16
                deliveryFeeLabel.right == containerView.right - 20
                transactionFeeTitleLabel.top == deliveryFeeLabel.bottom + 16
                transactionFeeTitleLabel.left == containerView.left + 20
                transactionFeeLabel.top == transactionFeeTitleLabel.top
                transactionFeeLabel.right == containerView.right - 20
                subTotalTitleLabel.top == transactionFeeLabel.bottom + 16
                subTotalTitleLabel.left == containerView.left + 20
                subTotalLabel.top == subTotalTitleLabel.top
                subTotalLabel.right == containerView.right - 20
                separatorView.right == containerView.right - 20
                separatorView.left == containerView.right + 20
                separatorView.top == subTotalLabel.bottom + 14
                separatorView.bottom == containerView.bottom - 24
            }
        } else {
            constrain(
            containerView,
            transactionFeeTitleLabel,
            transactionFeeLabel,
            subTotalTitleLabel,
            subTotalLabel,
            separatorView) {containerView, transactionFeeTitleLabel, transactionFeeLabel, subTotalTitleLabel, subTotalLabel, separatorView in
                transactionFeeTitleLabel.top == containerView.top + 24
                transactionFeeTitleLabel.left == containerView.left + 20
                transactionFeeLabel.top == transactionFeeTitleLabel.top
                transactionFeeLabel.right == containerView.right - 20
                subTotalTitleLabel.top == transactionFeeLabel.bottom + 16
                subTotalTitleLabel.left == containerView.left + 20
                subTotalLabel.top == subTotalTitleLabel.top
                subTotalLabel.right == containerView.right - 20
                separatorView.right == containerView.right - 20
                separatorView.left == containerView.right + 20
                separatorView.top == subTotalLabel.bottom + 14
                separatorView.bottom == containerView.bottom - 24
            }
        }
        
        constrain(separatorView) { separatorView in
            separatorView.height == 1
        }
        
        stackView.addArrangedSubview(containerView)
    }
    
    func addPayView() {
        let containerView = UIView(frame: .zero)
        containerView.backgroundColor = .white
        
        let payTitleLabel = UILabel(frame: .zero)
        payTitleLabel.text = "pay-with-total".localized()
        payTitleLabel.textColor = .white
        payTitleLabel.font = UIFont(name: "Nunito-Bold", size: 15)
        
        payLabel.textColor = .white
        payLabel.font = UIFont(name: "Nunito-Bold", size: 16)
        
        containerView.addSubview(payView)
        containerView.addSubview(payTitleLabel)
        containerView.addSubview(payLabel)
        
        constrain(containerView, payView, payTitleLabel, payLabel) { containerView, payView, payTitleLabel, payLabel in
            payView.top == containerView.top + 20
            payView.bottom == containerView.bottom - 20
            payView.left == containerView.left + 20
            payView.right == containerView.right - 20
            payTitleLabel.left == payView.left + 16
            payTitleLabel.centerY == payView.centerY
            payLabel.centerY == payView.centerY
            payLabel.right == payView.right - 12
            payView.height == 36
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.pay))
        payView.addGestureRecognizer(tap)
        
        stackView.addArrangedSubview(containerView)
    }
    
    func addSeparatorView() {
        let separatorView = UIView(frame: .zero)
        separatorView.backgroundColor = UIColor(hexString: "#E5E5E5")
        
        constrain(separatorView) { separatorView in
            separatorView.height == 10
        }
        
        stackView.addArrangedSubview(separatorView)
    }
    
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "informaton".localized(), message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func calculateFee(fee: Int) {
        var transactionFee = 0
        var subTotal = 0
        var total = 0
        
        for item in viewModel.selectedData {
            subTotal += item.sellerPrice
        }
        
        total = total + subTotal + fee
        deliveryFeeLabel.text = fee.currencyFormat
        transactionFeeLabel.text = transactionFee.currencyFormat
        payLabel.text = total.currencyFormat
        viewModel.total = total
        subTotalLabel.text = subTotal.currencyFormat
    }
}

// MARK: - BatchPickupViewControllerDelegate

extension CartViewController: BatchPickupViewControllerDelegate {
    
    func batchPickupViewController(didSelect batchPickupViewController: BatchPickupViewController, title: String, id: Int) {
        batchPickupAddressLabel.text = title
        viewModel.agentId = id
    }
}

// MARK: - BatchPickupViewControllerDelegate

extension CartViewController: DeliveryAddressViewControllerDelegate {
    
    func deliveryAddressViewController(didSelect deliveryAddressViewController: DeliveryAddressViewController, title: String, id: Int) {
        deliveryAddressLabel.text = title
        viewModel.fetchDeliveryFee(addressId: id)
    }
}
