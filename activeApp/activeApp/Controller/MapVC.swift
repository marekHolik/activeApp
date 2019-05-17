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
    var locationName = String()
    
    let topLabel = UILabel()
    let mapView = MKMapView()
    let backButton = UIButton()
    let centerLocationButton = UIButton()
    let searchView = UIView()
    let searchTextField = UITextField()
    let searchButton = UIButton()
    
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
        addSearchContainer()
        
        addPressGesture()
        getAuthorization()
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
            mapView.removeAnnotations(mapView.annotations)
            
            let annotation = DroppablePin(coordinate: locationCoordinate, identifier: "droppablePin")
            mapView.addAnnotation(annotation)
            
            let coordinateRegion = MKCoordinateRegion(center: locationCoordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
            mapView.setRegion(coordinateRegion, animated: true)
            
            let location = CLLocation(latitude: locationCoordinate.latitude, longitude: locationCoordinate.longitude)
            let geoCoder = CLGeocoder()
            
            geoCoder.reverseGeocodeLocation(location) { [weak self] (placemarks, error) in
                if let _ = error {
                    //TODO notify user
                    return
                }
                guard let placemark = placemarks?.first else {
                    //TODO
                    return
                }
                
                guard let streetName = placemark.thoroughfare else { return }
                guard let places = placemark.areasOfInterest else { return }
            
                DispatchQueue.main.async {
                    if (places.count > 1) {
                        self!.locationName = String(places[0])
                        self!.searchTextField.text = self?.locationName
                        for place in places {
                            print("\(place) is an area of interests)")
                        }
                    } else {
                        self!.locationName = "\(streetName)"
                        self!.searchTextField.text = self?.locationName
                        print(streetName)
                    }
                }
            }
        }
    }
    
    func addSearchContainer() {
        self.view.addSubview(searchView)
        searchView.translatesAutoresizingMaskIntoConstraints = false
        searchView.topAnchor.constraint(equalTo: centerLocationButton.topAnchor).isActive = true
        searchView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        searchView.trailingAnchor.constraint(equalTo: centerLocationButton.leadingAnchor, constant: -20).isActive = true
        searchView.bottomAnchor.constraint(equalTo: centerLocationButton.bottomAnchor).isActive = true
        searchView.layer.cornerRadius = 25
        searchView.clipsToBounds = true
        searchView.backgroundColor = BLUE
        
        searchView.addSubview(searchButton)
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        searchButton.leadingAnchor.constraint(equalTo: searchView.leadingAnchor).isActive = true
        searchButton.centerYAnchor.constraint(equalTo: searchView.centerYAnchor).isActive = true
        searchButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        searchButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        searchButton.backgroundColor = .white
        searchButton.layer.cornerRadius = 25
        searchButton.setImage(UIImage(named: "search"), for: .normal)
        searchButton.imageEdgeInsets = UIEdgeInsets(top: 12.5, left: 12.5, bottom: 12.5, right: 12.5)
        searchButton.addTarget(self, action: #selector(searchTapped), for: .touchUpInside)
        
        searchView.addSubview(searchTextField)
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        searchTextField.centerYAnchor.constraint(equalTo: searchView.centerYAnchor).isActive = true
        searchTextField.leadingAnchor.constraint(equalTo: searchButton.trailingAnchor, constant: 10).isActive = true
        searchTextField.trailingAnchor.constraint(equalTo: searchView.trailingAnchor, constant: -10).isActive = true
        searchTextField.heightAnchor.constraint(equalToConstant: 25).isActive = true
        searchTextField.font = UIFont(name: "Montserrat-Light", size: 20)
        searchTextField.textColor = .white
    }
    
    @objc func searchTapped() {
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = .whiteLarge
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        
        searchTextField.endEditing(true)
        
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = searchTextField.text
        
        let activeSearch = MKLocalSearch(request: searchRequest)
        
        activeSearch.start { (response, error) in
            if let error = error {
                debugPrint(error)
                UIApplication.shared.endIgnoringInteractionEvents()
            }
            if response != nil {
                activityIndicator.stopAnimating()
                
                self.mapView.removeAnnotations(self.mapView.annotations)
                
                let latitude = response?.boundingRegion.center.latitude
                let longitude = response?.boundingRegion.center.longitude
                
                let annotation = MKPointAnnotation()
                annotation.title = self.searchTextField.text
                annotation.coordinate = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
                self.mapView.addAnnotation(annotation)
                
                let coordinate = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
                let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
                self.mapView.setRegion(region, animated: true)
                
                UIApplication.shared.endIgnoringInteractionEvents()
            }
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
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
