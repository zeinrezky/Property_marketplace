//
//  RequestWaitingViewController.swift
//  MixogyAdmin
//
//  Created by ABDUL AZIS H on 15/02/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import Agrume
import CoreLocation
import RxCocoa
import RxSwift
import SDWebImage
import SVProgressHUD
import UIKit

class RequestWaitingViewController: UIViewController {

    @IBOutlet var stackView: UIStackView!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var agentProfileImageView: UIImageView!
    @IBOutlet var qrImageView: UIImageView!
    @IBOutlet var distanceLabel: UILabel!
    @IBOutlet var agentLabel: UILabel!
    @IBOutlet var itemCodeLabel: UILabel!
    @IBOutlet var itemNameLabel: UILabel!
    @IBOutlet var itemDescriptionLabel: UILabel!
    @IBOutlet var itemSeatLabel: UILabel!
    @IBOutlet var itemTypeLabel: UILabel!
    @IBOutlet var itemDateLabel: UILabel!
    @IBOutlet var itemLocationLabel: UILabel!
    @IBOutlet var categoryLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var pickupAvailableLabel: UILabel!
    @IBOutlet var waitingConfirmationLabel: UILabel!
    @IBOutlet var itemMainPhoto: UIImageView!
    @IBOutlet var galleryContainerView: UIView!
    @IBOutlet var blurRoundedView: [UIView]!
    @IBOutlet var submiitButton: UIButton!
    @IBOutlet var blurView: UIVisualEffectView!
    @IBOutlet var pickupBlurView: UIVisualEffectView!
    
    @IBOutlet var locationImageViews: [UIImageView]!
    @IBOutlet var ratingImages: [UIImageView]!
    
    let locationManager = CLLocationManager()
    var disposeBag = DisposeBag()
    var viewModel = RequestWaitingViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupBinding()
        
