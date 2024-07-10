//
//  GopayBrowserViewController.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 10/11/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import SVProgressHUD
import UIKit
import WebKit

class GopayBrowserViewController: UIViewController {

    @IBOutlet var webView: WKWebView!
    
    var viewModel = GopayBrowserViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.isHidden = false
        
        guard let url = viewModel.url else {
            return
        }
        
        let request = URLRequest(url: url)
        webView.load(request)
        SVProgressHUD.show()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.isNavigationBarHidden = true
        navigationController?.navigationBar.isHidden = true
    }
}

// MARRK: - Private Extension

fileprivate extension GopayBrowserViewController {
    
    func setupUI() {
        webView.navigationDelegate = self
    }
}

extension GopayBrowserViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        guard let url = webView.url else {
            return
        }
        
        if url.absoluteString.contains("https://simulator.sandbox.midtrans.com/gopay/partner/app/verifyPaymentPin") {
            navigationController?.popToRootViewController(animated: true)
        }
        SVProgressHUD.dismiss()
        print("finish to load = \(url)")
    }
}
