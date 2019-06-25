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

    var background: UIView!
    var activityLabel: UILabel!
    var timeLabel: UILabel!
    var locationLabel: UILabel!
    var map: MKMapView!
    var dateLabel: UILabel!
    
    let labelsWidth: CGFloat = 150
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(viewToRelate view: Any, activity: Activity) {
        addBackground()
//        addMap()
        
        addActivityLabel()
        addTimeLabel()
        addLocationLabel()
        addDateLabel()
        
        self.background.backgroundColor = setBackgroundColor(type: activity.storage!)
        self.activityLabel.text = activity.name
        self.timeLabel.text = activity.lenght?.formatToTime()
        self.locationLabel.text = activity.locationName
        let locationCoordinate = CLLocationCoordinate2D(latitude: activity.latitude!, longitude: activity.longitude!)
        self.map.setRegion(MKCoordinateRegion(center: locationCoordinate, latitudinalMeters: 2000, longitudinalMeters: 2000), animated: false)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        self.dateLabel.text = formatter.string(from: activity.timestamp)
        
    }
    
    func addDateLabel() {
        dateLabel = UILabel()
        background.addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.leadingAnchor.constraint(equalTo: self.locationLabel.leadingAnchor).isActive = true
        dateLabel.topAnchor.constraint(equalTo: self.locationLabel.bottomAnchor).isActive = true
        dateLabel.widthAnchor.constraint(equalToConstant: 80).isActive = true
        dateLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        dateLabel.font = UIFont(name: "Montserrat-Light", size: 15)
        dateLabel.textColor = .white
    }
    
    func addMap() {
        map = MKMapView()
        background.addSubview(map)
        map.translatesAutoresizingMaskIntoConstraints = false
        map.centerYAnchor.constraint(equalTo: background.centerYAnchor).isActive = true
        map.trailingAnchor.constraint(equalTo: background.trailingAnchor, constant: -15).isActive = true
        map.widthAnchor.constraint(equalToConstant: 80).isActive = true
        map.heightAnchor.constraint(equalToConstant: 80).isActive = true
        map.layer.cornerRadius = 15
        map.isScrollEnabled = false
    }
    
    func addLocationLabel() {
        locationLabel = UILabel()
        background.addSubview(locationLabel)
        locationLabel.font = UIFont(name: "Montserrat-Light", size: 15)
        locationLabel.textColor = .white
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 0).isActive = true
        locationLabel.leadingAnchor.constraint(equalTo: background.leadingAnchor, constant: 15).isActive = true
        locationLabel.widthAnchor.constraint(equalToConstant: labelsWidth).isActive = true
        locationLabel.heightAnchor.constraint(equalToConstant: 15).isActive = true
    }
    
    func addTimeLabel() {
        timeLabel = UILabel()
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
        activityLabel = UILabel()
        background.addSubview(activityLabel)
        activityLabel.font = UIFont(name: "Montserrat-Regular", size: 25)
        activityLabel.textColor = .white
        activityLabel.translatesAutoresizingMaskIntoConstraints = false
        activityLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30).isActive = true
        activityLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        activityLabel.leadingAnchor.constraint(equalTo: background.leadingAnchor, constant: 15).isActive = true
        activityLabel.topAnchor.constraint(equalTo: background.topAnchor, constant: 10).isActive = true
    }
    
    func addBackground() {
        background = UIView()
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
