//
//  IntExt.swift
//  activeApp
//
//  Created by Marek Holík on 19/03/2019.
//  Copyright © 2019 marek holik. All rights reserved.
//

import Foundation

extension Int {
    func formatToTime() -> String {
        let hours = self / 3600
        let minutes = (self % 3600) / 60
        let seconds = (self % 3600) % 60
        
        if hours == 0 {
            return String(format: "%02d : %02d", minutes, seconds)
        }
        return String(format: "%d : %02d : %02d", hours, minutes, seconds)
    }
}
