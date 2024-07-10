//
//  OurAgentViewController.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 06/04/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import CoreLocation
import RxCocoa
import RxSwift
import SVProgressHUD
import UIKit

protocol OurAgentViewControllerDelegate: class {
    func ourAgentViewController(ourAgentViewController didSelect: OurAgentViewController, id: Int)
}

class OurAgentViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    var disposeBag = DisposeBag()
    var viewModel = OurAgentViewModel()
    
    let locationManager = CLLocationManager()
    weak var delegate: OurAgentViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupBinding()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.isHidden = false
        
        switch viewModel.type.value {
        case .select:
            tableView.register(UINib(nibName: "OurAgentCell", bundle: nil), forCellReuseIdentifier: "OurAgentCell")
            
            viewModel.data.bind(to: tableView.rx.items(cellIdentifier: "OurAgentCell", cellType: OurAgentCell.self)) { (indexPath, data, cell) in
                cell.data = data
                cell.delegate = self
                cell.containerView.tag = self.view.tag
            }.disposed(by: disposeBag)
            
            tableView.rx.itemSelected.subscribe(onNext: { indexPath in
                if self.view.tag == 1 {
                    let id = self.viewModel.data.value[indexPath.row].id
                    self.delegate?.ourAgentViewController(ourAgentViewController: self, id: id)
                    self.navigationController?.popViewController(animated: true)
                }
            }).disposed(by: disposeBag)
            
        default:
            tableView.register(UINib(nibName: "OurAgentGeneralCell", bundle: nil), forCellReuseIdentifier: "OurAgentGeneralCell")
            
            viewModel.data.bind(to: tableView.rx.items(cellIdentifier: "OurAgentGeneralCell", cellType: OurAgentGeneralCell.self)) { (indexPath, data, cell) in
                cell.data = data
                cell.delegate = self
                cell.containerView.tag = self.view.tag
            }.disposed(by: disposeBag)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.isNavigationBarHidden = true
        navigationController?.navigationBar.isHidden = true
        
        if isMovingToParent {
            navigationController?.popToRootViewController(animated: true)
        }
    }
}

// MARK: - Private Extension

fileprivate extension OurAgentViewController {
    
    func setupUI() {
        title = "our-agent".localized()
        
        locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
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
        
        viewModel.errorMessage.subscribe(onNext: { message in
            if let message = message {
                self.showAlert(message: message)
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
    }
    
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "informaton".localized(), message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}

// MARK: - CLLocationManagerDelegate
extension OurAgentViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let value: CLLocationCoordinate2D = manager.location?.coordinate else {
            return
        }
        
        viewModel.userCoordinate = value
        viewModel.fetchData()
        locationManager.stopUpdatingLocation()
    }
}

// MARK: - OurAgentCellDelegate
extension OurAgentViewController: OurAgentGeneralCellDelegate {
    
    func ourAgentCell(didTapChat ourAgentCell: OurAgentGeneralCell, id: Int) {
        guard let profile = Preference.profile else {
            return
        }
        
        let createBy = profile.codePhone + profile.phoneNumber
        let agent = "agent-\(id)"
        let roomId = createBy+"&\(agent)"
        
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
            Room.createRoom(roomId: roomId, title: profile.name, member: [agent])
            
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

// MARK: - OurAgentCellDelegate
extension OurAgentViewController: OurAgentCellDelegate {
    
    func ourAgentCell(didTapChat ourAgentCell: OurAgentCell, id: Int) {
        guard let profile = Preference.profile else {
            return
        }
        
        let createBy = profile.codePhone + profile.phoneNumber
        let agent = "agent-\(id)"
        let roomId = createBy+"&\(agent)"
        
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
            Room.createRoom(roomId: roomId, title: profile.name, member: [agent])
            
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
    
    func ourAgentCell(didTapSelect ourAgentCell: OurAgentCell, id: Int) {
        self.delegate?.ourAgentViewController(ourAgentViewController: self, id: id)
        self.navigationController?.popViewController(animated: true)
    }
}
