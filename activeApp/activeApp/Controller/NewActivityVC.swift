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

class NewActivityVC: SlidingVC {

    private var headlineLabel: HeadlineLabel!
    private var nameLabel: ActivityLabel!
    private var nameTextField: ActivityTextField!
    private var locationLabel: ActivityLabel!
    private var locationTextLabel: ActivityLabel!
    private var lenghtLabel: ActivityLabel!
    private var lenghtTextField: ActivityTextField!
    private var timePicker: TimePicker!
    private var storeLabel: ActivityLabel!
    private var createButton: ActivityButton!
    private var topBase: HolderView!
    private var bottomBase: HolderView!
    private var segmentControl: UISegmentedControl!
    
    var mapVC: MapVC!
    
    
    
    //constraint of holderViews
    private var portraitTopBaseWidth: NSLayoutConstraint!
    private var portraitTopBaseHeight: NSLayoutConstraint!
    private var landscapeTopBaseWidth: NSLayoutConstraint!
    private var landscapeTopBaseHeight: NSLayoutConstraint!

    private var portraitBottomBaseWidth: NSLayoutConstraint!
    private var portraitBottomBaseHeight: NSLayoutConstraint!
    private var landscapeBottomBaseWidth: NSLayoutConstraint!
    private var landscapeBottomBaseHeight: NSLayoutConstraint!
    
    //constraints
    private var portraitTextLbl: NSLayoutConstraint!
    private var landscapeTextLbl: NSLayoutConstraint!
    
    private var portraitLenghtLbl: NSLayoutConstraint!
    private var landscapeLenghtLbl: NSLayoutConstraint!
    
    //measures
    private var pixelWidth = CGFloat()
    private var pixelHeight = CGFloat()
    private var pointWidth = CGFloat()
    private var pointHeight = CGFloat()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        baseConstraintsAndMeasures()
        
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        baseSetup()
        addBaseViews()
        addTopViews()
        addBottomViews()
        addSegmentControl()
        
        mapVC = MapVC()
        
        setConstraints()
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
            
            timePicker.activateLandscapeConstraints()
            
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
            
