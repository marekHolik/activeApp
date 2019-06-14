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
    
    //constraint of holderViews
//    var portraitTopBase = NSLayoutConstraint()
//    var landscapeTopBase = NSLayoutConstraint()
    var portraitTopBaseWidth = NSLayoutConstraint()
    var portraitTopBaseHeight = NSLayoutConstraint()
    var landscapeTopBaseWidth = NSLayoutConstraint()
    var landscapeTopBaseHeight = NSLayoutConstraint()
    
//    var portraitBottomBase = NSLayoutConstraint()
//    var landscapeBottomBase = NSLayoutConstraint()
    var portraitBottomBaseWidth = NSLayoutConstraint()
    var portraitBottomBaseHeight = NSLayoutConstraint()
    var landscapeBottomBaseWidth = NSLayoutConstraint()
    var landscapeBottomBaseHeight = NSLayoutConstraint()
    
    //constraints
    var portraitTextLbl = NSLayoutConstraint()
    var landscapeTextLbl = NSLayoutConstraint()
    
    var portraitLenghtLbl = NSLayoutConstraint()
    var landscapeLenghtLbl = NSLayoutConstraint()
    
    //measures
    var pixelWidth = CGFloat()
    var pixelHeight = CGFloat()
    var pointWidth = CGFloat()
    var pointHeight = CGFloat()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pixelWidth = UIScreen.main.nativeBounds.width < UIScreen.main.nativeBounds.height ? UIScreen.main.nativeBounds.width : UIScreen.main.nativeBounds.height
        pixelHeight = UIScreen.main.nativeBounds.height > UIScreen.main.nativeBounds.width ? UIScreen.main.nativeBounds.height : UIScreen.main.nativeBounds.width
        pointWidth = pixelWidth / UIScreen.main.nativeScale
        pointHeight = pixelHeight / UIScreen.main.nativeScale
        
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        addBaseViews()
        addTopViews()
        addBottomViews()
        addSegmentControl()
        
        locationTextLabel.configure(viewToRelate: self.topBase)
        portraitTextLbl = locationTextLabel.bottomAnchor.constraint(equalTo: topBase.bottomAnchor, constant: -30)
        landscapeTextLbl = locationTextLabel.bottomAnchor.constraint(equalTo: topBase.bottomAnchor, constant: (75 - (pointWidth / 2)))
        
        
        portraitTextLbl.identifier = "31"
        landscapeTextLbl.identifier = "32"
        
        lenghtLabel.configure(viewToRelate: self.bottomBase)
        lenghtLabel.create(text: "lenght")
        portraitLenghtLbl = lenghtLabel.topAnchor.constraint(equalTo: bottomBase.topAnchor, constant: 0)
        landscapeLenghtLbl = lenghtLabel.topAnchor.constraint(equalTo: bottomBase.topAnchor, constant: ((pointWidth / 2) - 75))
        
