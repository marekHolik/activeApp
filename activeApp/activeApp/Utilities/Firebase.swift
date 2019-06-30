//
//  Firebase.swift
//  activeApp
//
//  Created by Marek Holík on 19/03/2019.
//  Copyright © 2019 marek holik. All rights reserved.
//

import Foundation
import Firebase
import MapKit

class Firebase {
    
    class func createActivity(name: String, lenght: Int, locationName: String, geoPoint: CLLocationCoordinate2D, timestamp: Date, completion: @escaping (_ finished: Bool) -> ()) {
        
        Firestore.firestore().collection(ACTIVITIES_REF).addDocument(data: [
            ACTIVITIES_NAME : name,
            ACTIVITIES_LENGHT : lenght,
            ACTIVITIES_LOCATION_NAME : locationName,
            ACTIVITIES_COORDINATE : GeoPoint(latitude: geoPoint.latitude, longitude: geoPoint.longitude),
            ACTIVITIES_TIMESTAMP : timestamp
            ])
        { (error) in
            if error != nil {
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    class func parse(snapshot: QuerySnapshot?) -> [Activity] {
        var activities = [Activity]()
        
        guard let snapshot = snapshot else { return activities }
        for document in snapshot.documents {
            let activityData = document.data()
            let name = activityData[ACTIVITIES_NAME] as? String ?? "Anonymous"
            let lenght = activityData[ACTIVITIES_LENGHT] as? Int ?? 13482
            let locationName = activityData[ACTIVITIES_LOCATION_NAME] as? String ?? "Home"
            let geoPoint = activityData[ACTIVITIES_COORDINATE] as? GeoPoint
            let timestamp = activityData[ACTIVITIES_TIMESTAMP] as? Timestamp
            let newActivity = Activity(name: name, lenght: lenght, locationName: locationName,
                                       latitude: geoPoint!.latitude, longitude: geoPoint!.longitude, timestamp: (timestamp?.dateValue())!, storage: .firebase)
            activities.append(newActivity)
        }
        return activities
    }
    
}
