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
        navigationNC.chosenVC.slide()
    }
    
    func addButtons(navigationNC: NavigationNC, controllers: [SlidableVC]) {
        var topAnchor = 120
        buttons = [NavigationButton]()
        self.navigationNC = navigationNC
        self.controllers = controllers
        let width = CGFloat(170)
        let height = CGFloat(40)
        
        for controller in controllers {
            let button = NavigationButton()
            self.view.addSubview(button)
            let deviceWidth = controller.deviceWidth!
            let slideConstant = controller.slideConstant
            button.configure(navigationNC: navigationNC, controller: controller, text: controller.name)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.widthAnchor.constraint(equalToConstant: width).isActive = true
            button.heightAnchor.constraint(equalToConstant: height).isActive = true
            button.topAnchor.constraint(equalTo: self.view.topAnchor, constant: CGFloat(topAnchor)).isActive = true
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: (deviceWidth * slideConstant! / 2) - (width / 2)).isActive = true
            topAnchor += 50
            buttons.append(button)
        }
        buttons[0].addTarget(self, action: #selector(reloadNewActivityVC), for: .touchUpInside)
        buttons[1].addTarget(self, action: #selector(reloadActivitiesVC), for: .touchUpInside)
    }
    
    @objc func reloadNewActivityVC() {
        let controller = controllers[0] as! NewActivityVC
        controller.mapVC.remove()
        controller.mapVC.prepare()
    }
    
    @objc func reloadActivitiesVC() {
        let controller = controllers[1] as! ActivitiesVC
        controller.fetchAllData()
    }
}