//        portraitLenghtLbl.identifier = "41"
//        landscapeLenghtLbl.identifier = "42"
        
        //topBase's constraints
        if (self.view.frame.size.height > self.view.frame.size.width) {
            portraitTextLbl.isActive = true
            portraitLenghtLbl.isActive = true
            portraitTopBaseWidth.isActive = true
            portraitTopBaseHeight.isActive = true
            portraitBottomBaseWidth.isActive = true
            portraitBottomBaseHeight.isActive = true
        } else {
            landscapeTextLbl.isActive = true
            landscapeLenghtLbl.isActive = true
            landscapeTopBaseWidth.isActive = true
            landscapeTopBaseHeight.isActive = true
            landscapeBottomBaseWidth.isActive = true
            landscapeBottomBaseHeight.isActive = true
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        if (UIDevice.current.orientation.isLandscape) {
            //topView's label
            portraitTextLbl.isActive = false
            landscapeTextLbl.isActive = true
            //bottomView's label
            portraitLenghtLbl.isActive = false
            landscapeLenghtLbl.isActive = true
            
            //top Base's constraints
            portraitTopBaseWidth.isActive = false
            portraitTopBaseHeight.isActive = false
            landscapeTopBaseWidth.isActive = true
            landscapeTopBaseHeight.isActive = true
            
            //bottomBase's constraints
            portraitBottomBaseWidth.isActive = false
            portraitBottomBaseHeight.isActive = false
            landscapeBottomBaseWidth.isActive = true
            landscapeBottomBaseHeight.isActive = true
            
        } else {
            //topView's label
            landscapeTextLbl.isActive = false
            portraitTextLbl.isActive = true
            //bottomView's label
            landscapeLenghtLbl.isActive = false
            portraitLenghtLbl.isActive = true
            
            //topBase's constraints
            landscapeTopBaseWidth.isActive = false
            landscapeTopBaseHeight.isActive = false
            portraitTopBaseWidth.isActive = true
            portraitTopBaseHeight.isActive = true

            //bottomBase's constraints
            landscapeBottomBaseWidth.isActive = false
            landscapeBottomBaseHeight.isActive = false
            portraitBottomBaseWidth.isActive = true
            portraitBottomBaseHeight.isActive = true
        }
    }
    
    private func addBaseViews() {

        self.view.addSubview(topBase)
//        topBase.configureLeft(viewToRelate: self.view)
        topBase.translatesAutoresizingMaskIntoConstraints = false
        topBase.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        topBase.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        
        landscapeTopBaseWidth = topBase.widthAnchor.constraint(equalToConstant: pointHeight / 2)
        landscapeTopBaseHeight = topBase.heightAnchor.constraint(equalToConstant: pointWidth)
        portraitTopBaseWidth = topBase.widthAnchor.constraint(equalToConstant: pointWidth)
        portraitTopBaseHeight = topBase.heightAnchor.constraint(equalToConstant: pointHeight / 2)

//        portraitTopBaseWidth.identifier = "11"
//        portraitTopBaseHeight.identifier = "12"
//        landscapeTopBaseWidth.identifier = "13"
//        landscapeTopBaseHeight.identifier = "14"
        
        self.view.addSubview(bottomBase)
//        bottomBase.configureRight(viewToRelate: self.view)
        bottomBase.translatesAutoresizingMaskIntoConstraints = false
        bottomBase.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        bottomBase.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        
        landscapeBottomBaseWidth = bottomBase.widthAnchor.constraint(equalToConstant: pointHeight / 2)
        landscapeBottomBaseHeight = bottomBase.heightAnchor.constraint(equalToConstant: pointWidth)
        portraitBottomBaseWidth = bottomBase.widthAnchor.constraint(equalToConstant: pointWidth)
        portraitBottomBaseHeight = bottomBase.heightAnchor.constraint(equalToConstant: pointHeight / 2)
        
//        portraitBottomBaseWidth.identifier = "21"
//        portraitBottomBaseHeight.identifier = "22"
//        landscapeBottomBaseWidth.identifier = "23"
//        landscapeBottomBaseHeight.identifier = "24"
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        locationTextLabel.text = mapVC.locationName
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
//        locationTextLabel.configureAsBottom(viewToRelate: topBase, text: "")
        locationTextLabel.createAsTextField()
        locationTextLabel.create(text: "")
//        locationTextLabel.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: self.frame.height))
//        locationTextLabel.leftViewMode = .always
        locationTextLabel.padding = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        locationTextLabel.font = UIFont(name: "Montserrat-Regular", size: 20)
        
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
//        lenghtLabel.configureAsTop(viewToRelate: bottomBase, text: "lenght")
        
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
        let geoPoint = mapVC.locationCoordinate
        let name = nameTextField.text!
        let lenght = timePicker.getTime()
        let locationName = mapVC.locationName
        
        let time = NSDate().timeIntervalSince1970
        let myTimeInterval = TimeInterval(time)
        let timestamp = NSDate(timeIntervalSince1970: TimeInterval(myTimeInterval))
        if (segmentControl.selectedSegmentIndex == 1) {
            Firebase.createActivity(name: name, lenght: lenght, locationName: locationName, geoPoint: geoPoint, timestamp: timestamp as Date) { (complete) in
                if (complete) {
                    self.resetData()
                } else {
                    print("Connection with firebase went down")
                }
            }
        } else {
            CoreData.createActivity(name: name, lenght: lenght, locationName: locationName, geoPoint: geoPoint, timestamp: timestamp as Date) { (complete) in
                if (complete) {
                    self.resetData()
                } else {
                    print("Something went wrong with coreData")
                }
            }
        }
        self.createButton.isEnabled = true
    }
    
    func resetData() {
        self.nameTextField.text = ""
        self.lenghtTextField.text = ""
        self.locationTextLabel.text = ""
        let numberOfComponents = self.timePicker.numberOfComponents(in: self.timePicker)
        var i = 0
        while (i < numberOfComponents) {
            self.timePicker.selectRow(0, inComponent: i, animated: true)
            i += 1
        }
    }
    override func viewWillLayoutSubviews() {

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
