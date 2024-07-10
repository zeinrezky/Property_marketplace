//
//  MapViewController.swift
//  MixogyAdmin
//
//  Created by ABDUL AZIS H on 26/01/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import GoogleMaps
import UIKit

protocol MapViewControllerDelegate: class {
    func mapViewController(mapViewController didFinish: MapViewController, addressName: String, lattitude: CLLocationDegrees, longitude: CLLocationDegrees)
}

class MapViewController: UIViewController {

    @IBOutlet var mapView: GMSMapView!
    @IBOutlet var containerView: UIView!
    @IBOutlet var containerPlaceNameView: UIView!
    @IBOutlet var placeNameLabel: UILabel!
    
    var hideCircle = true
    
    let locationManager = CLLocationManager()
    weak var delegate: MapViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if (!hideCircle) {
            containerView.layer.borderColor = UIColor(hexString: "#2879E478").cgColor
            containerView.backgroundColor = UIColor.init(white: 1.0, alpha: 0.8)
        }
    }
    
    func getAdressName(coords: CLLocation) {
      CLGeocoder().reverseGeocodeLocation(coords) { (placemark, error) in
        if error == nil {
            let place = placemark! as [CLPlacemark]
            if place.count > 0 {
                let place = placemark![0]
                self.placeNameLabel.text = place.name
            }
        }
        }
    }
    
    @IBAction func doneDidTapped(_ sender: Any) {
        delegate?.mapViewController(
            mapViewController: self,
            addressName: placeNameLabel.text ?? "",
            lattitude: mapView.camera.target.latitude,
            longitude: mapView.camera.target.longitude
        )
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func backDidTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Private Extension

fileprivate extension MapViewController {
    
    func setupUI() {
        mapView.delegate = self
        locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        containerView.layer.cornerRadius = 72
        containerView.layer.borderWidth = 4
        
        containerView.clipsToBounds = true
        containerView.layer.borderColor = UIColor.clear.cgColor
        containerView.backgroundColor = UIColor.clear
        containerPlaceNameView.layer.cornerRadius = 6
        containerPlaceNameView.clipsToBounds = true
    }
}

// MARK: - CLLocationManagerDelegate

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let value: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        let camera = GMSCameraPosition(latitude: value.latitude, longitude: value.longitude, zoom: 15)
        mapView.camera = camera
        locationManager.stopUpdatingLocation()
        
    }
}

// MARK: - GMSMapViewDelegate

extension MapViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        getAdressName(coords: CLLocation(latitude: position.target.latitude, longitude: position.target.longitude))
    }
}
