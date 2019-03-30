//
//  ActivityCell.swift
//  activeApp
//
//  Created by marek holik on 30/03/2019.
//  Copyright © 2019 marek holik. All rights reserved.
//

import UIKit
import MapKit

class ActivityCell: UITableViewCell {

    let background = UIView()
    let activityLabel = UILabel()
    let timeLabel = UILabel()
    let locationLabel = UILabel()
    let map = MKMapView()
    
    let labelsWidth: CGFloat = 150
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func configureCell(viewToRelate view: Any, activity: Activity) {
        addBackground()
        addActivityLabel()
        addTimeLabel()
        addLocationLabel()
        addMap()
        
        self.background.backgroundColor = setBackgroundColor(type: activity.storage!)
        self.activityLabel.text = activity.name
        self.timeLabel.text = activity.lenght?.formatToTime()
        self.locationLabel.text = activity.locationName
        self.map.setRegion(MKCoordinateRegion(center: activity.locationCoordinate!, latitudinalMeters: 1000, longitudinalMeters: 1000), animated: false)
        
    }
    
    func addMap() {
        background.addSubview(map)
        map.translatesAutoresizingMaskIntoConstraints = false
        map.centerYAnchor.constraint(equalTo: background.centerYAnchor).isActive = true
        map.trailingAnchor.constraint(equalTo: background.trailingAnchor, constant: -15).isActive = true
        map.widthAnchor.constraint(equalToConstant: 70).isActive = true
        map.heightAnchor.constraint(equalToConstant: 70).isActive = true
        map.layer.cornerRadius = 7.5
        
    }
    
    func addLocationLabel() {
        background.addSubview(locationLabel)
        locationLabel.font = UIFont(name: "Montserrat-Light", size: 20)
        locationLabel.textColor = .white
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 0).isActive = true
        locationLabel.leadingAnchor.constraint(equalTo: background.leadingAnchor, constant: 15).isActive = true
        locationLabel.widthAnchor.constraint(equalToConstant: labelsWidth).isActive = true
        locationLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
    }
    
    func addTimeLabel() {
        background.addSubview(timeLabel)
        timeLabel.font = UIFont(name: "Montserrat-Light", size: 20)
        timeLabel.textColor = .white
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.topAnchor.constraint(equalTo: activityLabel.bottomAnchor).isActive = true
        timeLabel.leadingAnchor.constraint(equalTo: background.leadingAnchor, constant: 15).isActive = true
        timeLabel.widthAnchor.constraint(equalToConstant: labelsWidth)
        timeLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    func addActivityLabel() {
        background.addSubview(activityLabel)
        activityLabel.font = UIFont(name: "Montserrat-Regular", size: 25)
        activityLabel.textColor = .white
        activityLabel.translatesAutoresizingMaskIntoConstraints = false
        activityLabel.widthAnchor.constraint(equalToConstant: labelsWidth).isActive = true
        activityLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        activityLabel.leadingAnchor.constraint(equalTo: background.leadingAnchor, constant: 15).isActive = true
        activityLabel.topAnchor.constraint(equalTo: background.topAnchor, constant: 15).isActive = true
    }
    
    func addBackground() {
        self.addSubview(background)
        background.translatesAutoresizingMaskIntoConstraints = false
        background.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        background.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        background.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        background.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5).isActive = true
        background.layer.cornerRadius = 15
        background.layer.masksToBounds = true
    }
    
    func setBackgroundColor(type: Storage) -> UIColor {
        switch type {
        case .firebase:
            return ORANGE
        default:
            return BLUE
        }
    }
}