        viewModel.fetchData()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.methodOfReceivedNotification(notification:)),
            name: Notification.Name(Constants.ItemTypeKey),
            object: nil
        )
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
    
    func routeToOurAgent() {
        let ourAgentViewController = OurAgentViewController(nibName: "OurAgentViewController", bundle: nil)
        ourAgentViewController.viewModel.type.accept(.select)
        ourAgentViewController.delegate = self
        navigationController?.pushViewController(ourAgentViewController, animated: true)
    }
    
    func routeeToRateAgent() {
        let rateAgentViewController = RateAgentViewController(nibName: "RateAgentViewController", bundle: nil)
        rateAgentViewController.view.frame.size.width = view.frame.size.width
        rateAgentViewController.height = UIScreen.main.bounds.size.height - 100
        rateAgentViewController.topCornerRadius = 12
        rateAgentViewController.shouldDismissInteractivelty = true
        rateAgentViewController.presentDuration = 0.2
        rateAgentViewController.dismissDuration = 0.2
        rateAgentViewController.viewModel.id = viewModel.data.value?.customerItem.transactionDetailId
        rateAgentViewController.delegate = self
        present(rateAgentViewController, animated: true, completion: nil)
    }
    
    @IBAction func switchImages(_ sender: UIButton) {
        viewModel.switchLocationImage(index: sender.tag)
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

fileprivate extension RequestWaitingViewController {
    
    func setupUI() {
        galleryContainerView.layer.cornerRadius = 5
        galleryContainerView.clipsToBounds = true
        
        locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        for view in blurRoundedView {
            view.layer.cornerRadius = 7
            view.clipsToBounds = true
        }
    }
    
    func setupBinding() {
        viewModel
            .distance
            .bind(to: distanceLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel
            .agentName
            .bind(to: agentLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.qrImage.subscribe(onNext: { url in
            self.qrImageView.sd_setImage(
                with: url,
                placeholderImage: nil,
                options: .refreshCached,
                completed: nil
            )
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        
        viewModel.data.subscribe(onNext: { data in
            if let value = data {
                let qrAlpha: CGFloat
                self.title = value.customerItem.status
                
                switch value.customerItem.statusId {
                case 14:
                    self.submiitButton.setTitle("Cancel Change Location", for: .normal)
                    qrAlpha = 0.1
                    self.waitingConfirmationLabel.isHidden = false
                    self.stackView.arrangedSubviews[0].removeFromSuperview()
                    
                case 12:
                    qrAlpha = 0.1
                    self.pickupBlurView.isHidden = false
                    self.waitingConfirmationLabel.isHidden = false
                    self.waitingConfirmationLabel.text = "Item not ready yet."
                    self.pickupAvailableLabel.text = value.customerItem.pickupAvailableDate
                    self.title = "Item Not Ready"
                    
                default:
                    qrAlpha = 1.0
                    self.waitingConfirmationLabel.isHidden = true
                }
                
                self.itemCodeLabel.text = value.customerItem.code
                self.itemNameLabel.text = value.customerItem.name
                self.itemDescriptionLabel.text = value.customerItem.description
                self.itemSeatLabel.text = value.customerItem.seat ?? "-"
                self.itemTypeLabel.text = value.customerItem.type
                self.itemDateLabel.text = value.customerItem.date
                self.locationLabel.text = value.agent?.location
                self.itemLocationLabel.text = value.customerItem.location
                self.categoryLabel.text = value.customerItem.category
                self.descriptionLabel.text = value.customerItem.description ?? "-"
                self.itemMainPhoto.sd_setImage(
                    with: URL(string: value.customerItem.itemImage),
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
        
        viewModel.agentImage.subscribe(onNext: { url in
            self.agentProfileImageView.sd_setImage(
                with: url,
                placeholderImage: nil,
                options: .refreshCached,
                completed: nil
            )
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        
        viewModel.locationImages.subscribe(onNext: { locationImages in
            
            for i in 0..<self.locationImageViews.count {
                if locationImages.count > i {
                    self.locationImageViews[i].sd_setImage(
                        with: locationImages[i],
                        placeholderImage: nil,
                        options: .refreshCached,
                        completed: nil
                    )
                    self.locationImageViews[i].layer.borderColor = UIColor.white.cgColor
                    self.locationImageViews[i].layer.borderWidth = 1
                    self.locationImageViews[i].layer.cornerRadius = 5
                } else {
                    self.locationImageViews[i].layer.borderColor = UIColor.clear.cgColor
                }
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        
        viewModel.agentRating.subscribe(onNext: { rating in
            self.setupRating(rating: rating)
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        
        viewModel.errorMessage.subscribe(onNext: { message in
            if let message = message {
                let alertController = UIAlertController(title: "informaton".localized(), message: message, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        
        submiitButton.rx.tap.subscribe(onNext: {
            if let statusId = self.viewModel.data.value?.customerItem.statusId, statusId == 14 {
                self.viewModel.cancelLocation()
            } else {
                self.routeToOurAgent()
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
    
    func setupRating(rating: Int) {
        for ratingImage in ratingImages {
            ratingImage.image = UIImage(named: rating > ratingImage.tag ? "RatingFilled" : "RatingEmpty")
        }
    }
    
    @objc func methodOfReceivedNotification(notification: Notification) {
        let type = notification.userInfo!["type"] as? String ?? ""
        
        if !type.isEmpty {
            switch type {
            case "send_to_customer":
                self.routeeToRateAgent()
                
            default:
                break
            }
        }
    }
}

// MARK: - CLLocationManagerDelegate

extension RequestWaitingViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let value: CLLocationCoordinate2D = manager.location?.coordinate else {
            return
        }
        
        viewModel.userCoordinate = value
        locationManager.stopUpdatingLocation()
    }
}

// MARK: - RequestWaitingViewController

extension RequestWaitingViewController: OurAgentViewControllerDelegate {
    
    func ourAgentViewController(ourAgentViewController didSelect: OurAgentViewController, id: Int) {
        viewModel.submit(agentId: id)
    }
}

// MARK: - RateAgentViewControllerDelegate

extension RequestWaitingViewController: RateAgentViewControllerDelegate {
    
    func rateAgentViewController(didSuccess rateAgentViewController: RateAgentViewController) {
        navigationController?.popViewController(animated: true)
    }
}
