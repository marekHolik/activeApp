//
//  NavigationOption.swift
//  activeApp
//
//  Created by marek holik on 14/06/2019.
//  Copyright © 2019 marek holik. All rights reserved.
//

import Foundation

enum NavigationOption: Int, CustomStringConvertible {
    
    case NewActivity
    case Activities
    
    var description: String {
        switch self {
            case .NewActivity: return "New Activity"
            case .Activities: return "Activities"
        }
    }
}
