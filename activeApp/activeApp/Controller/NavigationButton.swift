//
//  NavigationButton.swift
//  navbarIV
//
//  Created by marek holik on 30/06/2019.
//  Copyright © 2019 marek holik. All rights reserved.
//

import UIKit

class NavigationButton: UIButton {
    
    var controllerBehind: SlidingVC!
    var delegate: ControllerNCDelegate!

    func configure(controllerNC: ControllerNC, controllerBehind controller: SlidingVC) {
        controllerBehind = controller
        delegate = controllerNC
        self.addTarget(self, action: #selector(push), for: .touchUpInside)
    }
    
    @objc func push() {
        delegate.slideVC(controller: controllerBehind)
    }
    
}
