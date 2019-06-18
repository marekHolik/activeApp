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
            ACTIVITIES_DATE : timestamp
            ])
        { (error) in
            if let error = error {
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
}
