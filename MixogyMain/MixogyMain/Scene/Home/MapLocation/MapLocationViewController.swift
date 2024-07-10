//
//  MapLocationViewController.swift
//  MixogyAdmin
//
//  Created by ABDUL AZIS H on 20/02/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import MapKit
import RxCocoa
import RxSwift
import SVProgressHUD
import UIKit

protocol MapLocationViewControllerDelegate: class {
    func mapLocationViewController(mapLocationViewController didFinish: MapLocationViewController, addressName: String, id: Int)
}

class MapLocationViewController: UIViewController {

    @IBOutlet var mapView: MKMapView!
    @IBOutlet var containerPlaceNameView: UIView!
    @IBOutlet var placeNameTextField: UITextField!
    @IBOutlet var tableView: UITableView!
    
    var disposeBag = DisposeBag()
    var viewModel = MapLocationViewModel()
    
    let locationManager = CLLocationManager()
    weak var delegate: MapLocationViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupBinding()
    }
    
    @IBAction func doneDidTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Private Extension

fileprivate extension MapLocationViewController {
    
    func setupUI() {
        locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        containerPlaceNameView.layer.cornerRadius = 6
        containerPlaceNameView.clipsToBounds = true
        
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        tableView.register(UINib(nibName: "MapLocationCell", bundle: nil), forCellReuseIdentifier: "MapLocationCell")
        
        mapView.showsUserLocation = true
        mapView.register(MapLocationNearBy.self, forAnnotationViewWithReuseIdentifier: "MapLocationNearBy")
        
    }
    
    func setupBinding() {
        viewModel.data.bind(to: tableView.rx.items(cellIdentifier: "MapLocationCell", cellType: MapLocationCell.self)) { (_, data: MapLocationCellViewModel, cell) in
            cell.data = data
        }.disposed(by: disposeBag)
        
        viewModel.data.subscribe(onNext: { data in
            self.mapView.removeAnnotations(self.mapView.annotations)
            
            if (self.placeNameTextField.text ?? "").isEmpty {
                for i in 0..<data.count {
                    let value = data[i]
                    let annotation = MKPointAnnotation()
                    annotation.title = "\(i)"
                    annotation.coordinate = CLLocationCoordinate2D(latitude: Double(value.latitude) ?? 0.0, longitude: Double(value.longitude) ?? 0.0)
                    annotation.title = "\(i)"
                    self.mapView.addAnnotation(annotation)
                }
            }
        }).disposed(by: disposeBag)
        
        tableView.rx.itemSelected
        .subscribe(onNext: { indexPath in
            let viewModel = self.viewModel.data.value[indexPath.row]
            self.delegate?.mapLocationViewController(
                mapLocationViewController: self,
                addressName: viewModel.title,
                id: viewModel.id
            )
            self.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)
        
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
        
        placeNameTextField
            .rx
            .text
            .throttle(2, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: { text in
            if let value = text {
                self.tableView.isHidden = value.isEmpty
                self.viewModel.keywords.accept(value)
                self.viewModel.fetchData()
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
    }
    
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "informaton".localized(), message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

// MARK: - CLLocationManagerDelegate

extension MapLocationViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let value: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        let region = MKCoordinateRegion(center: value, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView.setRegion(region, animated: true)
        viewModel.userCoordinate = value
        viewModel.fetchData()
        locationManager.stopUpdatingLocation()
    }
}

// MARK: -

extension MapLocationViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else {
            return nil
        }
        guard annotation is MKPointAnnotation else { return nil }
        let view = MapLocationNearBy.instanceFromNib()

        let identifier = "MapLocationNearBy"
        let index = Int((annotation.title ?? "0") ?? "0") ?? 0
        let data = self.viewModel.data.value[index]
        view.title = data.title
        view.distance = data.distance
        view.count = data.count
        view.setup()
        view.canShowCallout = false
        view.tag = index
        
        return view
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let viewModel = self.viewModel.data.value[view.tag]
        self.delegate?.mapLocationViewController(
            mapLocationViewController: self,
            addressName: viewModel.title,
            id: viewModel.id
        )
        self.navigationController?.popViewController(animated: true)
    }
}
