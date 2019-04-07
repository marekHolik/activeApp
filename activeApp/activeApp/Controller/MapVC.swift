//
//  MapVCViewController.swift
//  activeApp
//
//  Created by marek holik on 30/03/2019.
//  Copyright © 2019 marek holik. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation



class MapVC: UIViewController {

    var locationCoordinate = CLLocationCoordinate2D()
    
    let topLabel = UILabel()
    let mapView = MKMapView()
    let backButton = UIButton()
    let centerLocationButton = UIButton()
    
    var locationManager = CLLocationManager()
    let authorizationStatus = CLLocationManager.authorizationStatus()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = BLUE
        
        mapView.delegate = self
        locationManager.delegate = self
        
        mapView.showsUserLocation = true
        centerMapOnUserLocation()
        
        addTopLabel()
        addMapView()
        addBackButton()
        addCenterLocationButton()
        
        addPressGesture()
        
        getAuthorization()
    }
    
    func getLocation() -> CLLocationCoordinate2D {
        return self.locationCoordinate
    }
    
    func addPressGesture() {
        let pressGesture = UILongPressGestureRecognizer(target: self, action: #selector(dropPin(_:)))
        pressGesture.delegate = self
        
        mapView.addGestureRecognizer(pressGesture)
    }
    
    @objc func dropPin(_ gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            let locationTouch = gestureRecognizer.location(in: mapView)
            self.locationCoordinate = mapView.convert(locationTouch, toCoordinateFrom: mapView)
            print("\(locationCoordinate.longitude) and \(locationCoordinate.latitude)")
            mapView.removeAnnotations(mapView.annotations)
            
            let annotation = DroppablePin(coordinate: locationCoordinate, identifier: "droppablePin")
            mapView.addAnnotation(annotation)
            
            let coordinateRegion = MKCoordinateRegion(center: locationCoordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
            mapView.setRegion(coordinateRegion, animated: true)
        }
    }
    
    
    func addCenterLocationButton() {
        self.view.addSubview(centerLocationButton)
        centerLocationButton.translatesAutoresizingMaskIntoConstraints = false
        centerLocationButton.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        centerLocationButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        centerLocationButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        centerLocationButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        centerLocationButton.setImage(UIImage(named: "location"), for: .normal)
        
        centerLocationButton.addTarget(self, action: #selector(centerLocation), for: .touchUpInside)
    }
    
    @objc func centerLocation() {
        centerMapOnUserLocation()
    }
    
    func addBackButton() {
        self.view.addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.centerYAnchor.constraint(equalTo: topLabel.centerYAnchor).isActive = true
        backButton.leadingAnchor.constraint(equalTo: topLabel.leadingAnchor, constant: 20).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 15).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        backButton.setImage(UIImage(named: "backArrow"), for: .normal)
        
        backButton.addTarget(self, action: #selector(self.dismissMapVC(_:)), for: .touchUpInside)
    }
    
    @objc func dismissMapVC(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func addMapView() {
        self.view.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.topAnchor.constraint(equalTo: topLabel.bottomAnchor).isActive = true
        mapView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
    }
    
    func addTopLabel() {
        self.view.addSubview(topLabel)
        topLabel.translatesAutoresizingMaskIntoConstraints = false
        topLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        topLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        topLabel.widthAnchor.constraint(equalToConstant: self.view.frame.size.width).isActive = true
        topLabel.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        topLabel.backgroundColor = BLUE
        topLabel.font = UIFont(name: "Montserrat-Regular", size: 20)
        topLabel.textColor = .white
        topLabel.text = "press-tap to add a location"
        topLabel.textAlignment = .center
    }
}

extension MapVC: UIGestureRecognizerDelegate {
    
}

extension MapVC: MKMapViewDelegate {
    func centerMapOnUserLocation() {
        let region = MKCoordinateRegion(center: mapView.userLocation.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: true)
    }
}

extension MapVC: CLLocationManagerDelegate {
    func getAuthorization() {
        if authorizationStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
    }
}
