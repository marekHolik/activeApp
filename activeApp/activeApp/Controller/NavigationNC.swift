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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationVC()
        configureStartingVC()
        configureActivitesVC()
        slideControllers = [landingVC, activitiesVC]
//        configureAdditionalVC(names: ["activities", "Options", "Matrix", "Reloaded", "Revolutions"])
        chosenVC = slideControllers[0]
        navigationVC.addButtons(navigationNC: self, controllers: slideControllers)
//        print(view.subviews.count)
    }
    
    func configureActivitesVC() {
        activitiesVC = ActivitiesVC()
        activitiesVC.name = "activities"
        addChild(activitiesVC)
        activitiesVC.prepare()
    }
    
    func configureAdditionalVC(names: [String]) {
        for name in names {
            let controller = SlidableVC()
            controller.name = name
            addChild(controller)
            controller.prepare()
            slideControllers.append(controller)
        }
    }
    
    
    func configureNavigationVC() {
        navigationVC = NavigationVC()
        showViewController(controller: navigationVC)
        navigationVC.view.backgroundColor = #colorLiteral(red: 0.1019607843, green: 0.6862745098, blue: 1, alpha: 1)
    }
    
    func configureStartingVC() {
        landingVC = NewActivityVC()
        addChild(landingVC)
        self.view.addSubview(landingVC.view)
        landingVC.name = "new activity"
    }
    
    func showViewController(controller: UIViewController) {
        addChild(controller)
        self.view.addSubview(controller.view)
    }


}
