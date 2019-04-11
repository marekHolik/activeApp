//
//  NSLayoutConstraintExt.swift
//  activeApp
//
//  Created by marek holik on 11/04/2019.
//  Copyright © 2019 marek holik. All rights reserved.
//

import UIKit

extension NSLayoutConstraint {
    override open var description: String {
        let id = identifier ?? ""
        return "id: \(id), constant: \(constant)" //you may print whatever you want here
    }
}
