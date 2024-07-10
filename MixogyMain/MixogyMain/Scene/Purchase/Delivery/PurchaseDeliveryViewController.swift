//
//  PurchaseDeliveryViewController.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 11/04/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import Agrume
import CoreLocation
import RxCocoa
import RxSwift
import SDWebImage
import SVProgressHUD
import UIKit

class PurchaseDeliveryViewController: UIViewController {

    @IBOutlet var agentProfileImageView: UIImageView!
    @IBOutlet var agentLabel: UILabel!
    @IBOutlet var itemCodeLabel: UILabel!
    @IBOutlet var itemNameLabel: UILabel!
    @IBOutlet var itemDescriptionLabel: UILabel!
    @IBOutlet var itemSeatLabel: UILabel!
    @IBOutlet var itemTypeLabel: UILabel!
    @IBOutlet var itemDateLabel: UILabel!
    @IBOutlet var itemLocationLabel: UILabel!
    @IBOutlet var categoryLabel: UILabel!
    @IBOutlet var courierNameLabel: UILabel!
    @IBOutlet var courierResiLabel: UILabel!
    @IBOutlet var courierPhoneLabel: UILabel!
    @IBOutlet var itemMainPhoto: UIImageView!
    @IBOutlet var galleryContainerView: UIView!
    
    let locationManager = CLLocationManager()
    var disposeBag = DisposeBag()
    var viewModel = PurchaseDeliveryViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupBinding()
        
        viewModel.fetchData()
    }
    
     override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
         
         navigationController?.isNavigationBarHidden = false
         navigationController?.navigationBar.isHidden = false
     }
     
     override func viewWillDisappear(_ animated: Bool) {
         super.viewWillDisappear(animated)
         
         navigationController?.isNavigationBarHidden = true
         navigationController?.navigationBar.isHidden = true
     }
    
    @IBAction func showPhoto(_ sender: UIButton) {
        guard let value = viewModel.data.value else {
            return
        }
        
        let requestPhotoGalleryViewController = RequestPhotoGalleryViewController(nibName: "RequestPhotoGalleryViewController", bundle: nil)
        requestPhotoGalleryViewController.view.frame.size.width = view.frame.size.width
        requestPhotoGalleryViewController.height = (self.view.frame.size.height / 2) + 87
        requestPhotoGalleryViewController.topCornerRadius = 12
        requestPhotoGalleryViewController.shouldDismissInteractivelty = false
        requestPhotoGalleryViewController.presentDuration = 0.2
        requestPhotoGalleryViewController.dismissDuration = 0.2
        requestPhotoGalleryViewController.frontImage = URL(string: value.customerItem.itemPhotos.frontSide ?? "")
        requestPhotoGalleryViewController.backImage = URL(string: value.customerItem.itemPhotos.backSide ?? "")
        present(requestPhotoGalleryViewController, animated: true, completion: nil)
    }
    
    @IBAction func switchImages(_ sender: UIButton) {
        viewModel.switchLocationImage(index: sender.tag)
    }
    
    @IBAction func confirm(_ sender: UIButton) {
        viewModel.confirm()
    }
    
    @IBAction func routeToGetHelp(_ sender: UIButton) {
        let getHelpViewController = GetHelpViewController(nibName: "GetHelpViewController", bundle: nil)
        navigationController?.pushViewController(getHelpViewController, animated: true)
    }
    
    @IBAction func routeToChat(_ sender: UIButton) {
        guard let data = viewModel.data.value,
            let agentId = data.agent?.id else {
            return
        }
        
        let agent = "agent-\(agentId)"
        let roomId = "\(data.customerItem.transactionDetailId ?? 0)"
        
        SVProgressHUD.show()
        Room.fetchRoom(
            documentId: roomId,
            { roomId in
                SVProgressHUD.dismiss()
                PreferenceManager.room = roomId
                let vc = ChatRoomViewController()
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
        },{
            Room.createRoom(roomId: roomId, title: "Transaction \(roomId)", member: [agent])
            
            Room.fetchRoom(
                documentId: roomId,
                { roomId in
                    SVProgressHUD.dismiss()
                    PreferenceManager.room = roomId
                    let vc = ChatRoomViewController()
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
            },{
                SVProgressHUD.dismiss()
            })
        })
    }
}

// MARK: - Private Extension

fileprivate extension PurchaseDeliveryViewController {
    
    func setupUI() {
        title = "On Delivery"
        
        galleryContainerView.layer.cornerRadius = 5
        galleryContainerView.clipsToBounds = true
        
        locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    func setupBinding() {
        viewModel.data.subscribe(onNext: { data in
            if let value = data {
                self.itemCodeLabel.text = value.customerItem.code
                self.itemNameLabel.text = value.customerItem.name
                self.itemSeatLabel.text = value.customerItem.seat
                self.itemTypeLabel.text = value.customerItem.type
                self.itemDateLabel.text = value.customerItem.date
                self.agentLabel.text = value.seller?.name
                self.itemLocationLabel.text = value.customerItem.location
                self.categoryLabel.text = value.customerItem.category
                self.courierNameLabel.text = value.customerItem.courierName
                self.courierResiLabel.text = value.customerItem.resiNumber
                self.courierPhoneLabel.text = value.customerItem.contactNumber
                self.itemMainPhoto.sd_setImage(
                    with: URL(string: value.customerItem.itemImage),
                    placeholderImage: nil,
                    options: .refreshCached,
                    completed: nil
                )
                
                self.agentProfileImageView.sd_setImage(
                    with: URL(string: value.seller?.photoUrl ?? ""),
                    placeholderImage: nil,
                    options: .refreshCached,
                    completed: nil
                )
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
                let alertController = UIAlertController(title: "informaton".localized(), message: message, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)

        viewModel.isSuccess.subscribe(onNext: { isSuccess in
            if isSuccess {
                let alertController = UIAlertController(title: "informaton".localized(), message: "data-saved".localized(), preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                    self.navigationController?.popViewController(animated: true)
                }
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
    }
}

// MARK: - CLLocationManagerDelegate

extension PurchaseDeliveryViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let value: CLLocationCoordinate2D = manager.location?.coordinate else {
            return
        }
        
        viewModel.userCoordinate = value
        locationManager.stopUpdatingLocation()
    }
}
