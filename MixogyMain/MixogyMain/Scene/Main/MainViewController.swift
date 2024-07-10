//
//  MainViewController.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 29/02/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    var selectedId: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.methodOfReceivedNotification(notification:)),
            name: Notification.Name(Constants.ChangeLanguageKey),
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.methodOfBadge(notification:)),
            name: Notification.Name(Constants.ItemTypeKey),
            object: nil
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = true
        navigationController?.navigationBar.isHidden = true
        
        NotificationCenter.default.post(
            name: Notification.Name(Constants.CartHideShowKey),
            object: nil,
            userInfo: ["show": 0]
        )
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if view.tag == 0 {
            view.tag = 1
            setupUI()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        NotificationCenter.default.post(
            name: Notification.Name(Constants.CartHideShowKey),
            object: nil,
            userInfo: ["show": 1]
        )
    }
    
    func setupLanguage() {
        viewControllers?[0].tabBarItem.title = "home".localized()
        viewControllers?[1].tabBarItem.title = "purchases".localized()
        viewControllers?[2].tabBarItem.title = nil
        viewControllers?[3].tabBarItem.title = "sell-list".localized()
        viewControllers?[4].tabBarItem.title = "inbox".localized()
    }
    
    @objc func methodOfReceivedNotification(notification: Notification) {
        setupLanguage()
    }
    
    @objc func methodOfBadge(notification: Notification) {
        if viewControllers?.count ?? 0 > 4 {
            viewControllers![4].tabBarItem.badgeValue = ""
        }
    }
}

// MARK: - MainViewController

fileprivate extension MainViewController {
    
    func setupUI() {
        
        let homeController = HomeViewController(nibName: "HomeViewController", bundle: nil)
        
        if let selectedId = selectedId {
            homeController.viewModel.selectedCategoryId = selectedId
        }
        
        homeController.tabBarItem = UITabBarItem(
            title: "home".localized(),
            image: UIImage(named: "HomeTab"),
            tag: 0
        )
        
        let purchaseViewController = PurchaseViewController(nibName: "PurchaseViewController", bundle: nil)
        purchaseViewController.tabBarItem = UITabBarItem(
            title: "purchases".localized(),
            image: UIImage(named: "PurchaseTab"),
            tag: 1
        )
        
        let cartViewController = CartViewController()
        
        let sellViewController = SellViewController(nibName: "SellViewController", bundle: nil)
        sellViewController.tabBarItem = UITabBarItem(
            title: "sell-list".localized(),
            image: UIImage(named: "SellTab"),
            tag: 3
        )
        
        let inboxViewController = InboxViewController(nibName: "InboxViewController", bundle: nil)
        inboxViewController.tabBarItem = UITabBarItem(
            title: "inbox".localized(),
            image: UIImage(named: "InboxTab"),
            tag: 4
        )
        
        inboxViewController.tabBarItem.badgeValue = Preference.inboxCount ?? 0 > 0 ? "" : nil
        
        let inboxNavigationController = UINavigationController(rootViewController: inboxViewController)
        let cartNavigationController = UINavigationController(rootViewController: cartViewController)
        
        viewControllers = [homeController, purchaseViewController, cartNavigationController, sellViewController, inboxNavigationController]
        setupTabbar()
    }
    
    func setupTabbar() {
        selectedViewController = viewControllers?.first
        selectedIndex = 0
        
        let mixogyTabbar = MixogyTabBar()
        mixogyTabbar.cartDelegate = self
        setValue(mixogyTabbar, forKey: "tabBar")
        tabBar.tintColor = UIColor(hexString: "#34F473")
        tabBar.unselectedItemTintColor = UIColor(hexString: "#C7C7C7")
        self.tabBar.layer.masksToBounds = true
        self.tabBar.isTranslucent = true
        self.tabBar.barStyle = .blackOpaque
        self.tabBar.layer.cornerRadius = 12
        self.tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
}

// MARK: - MainViewController

extension MainViewController: MixogyTabBarDelegate {
    
    func mixogyTabBarDelegate(mixogyTabBar didTapCart: MixogyTabBar) {
        if Preference.auth != nil {
            selectedIndex = 2
        } else {
            let loginViewController = LoginViewController(nibName: "LoginViewController", bundle: nil)
            loginViewController.from = .cart
            navigationController?.pushViewController(loginViewController, animated: true)
        }
    }
}

// MARK: - UITabBarControllerDelegate

extension MainViewController: UITabBarControllerDelegate {
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.tag == 4 && viewControllers?.count ?? 0 > 4 {
            viewControllers![4].tabBarItem.badgeValue = nil
            Preference.inboxCount = 0
        }
        
        if item.tag == 2 && viewControllers?.count ?? 0 > 2 {
            viewControllers![2].tabBarItem.title = nil
        }
    }
}
