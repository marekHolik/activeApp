//
//  Activity.swift
//  activeApp
//
//  Created by Marek Holík on 21/03/2019.
//  Copyright © 2019 marek holik. All rights reserved.
//

import UIKit
import MapKit

class Activity {

let name: String?
let lenght: Int?
let locationName: String?
let locationCoordinate: CLLocationCoordinate2D?
let storage: Storage?

init(name: String, lenght: Int, locationName: String, locationCoordinate: CLLocationCoordinate2D, storage: Storage) {
    self.name = name
    self.lenght = lenght
    self.locationName = locationName
    self.locationCoordinate = locationCoordinate
    self.storage = storage
    }
}

enum Storage {
    case firebase
    case local
}