            timePicker.activatePortraitConstraints()
        }
    }
    
    private func resetData() {
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
    
    //objc methods
    
    @objc private  func hideKeyboard() {
        view.endEditing(true)
    }
    
    @objc private  func createNewActivity(_ handler: Bool) {
        createButton.isEnabled = false
        let geoPoint = mapVC.locationCoordinate
        let name = nameTextField.text!
        let lenght = timePicker.getTime()
        let locationName = mapVC.locationName
        
        let time = NSDate().timeIntervalSince1970
        let myTimeInterval = TimeInterval(time)
        let timestamp = NSDate(timeIntervalSince1970: TimeInterval(myTimeInterval))
        
        nameTextField.text == "" ? nameRed() : nameBlue()
        lenghtTextField.text == "" ? lenghtRed() : lenghtBlue()
        locationTextLabel.text == "" ? locationRed() : locationBlue()
        
        if (nameTextField.text != "" && lenghtTextField.text != "" && mapVC.locationName != "") {
            if (segmentControl.selectedSegmentIndex == 1) {
                Firebase.createActivity(name: name, lenght: lenght, locationName: locationName!, geoPoint: geoPoint!, timestamp: timestamp as Date) { (complete) in
                    if (complete) {
                        self.resetData()
                    } else {
                        print("Connection with firebase went down")
                    }
                }
            } else {
                CoreData.createActivity(name: name, lenght: lenght, locationName: locationName!, geoPoint: geoPoint!, timestamp: timestamp as Date) { (complete) in
                    if (complete) {
                        self.resetData()
                    } else {
                        print("Something went wrong with coreData")
                    }
                }
            }
        }
        self.createButton.isEnabled = true
    }
    
    @objc private func presentMapVC(_ sender: Any) {
        delegate.slideVC(controller: mapVC)
        if (mapVC.delegate == nil) {
            mapVC.delegate = delegate
        }
        
        if (mapVC.labelToFill == nil) {
            mapVC.labelToFill = locationTextLabel
        }
    }
    
    @objc private func timePickerValuedChanged(sender: TimePicker) {
        self.lenghtTextField.text = timePicker.getTime().formatToTime()
    }
    
    //UX methods
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    //constraints handling
    
    private func setConstraints() {
        //topBase's constraints
        if (self.view.frame.size.height > self.view.frame.size.width) {
            portraitTextLbl.isActive = true
            portraitLenghtLbl.isActive = true
            portraitTopBaseWidth.isActive = true
            portraitTopBaseHeight.isActive = true
            portraitBottomBaseWidth.isActive = true
            portraitBottomBaseHeight.isActive = true
            timePicker.activatePortraitConstraints()
        } else {
            landscapeTextLbl.isActive = true
            landscapeLenghtLbl.isActive = true
            landscapeTopBaseWidth.isActive = true
            landscapeTopBaseHeight.isActive = true
            landscapeBottomBaseWidth.isActive = true
            landscapeBottomBaseHeight.isActive = true
            timePicker.activateLandscapeConstraints()
        }
    }
    
    private func baseConstraintsAndMeasures() {
        //constraint of holderViews
        portraitTopBaseWidth = NSLayoutConstraint()
        portraitTopBaseHeight = NSLayoutConstraint()
        landscapeTopBaseWidth = NSLayoutConstraint()
        landscapeTopBaseHeight = NSLayoutConstraint()
        
        portraitBottomBaseWidth = NSLayoutConstraint()
        portraitBottomBaseHeight = NSLayoutConstraint()
        landscapeBottomBaseWidth = NSLayoutConstraint()
        landscapeBottomBaseHeight = NSLayoutConstraint()
        
        //constraints
        portraitTextLbl = NSLayoutConstraint()
        landscapeTextLbl = NSLayoutConstraint()
        
        portraitLenghtLbl = NSLayoutConstraint()
        landscapeLenghtLbl = NSLayoutConstraint()
        
        //measures
        pixelWidth = CGFloat()
        pixelHeight = CGFloat()
        pointWidth = CGFloat()
        pointHeight = CGFloat()
        
        pixelWidth = UIScreen.main.nativeBounds.width < UIScreen.main.nativeBounds.height ? UIScreen.main.nativeBounds.width : UIScreen.main.nativeBounds.height
        pixelHeight = UIScreen.main.nativeBounds.height > UIScreen.main.nativeBounds.width ? UIScreen.main.nativeBounds.height : UIScreen.main.nativeBounds.width
        pointWidth = pixelWidth / UIScreen.main.nativeScale
        pointHeight = pixelHeight / UIScreen.main.nativeScale
    }
    
    
    //UI methods
    
    private func configureNavigationButton() {
        self.topBase.addSubview(super.button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 30).isActive = true
        button.heightAnchor.constraint(equalToConstant: 20).isActive = true
        button.centerYAnchor.constraint(equalTo: headlineLabel.centerYAnchor).isActive = true
        button.leadingAnchor.constraint(equalTo: topBase.leadingAnchor, constant: 30).isActive = true
        button.addTarget(self, action: #selector(hideKeyboard), for: .touchUpInside)
    }
    
    private func addBaseViews() {
        self.view.addSubview(topBase)
        topBase.translatesAutoresizingMaskIntoConstraints = false
        topBase.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        topBase.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        
        landscapeTopBaseWidth = topBase.widthAnchor.constraint(equalToConstant: pointHeight / 2)
        landscapeTopBaseHeight = topBase.heightAnchor.constraint(equalToConstant: pointWidth)
        portraitTopBaseWidth = topBase.widthAnchor.constraint(equalToConstant: pointWidth)
        portraitTopBaseHeight = topBase.heightAnchor.constraint(equalToConstant: pointHeight / 2)
        
        self.view.addSubview(bottomBase)
        bottomBase.translatesAutoresizingMaskIntoConstraints = false
        bottomBase.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        bottomBase.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        
        landscapeBottomBaseWidth = bottomBase.widthAnchor.constraint(equalToConstant: pointHeight / 2)
        landscapeBottomBaseHeight = bottomBase.heightAnchor.constraint(equalToConstant: pointWidth)
        portraitBottomBaseWidth = bottomBase.widthAnchor.constraint(equalToConstant: pointWidth)
        portraitBottomBaseHeight = bottomBase.heightAnchor.constraint(equalToConstant: pointHeight / 2)
        
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
    
    private func addTopViews() {
        topBase.addSubview(locationTextLabel)
        
        locationTextLabel.configure(viewToRelate: self.topBase)
        portraitTextLbl = locationTextLabel.bottomAnchor.constraint(equalTo: topBase.bottomAnchor, constant: -30)
        landscapeTextLbl = locationTextLabel.bottomAnchor.constraint(equalTo: topBase.bottomAnchor, constant: (75 - (pointWidth / 2)))
        
        locationTextLabel.createAsTextField()
        locationTextLabel.create(text: "")
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
        headlineLabel.translatesAutoresizingMaskIntoConstraints = false
        headlineLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 40).isActive = true
        headlineLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        headlineLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
        headlineLabel.widthAnchor.constraint(equalToConstant: 250).isActive = true
        headlineLabel.create(text: "newActivity")
        
        configureNavigationButton()
    }
    
    private func addBottomViews() {
        bottomBase.addSubview(lenghtLabel)
        lenghtLabel.configure(viewToRelate: self.bottomBase)
        lenghtLabel.create(text: "lenght")
        portraitLenghtLbl = lenghtLabel.topAnchor.constraint(equalTo: bottomBase.topAnchor, constant: 0)
        landscapeLenghtLbl = lenghtLabel.topAnchor.constraint(equalTo: bottomBase.topAnchor, constant: ((pointWidth / 2) - 75))
        
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
    
    private func baseSetup() {
        headlineLabel = HeadlineLabel()
        nameLabel = ActivityLabel()
        nameTextField = ActivityTextField()
        locationLabel = ActivityLabel()
        locationTextLabel = ActivityLabel()
        lenghtLabel = ActivityLabel()
        lenghtTextField = ActivityTextField()
        timePicker = TimePicker()
        storeLabel = ActivityLabel()
        createButton = ActivityButton()
        topBase = HolderView()
        bottomBase = HolderView()
        segmentControl = UISegmentedControl(items: ["local", "firebase"])
    }
    
    func nameRed() {
        nameLabel.red()
        nameTextField.red()
    }
    
    func nameBlue() {
        nameLabel.blue()
        nameTextField.blue()
    }
    
    func locationRed() {
        locationLabel.red()
        locationTextLabel.layer.borderColor = RED.cgColor
    }
    
    func locationBlue() {
        locationLabel.blue()
        locationTextLabel.layer.borderColor = BLUE.cgColor
    }
    
    func lenghtRed() {
        lenghtLabel.red()
        lenghtTextField.red()
    }
    
    func lenghtBlue() {
        lenghtLabel.blue()
        lenghtTextField.blue()
    }

}

extension NewActivityVC: UITextFieldDelegate, UIGestureRecognizerDelegate {
}
