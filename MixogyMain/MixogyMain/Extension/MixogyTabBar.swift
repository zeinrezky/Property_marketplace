//
//  MixogyTabBar.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 01/03/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import UIKit

protocol MixogyTabBarDelegate: class {
    func mixogyTabBarDelegate(mixogyTabBar didTapCart: MixogyTabBar)
}

class MixogyTabBar: UITabBar {

    weak var cartDelegate: MixogyTabBarDelegate?
    
    var cartView: UIView = {
        let view = UIView(frame: .zero)
        return view
    }()
    
    var cartBackgroundImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = UIImage(named: "CartTabBar")
        return imageView
    }()
    
    var cartImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = UIImage(named: "Cart")
        return imageView
    }()
    
    var cartCountLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont(name: "Nunito-Bold", size: 15)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()

    
    var cartButton: UIButton = {
        let button = UIButton(frame: .zero)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        cartView.addSubview(cartBackgroundImageView)
        cartView.addSubview(cartImageView)
        cartView.addSubview(cartCountLabel)
        cartView.addSubview(cartButton)
        
        UIApplication.shared.keyWindow?.addSubview(cartView)
        cartButton.addTarget(self, action: #selector(self.showCart), for: .touchUpInside)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.methodOfReceivedNotification(notification:)),
            name: Notification.Name(Constants.CartCountKey),
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.hideShowCart(notification:)),
            name: Notification.Name(Constants.CartHideShowKey),
            object: nil
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = UIColor(hexString: "#2E2E2E")
        barStyle = .black
        
        var index = 0
        for barButton in self.subviews{
            
            if barButton.isKind(of: NSClassFromString("UITabBarButton")!){
                
                if index == 2 {
                    let window = UIApplication.shared.keyWindow
                    let bottomPadding = window?.safeAreaInsets.bottom ?? 0
                    
                    cartView.frame = CGRect(
                        x: (UIScreen.main.bounds.size.width / 2) - 44,
                        y: (UIScreen.main.bounds.size.height) - 90 - bottomPadding,
                        width: 88,
                        height: 88
                    )
                    
                    cartImageView.frame = CGRect(
                        x: 30,
                        y: 30,
                        width: 28,
                        height: 28
                    )
                    
                    cartCountLabel.frame = CGRect(
                        x: 28,
                        y: 12,
                        width: 30,
                        height: 20
                    )
                    
                    cartBackgroundImageView.frame = cartView.bounds
                    cartButton.frame = cartView.bounds
                }
                
                index += 1
            }
        }
    }
    
    @objc
    func showCart() {
        cartDelegate?.mixogyTabBarDelegate(mixogyTabBar: self)
    }
    
    @objc func methodOfReceivedNotification(notification: Notification) {
        let count = Int("\(notification.userInfo?["count"] ?? "0")") ?? 0
        
        if count > 0 {
            cartCountLabel.text = "\(count)"
            cartBackgroundImageView.image = UIImage(named: "FilledCart")
        } else {
            cartCountLabel.text = ""
            cartBackgroundImageView.image = UIImage(named: "CartTabBar")
        }
    }
    
    @objc func hideShowCart(notification: Notification) {
        let hide = Int("\(notification.userInfo?["show"] ?? "0")") ?? 0
        cartView.isHidden = hide == 1
    }
}
