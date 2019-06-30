//
//  ControllerNC.swift
//  activeApp
//
//  Created by marek holik on 30/06/2019.
//  Copyright © 2019 marek holik. All rights reserved.
//

import UIKit

class ControllerNC: UINavigationController {

    var button: UIButton!
    
    var newActivityVC: NewActivityVC!
    var activitiesVC: ActivitiesVC!
    var slideControllers: [SlidingVC]!
    var navigationVC: NavigationVC!
    var chosenVC: SlidingVC!
    var deviceWidth: CGFloat!
    var slideConstant: CGFloat!
    var mapVC: MapVC!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.isHidden = true
        view.backgroundColor = #colorLiteral(red: 0.4, green: 0.8156862745, blue: 0.431372549, alpha: 1)
        deviceWidth = self.view.frame.height > self.view.frame.width ? self.view.frame.width : self.view.frame.height
        slideConstant = 0.8
        
        configureNewActivityVC()
        
        activitiesVC = ActivitiesVC(controllerNC: self, deviceWidth: deviceWidth, name: "activities")
        slideControllers = [newActivityVC, activitiesVC]
        
        mapVC = MapVC()
        newActivityVC.mapVC = mapVC
        
        configureNavigationVC()
        pushViewController(navigationVC, animated: false)
    }
    
    
    
    private func configureNavigationVC() {
        navigationVC = NavigationVC()
        navigationVC.view.backgroundColor = #colorLiteral(red: 0.1019607843, green: 0.6862745098, blue: 1, alpha: 1)
        navigationVC.configureButtons(controllerNC: self, viewControllers: slideControllers)
    }
    
    private func configureNewActivityVC() {
        newActivityVC = NewActivityVC(controllerNC: self, deviceWidth: deviceWidth, name: "new activity")
    }
    
    func slideVC(controller: SlidingVC) {
        pushViewController(controller, animated: true)
    }
    
    func dismissVC() {
        popViewController(animated: true)
    }

}
