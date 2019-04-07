//
//  Activity.swift
//  activeApp
//
//  Created by Marek Holík on 21/03/2019.
//  Copyright © 2019 marek holik. All rights reserved.
//

import UIKit
import MapKit
import Firebase

class Activity {

let name: String?
let lenght: Int?
let locationName: String?
let locationCoordinate: CLLocationCoordinate2D?
let timestamp: Date
let storage: Storage?

    init(name: String, lenght: Int, locationName: String, locationCoordinate: CLLocationCoordinate2D, timestamp: Date, storage: Storage) {
    self.name = name
    self.lenght = lenght
    self.locationName = locationName
    self.locationCoordinate = locationCoordinate
    self.timestamp = timestamp
    self.storage = storage
    }
    
    class func parseFirebase(snapshot: QuerySnapshot?) -> [Activity] {
        var activities = [Activity]()
        
        guard let snapshot = snapshot else { return activities }
        for document in snapshot.documents {
            let activityData = document.data()
            let name = activityData[ACTIVITIES_NAME] as? String ?? "Anonymous"
            let lenght = activityData[ACTIVITIES_LENGHT] as? Int ?? 13482
            let locationName = activityData[ACTIVITIES_LOCATION_NAME] as? String ?? "Home"
            let locationCoordinate = activityData[ACTIVITIES_COORDINATE] as? CLLocationCoordinate2D ?? CLLocationCoordinate2D(latitude: 24.24, longitude: 29.24)
            let date = activityData[ACTIVITIES_DATE] as? Date ?? Date()
            
            let newActivity = Activity(name: name, lenght: lenght, locationName: locationName, locationCoordinate: locationCoordinate, timestamp: date, storage: .firebase)
            activities.append(newActivity)
        }
        return activities
    }
}

enum Storage {
    case firebase
    case local
}
