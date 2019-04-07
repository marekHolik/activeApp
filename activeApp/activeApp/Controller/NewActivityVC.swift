//
//  NewActivityVC.swift
//  activeApp
//
//  Created by Marek Holík on 19/03/2019.
//  Copyright © 2019 marek holik. All rights reserved.
//

import UIKit
import Firebase
import MapKit

class NewActivityVC: UIViewController {

    let trainingView = UIView()
    let headlineLabel = HeadlineLabel()
    let nameLabel = ActivityLabel()
    let nameTextField = ActivityTextField()
    let locationLabel = ActivityLabel()
    let locationTextLabel = ActivityLabel()
    let lenghtLabel = ActivityLabel()
    let lenghtTextField = ActivityTextField()
    let timePicker = TimePicker()
    let storeLabel = ActivityLabel()
    let createButton = ActivityButton()
    let topBase = HolderView()
    let bottomBase = HolderView()
    let segmentControl = UISegmentedControl(items: ["local", "firebase"])
    
    let activitiesVC = ActivitiesVC()
    let mapVC = MapVC()
    
    let nextVCButton = UIButton()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    private func addBaseViews() {
        self.view.addSubview(topBase)
        topBase.configureLeft(viewToRelate: self.view)
        
        self.view.addSubview(bottomBase)
        bottomBase.configureRight(viewToRelate: self.view)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        let locationCoordinate = mapVC.getLocation()
        locationTextLabel.text = "\(locationCoordinate.latitude) \(locationCoordinate.longitude)"
        print("longitude: \((locationCoordinate.longitude * 1000).rounded() / 1000) and latitude \((locationCoordinate.latitude * 1000).rounded() / 1000)")
    }
    
    private func addSegmentControl() {
        bottomBase.addSubview(segmentControl)
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        segmentControl.widthAnchor.constraint(equalToConstant: 250).isActive = true
        segmentControl.heightAnchor.constraint(equalToConstant: 30).isActive = true
        segmentControl.topAnchor.constraint(equalTo: storeLabel.bottomAnchor).isActive = true
        segmentControl.centerXAnchor.constraint(equalTo: bottomBase.centerXAnchor).isActive = true
        segmentControl.setTitleTextAttributes([NSAttributedString.Key.font : UIFont(name: "Montserrat-Light", size: 15)!], for: .normal)
        segmentControl.selectedSegmentIndex = 0
        
        segmentControl.subviews[0].tintColor = BLUE
        segmentControl.subviews[1].tintColor = ORANGE
    }
    
    private func addNextVCButton() {
        
        view.addSubview(nextVCButton)
        nextVCButton.translatesAutoresizingMaskIntoConstraints = false
        nextVCButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        nextVCButton.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        nextVCButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        nextVCButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        nextVCButton.backgroundColor = BLUE
        nextVCButton.layer.cornerRadius = 5
        nextVCButton.layer.masksToBounds = true
        
        nextVCButton.addTarget(self, action: #selector(presentActivitiesVC), for: .touchUpInside)
    }
    
    @objc func presentActivitiesVC() {
        self.present(activitiesVC, animated: true, completion: nil)
    }
    
    private func addTopViews() {
        
        topBase.addSubview(locationTextLabel)
        locationTextLabel.configureAsBottom(viewToRelate: topBase, text: "")
        locationTextLabel.createAsTextField()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(presentMapVC(_:)))
        tapGesture.numberOfTapsRequired = 1
        locationTextLabel.isUserInteractionEnabled = true
        locationTextLabel.addGestureRecognizer(tapGesture)
        
        topBase.addSubview(locationLabel)
        locationLabel.configureFromBottom(viewToRelate: topBase, itemToRelate: locationTextLabel, constant: 0, text: "location")
        
        topBase.addSubview(nameTextField)
        nameTextField.configureFromBottom(viewToRelate: topBase, itemToRelate: locationLabel, constant: -30)
        
        topBase.addSubview(nameLabel)
        nameLabel.configureFromBottom(viewToRelate: topBase, itemToRelate: nameTextField, constant: 0, text: "name")
        
        self.view.addSubview(headlineLabel)
        headlineLabel.configureAsTop(viewToRelate: view, constant: 30, text: "newActivity")
        
        addNextVCButton()
    }
    
    private func addBottomViews() {
        
        bottomBase.addSubview(lenghtLabel)
        lenghtLabel.configureAsTop(viewToRelate: bottomBase, text: "lenght")
        
        bottomBase.addSubview(lenghtTextField)
        lenghtTextField.configureFromTop(viewToRelate: bottomBase, itemToRelate: lenghtLabel, constant: 0)
        lenghtTextField.inputView = timePicker
        timePicker.configurePicker(viewToRelate: self.view)
        lenghtTextField.addTarget(self, action: #selector(timePickerValuedChanged(sender:)), for: .editingDidEnd)
        
        
        bottomBase.addSubview(storeLabel)
        storeLabel.configureFromTop(viewToRelate: bottomBase, itemToRelate: lenghtTextField, constant: 30, text: "store")
        
        self.view.addSubview(createButton)
        createButton.configureFromBottom(viewToRelate: self.view, text: "create")
        createButton.addTarget(self, action: #selector(createNewActivity(_:)), for: .touchUpInside)
    }
    
    @objc func createNewActivity(_ handler: Bool) {
        createButton.isEnabled = false
        let geoPoint = mapVC.getLocation()
        Firestore.firestore().collection(ACTIVITIES_REF).addDocument(data: [
            ACTIVITIES_NAME : nameTextField.text!,
            ACTIVITIES_LENGHT : timePicker.getTime(),
            ACTIVITIES_LOCATION_NAME : "testNameSofar",
            ACTIVITIES_COORDINATE : GeoPoint(latitude: geoPoint.latitude, longitude: geoPoint.longitude),
            ACTIVITIES_DATE : FieldValue.serverTimestamp()
            ])
        { (error) in
    if let error = error {
        debugPrint(error)
    } else {
        self.nameTextField.text = ""
        self.lenghtTextField.text = ""
        self.locationTextLabel.text = ""
        self.createButton.isEnabled = true
            }
        }
    }
    override func viewWillLayoutSubviews() {
        addBaseViews()
        addTopViews()
        addBottomViews()
        addSegmentControl()
    }
    
    @objc func presentMapVC(_ sender: Any) {
        self.present(mapVC, animated: true, completion: nil)
    }
    
    @objc private func timePickerValuedChanged(sender: TimePicker) {
        self.lenghtTextField.text = timePicker.getTime().formatToTime()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

extension NewActivityVC: UITextFieldDelegate, UIGestureRecognizerDelegate {
    
}
