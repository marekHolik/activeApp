//
//  ControllerNC.swift
//  activeApp
//
//  Created by marek holik on 30/06/2019.
//  Copyright © 2019 marek holik. All rights reserved.
//

import UIKit

class ControllerNC: UINavigationController, ControllerNCDelegate {
    
    var newActivityVC: NewActivityVC!
    var activitiesVC: ActivitiesVC!
    var slideControllers: [SlidingVC]!
    var navigationVC: NavigationVC!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.isHidden = true
        
        configureNewActivityVC()
        activitiesVC = ActivitiesVC(controllerNC: self, name: "activities")
        slideControllers = [newActivityVC, activitiesVC]
        configureNavigationVC()
        
        pushViewController(navigationVC, animated: false)
        pushViewController(newActivityVC, animated: false)
    }
    
    private func configureNavigationVC() {
        navigationVC = NavigationVC()
        navigationVC.view.backgroundColor = #colorLiteral(red: 0.1019607843, green: 0.6862745098, blue: 1, alpha: 1)
        navigationVC.configureButtons(controllerNC: self, viewControllers: slideControllers)
    }
    
    private func configureNewActivityVC() {
        newActivityVC = NewActivityVC(controllerNC: self, name: "new activity")
    }
    
    func slideVC(controller: UIViewController) {
        pushViewController(controller, animated: true)
    }
    
    func dismissVC() {
        popViewController(animated: true)
    }

}
