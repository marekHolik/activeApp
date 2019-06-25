//
//  NavigationNC.swift
//  activeApp
//
//  Created by marek holik on 16/06/2019.
//  Copyright © 2019 marek holik. All rights reserved.
//

import UIKit

class NavigationNC: UINavigationController {

    var landingVC: NewActivityVC!
    var activitiesVC: ActivitiesVC!
    var slideControllers: [SlidableVC]!
    var navigationVC: NavigationVC!
    var chosenVC: SlidableVC!
    var deviceWidth: CGFloat!
    var slideConstant: CGFloat!
    var mapVC: MapVC!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        deviceWidth = self.view.frame.height > self.view.frame.width ? self.view.frame.width : self.view.frame.height
        slideConstant = 0.8
        configureNavigationVC()
        configureStartingVC()
        slideControllers = [landingVC]
        
        activitiesVC = ActivitiesVC(deviceWidth: deviceWidth, slideConstant: slideConstant, name: "activitites")
        configureAdditionalVC(controllers: [activitiesVC])
        
        chosenVC = slideControllers[0]
        navigationVC.addButtons(navigationNC: self, controllers: slideControllers)
        
        mapVC = MapVC()
        mapVC.prepare()
        mapVC.slide()
        addChild(mapVC)
        landingVC.mapVC = mapVC
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func prepareMapVC() {
        mapVC.slide()
    }
    
    func configureAdditionalVC(controllers: [SlidableVC]) {
        for controller in controllers {
            addChild(controller)
            slideControllers.append(controller)
            controller.prepare()
        }
    }
    
    func configureNavigationVC() {
        navigationVC = NavigationVC()
        showViewController(controller: navigationVC)
        navigationVC.view.backgroundColor = #colorLiteral(red: 0.1019607843, green: 0.6862745098, blue: 1, alpha: 1)
    }
    
    func configureStartingVC() {
        landingVC = NewActivityVC(deviceWidth: deviceWidth, slideConstant: slideConstant, name: "new activity")
        addChild(landingVC)
        self.view.addSubview(landingVC.view)
    }
    
    func showViewController(controller: UIViewController) {
        addChild(controller)
        self.view.addSubview(controller.view)
    }
}
