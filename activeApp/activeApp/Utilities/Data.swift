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
}
