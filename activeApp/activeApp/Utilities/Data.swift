//
//  Data.swift
//  activeApp
//
//  Created by Marek Holík on 19/03/2019.
//  Copyright © 2019 marek holik. All rights reserved.
//

import Foundation
import MapKit

class Data {
    func getHours() -> [Int] {
        var hours = [Int]()
        for index in 0...10 {
            hours.append(index)
        }
        return hours
    }
    
    func getSeconds() -> [Int] {
        var secondsMinutes = [Int]()
        for index in 0..<60 {
            secondsMinutes.append(index)
        }
        return secondsMinutes
    }
    
    let activity1 = Activity(name: "run", lenght: 12848, locationName: "starbucks cafe", locationCoordinate: CLLocationCoordinate2D(latitude: 50.075539, longitude: 14.437800), timestamp: Date(timeIntervalSince1970: 1341234), storage: .local)
    let activity2 = Activity(name: "triatlon", lenght: 1234, locationName: "Matterhorn", locationCoordinate: CLLocationCoordinate2D(latitude: 50.035539, longitude: 14.537800), timestamp: Date(timeIntervalSince1970: 123414), storage: .local)
    let activity3 = Activity(name: "golf", lenght: 412, locationName: "Albatross", locationCoordinate: CLLocationCoordinate2D(latitude: 50.025539, longitude: 14.137800), timestamp: Date(timeIntervalSince1970: 2389725), storage: .local)
    
    func getActivities() -> [Activity] {
        return [activity1, activity2, activity3]
    }
}
