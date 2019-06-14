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
    let latitude: Double?
    let longitude: Double?
    let timestamp: Date
    let storage: Storage?

    init(name: String, lenght: Int, locationName: String, latitude: Double, longitude: Double, timestamp: Date, storage: Storage) {
        self.name = name
        self.lenght = lenght
        self.locationName = locationName
        self.latitude = latitude
        self.longitude = longitude
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
            let geoPoint = activityData[ACTIVITIES_COORDINATE] as? GeoPoint
            let date = activityData[ACTIVITIES_DATE] as? Date ?? Date()
            
            let newActivity = Activity(name: name, lenght: lenght, locationName: locationName,
                                       latitude: geoPoint!.latitude, longitude: geoPoint!.longitude, timestamp: date, storage: .firebase)
            activities.append(newActivity)
        }
        return activities
    }
}

enum Storage {
    case firebase
    case local
}
