//
//  NavigationButton.swift
//  activeApp
//
//  Created by marek holik on 16/06/2019.
//  Copyright © 2019 marek holik. All rights reserved.
//

import UIKit

class NavigationButton: UIButton {

    var controllerBehind: SlidableVC!
    var navigationNC: NavigationNC!
    
    func configure(navigationNC: NavigationNC, controller: SlidableVC, text: String) {
        controllerBehind = controller
        self.navigationNC = navigationNC
        self.setTitle(text, for: .normal)
        self.addTarget(self, action: #selector(toggle), for: .touchUpInside)
    }
    
    @objc func toggle() {
        print("At least this hit")
        if (controllerBehind == navigationNC.chosenVC) {
            controllerBehind.move()
            print(navigationNC.view.subviews.count)
        } else {
            controllerBehind.show()
            controllerBehind.move()
            navigationNC.chosenVC.hide()
            navigationNC.chosenVC = controllerBehind
        }
    }
}
