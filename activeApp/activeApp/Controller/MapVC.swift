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
    
    private let locationManager = CLLocationManager()
    private let authorizationStatus = CLLocationManager.authorizationStatus()

    var locationCoordinate: CLLocationCoordinate2D!
    var locationName: String!
    
    var delegate: ControllerNCDelegate!
    var newActivityDelegate: NewActivityVCDelegate!
    
    private var topLabel: UILabel!
    private var topView: UIView!
    private var mapView: MKMapView!
    private var backButton: UIButton!
    private var centerLocationButton: UIButton!
    private var searchView: UIView!
    private var searchTextField: UITextField!
    private var searchButton: UIButton!
    
    private var keyboardHeight: CGFloat!
    private var searchBarOrigin: CGFloat!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = BLUE
        
        locationCoordinate = CLLocationCoordinate2D()
        locationName = String()
        
        addTopContainer()
        addMapView()
        addCenterLocationButton()
        addSearchContainer()
        
        mapView.delegate = self
        locationManager.delegate = self
        
        addPressGesture()
        getAuthorization()
        
        mapView.showsUserLocation = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        searchBarOrigin = searchView.frame.origin.y
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        centerMapOnUserLocation()
    }
    
    //objc methods
    
    @objc private func centerLocation() {
        centerMapOnUserLocation()
    }
    
    @objc private func dismissMapVC() {
        delegate.dismissVC()
        if (locationName == "" && searchTextField.text != "") {
            locationName = searchTextField.text!
        }
        newActivityDelegate.fillLabel(locationName: locationName)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.mapView.frame.origin.y -= keyboardSize.height
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.mapView.frame.origin.y += keyboardSize.height
        }
    }
    
    @objc private func dropPin(_ gestureRecognizer: UILongPressGestureRecognizer) {
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
                    self!.createAlert(title: "Error", message: "There has been an error while finding tapped location")
                    return
                }
                guard let placemark = placemarks?.first else {
                    return
                }
                
                guard let streetName = placemark.thoroughfare else { return }
                guard let places = placemark.areasOfInterest else { return }
                
                DispatchQueue.main.async {
                    if (places.count > 1) {
                        self!.locationName = String(places[0])
                        self!.searchTextField.text = self?.locationName
                    } else {
                        if (self!.locationName == "") {
                            self!.locationName = "\(streetName)"
                            self!.searchTextField.text = self?.locationName
                        }
                    }
                }
            }
        }
    }
    
    @objc private func searchTapped() {
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
    
    //UX methods
    
    private func createAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
        print("Alerting user!!!")
    }
    
    private func addPressGesture() {
        let pressGesture = UILongPressGestureRecognizer(target: self, action: #selector(dropPin(_:)))
        pressGesture.delegate = self
        mapView.addGestureRecognizer(pressGesture)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    //UI methods
    
    private func addSearchContainer() {
        searchView = UIView()
        self.mapView.addSubview(searchView)
        searchView.translatesAutoresizingMaskIntoConstraints = false
        searchView.topAnchor.constraint(equalTo: centerLocationButton.topAnchor).isActive = true
        searchView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        searchView.trailingAnchor.constraint(equalTo: centerLocationButton.leadingAnchor, constant: -20).isActive = true
        searchView.bottomAnchor.constraint(equalTo: centerLocationButton.bottomAnchor).isActive = true
        searchView.layer.cornerRadius = 25
        searchView.clipsToBounds = true
        searchView.backgroundColor = BLUE
        
        searchButton = UIButton()
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
        
        searchTextField = UITextField()
        searchView.addSubview(searchTextField)
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        searchTextField.centerYAnchor.constraint(equalTo: searchView.centerYAnchor).isActive = true
        searchTextField.leadingAnchor.constraint(equalTo: searchButton.trailingAnchor, constant: 10).isActive = true
        searchTextField.trailingAnchor.constraint(equalTo: searchView.trailingAnchor, constant: -10).isActive = true
        searchTextField.heightAnchor.constraint(equalToConstant: 25).isActive = true
        searchTextField.font = UIFont(name: "Montserrat-Light", size: 20)
        searchTextField.textColor = .white
    }
    
    private func addCenterLocationButton() {
        centerLocationButton = UIButton()
        self.mapView.addSubview(centerLocationButton)
        centerLocationButton.translatesAutoresizingMaskIntoConstraints = false
        centerLocationButton.trailingAnchor.constraint(equalTo: self.mapView.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        centerLocationButton.bottomAnchor.constraint(equalTo: self.mapView.bottomAnchor, constant: -20).isActive = true
        centerLocationButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        centerLocationButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        centerLocationButton.setImage(UIImage(named: "location"), for: .normal)
        
        centerLocationButton.addTarget(self, action: #selector(centerLocation), for: .touchUpInside)
    }
    
    private func addMapView() {
        mapView = MKMapView()
        self.view.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.topAnchor.constraint(equalTo: topView.bottomAnchor).isActive = true
        mapView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
    
    private func addTopContainer() {
        topView = UIView()
        self.view.addSubview(topView)
        topView.translatesAutoresizingMaskIntoConstraints = false
        topView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        topView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        topView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        topView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        topView.backgroundColor = BLUE
        
        topLabel = UILabel()
        self.topView.addSubview(topLabel)
        topLabel.translatesAutoresizingMaskIntoConstraints = false
        topLabel.centerXAnchor.constraint(equalTo: topView.centerXAnchor).isActive = true
        topLabel.centerYAnchor.constraint(equalTo: topView.centerYAnchor, constant: 10).isActive = true
        topLabel.font = UIFont(name: "Montserrat-Regular", size: 20)
        topLabel.textColor = .white
        topLabel.text = "press-tap to add a location"
        topLabel.textAlignment = .center
        
        backButton = UIButton()
        self.view.addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.centerYAnchor.constraint(equalTo: topLabel.centerYAnchor).isActive = true
        backButton.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 20).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 15).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        backButton.setImage(UIImage(named: "backArrow"), for: .normal)
        backButton.addTarget(self, action: #selector(self.dismissMapVC), for: .touchUpInside)
    }
    
}

extension MapVC: UIGestureRecognizerDelegate {
}

extension MapVC: MKMapViewDelegate {
    private func centerMapOnUserLocation() {
        let region = MKCoordinateRegion(center: mapView.userLocation.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: true)
        print(mapView.userLocation.coordinate)
        print("Centering on user")
    }
}

extension MapVC: CLLocationManagerDelegate {
    private func getAuthorization() {
        if authorizationStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    }
}
