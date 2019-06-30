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
}

enum Storage {
    case firebase
    case local
}
