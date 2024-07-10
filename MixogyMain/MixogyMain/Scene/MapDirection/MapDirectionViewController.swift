//
//  MapDirectionViewController.swift
//  MixogyMain
//
//  Created by ABDUL AZIS H on 08/03/20.
//  Copyright © 2020 Mixogy. All rights reserved.
//

import GoogleMaps
import UIKit

class MapDirectionViewController: UIViewController {

    @IBOutlet var mapView: GMSMapView!
    @IBOutlet var containerPlaceNameView: UIView!
    @IBOutlet var placeNameTextField: UITextField!
    
    let locationManager = CLLocationManager()
    var destinationLocation: (CLLocationCoordinate2D, String?)?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setupUI()
    }
    
    @IBAction func dismissSelf() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - MapDirectionViewController

extension MapDirectionViewController {
    
    func setupUI() {
        locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        containerPlaceNameView.layer.cornerRadius = 6
        containerPlaceNameView.clipsToBounds = true
        
        placeNameTextField.text = destinationLocation?.1
    }
}

// MARK: - CLLocationManagerDelegate

extension MapDirectionViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let value: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        let camera = GMSCameraPosition(latitude: value.latitude, longitude: value.longitude, zoom: 15)
        mapView.camera = camera
        
        let marker = GMSMarker(position: value)
        marker.title = "Your Location"
        marker.map = mapView
        
        guard let destination = destinationLocation else { return }
        
        let destinationMarker = GMSMarker(position: destination.0)
        destinationMarker.title = ""
        destinationMarker.map = mapView
        
        let path = GMSMutablePath()
        path.add(value)
        path.add(destination.0)
        let polyline = GMSPolyline(path: path)
        polyline.strokeWidth = 10
        let styles: [GMSStrokeStyle] = [.solidColor(UIColor(hexString: "#0FB27E")), .solidColor(.clear)]
        let scale = 1.0 / mapView.projection.points(forMeters: 1, at: mapView.camera.target)
        let solidLine = NSNumber(value: 10.0 * Float(scale))
        let gap = NSNumber(value: 10.0 * Float(scale))
        polyline.spans = GMSStyleSpans(polyline.path!, styles, [solidLine, gap], GMSLengthKind.rhumb)
        polyline.map = mapView
        locationManager.stopUpdatingLocation()
    }
}
