//
//  NavigationVC.swift
//  activeApp
//
//  Created by marek holik on 16/06/2019.
//  Copyright © 2019 marek holik. All rights reserved.
//

import UIKit

class NavigationVC: UIViewController {

    var navigationNC: NavigationNC!
    var controllers: [SlidableVC]!
    var buttons: [NavigationButton]!
    
    override func viewDidLoad() {
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(hideNavigation))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
    }
    
    @objc func hideNavigation() {
        navigationNC.chosenVC.move()
    }
    
    func addButtons(navigationNC: NavigationNC, controllers: [SlidableVC]) {
        var topAnchor = 200
        buttons = [NavigationButton]()
        self.navigationNC = navigationNC
        self.controllers = controllers
        for controller in controllers {
            let button = NavigationButton()
            self.view.addSubview(button)
            button.configure(navigationNC: navigationNC, controller: controller, text: controller.name)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.widthAnchor.constraint(equalToConstant: 250).isActive = true
            button.heightAnchor.constraint(equalToConstant: 40).isActive = true
            button.topAnchor.constraint(equalTo: self.view.topAnchor, constant: CGFloat(topAnchor)).isActive = true
            button.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
            topAnchor += 50
            buttons.append(button)
        }
    }
}
