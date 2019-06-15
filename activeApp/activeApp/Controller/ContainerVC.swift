//
//  ContainerVC.swift
//  activeApp
//
//  Created by marek holik on 14/06/2019.
//  Copyright © 2019 marek holik. All rights reserved.
//

import UIKit

class ContainerVC: UIViewController {

    var navigationVC: NavigationVC!
    var centerVC: UIViewController!
    var activitiesVC: ActivitiesVC!
    var newActivityVC: NewActivityVC!
    var isExpanded = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNewActivityVC()
    }
    
    func configureNewActivityVC() {
        newActivityVC = NewActivityVC()
        centerVC = UINavigationController(rootViewController: newActivityVC)
        newActivityVC.delegate = self
        view.addSubview(centerVC.view)
        addChild(centerVC)
        centerVC.didMove(toParent: self)
    }
    
    func configureNavigationVC() {
        if (navigationVC == nil) {
            navigationVC = NavigationVC()
            view.insertSubview(navigationVC.view, at: 0)
            addChild(navigationVC)
            navigationVC.didMove(toParent: self)
            navigationVC.delegate = self
        }
    }
    
    func showNavigationVC(shouldExpand: Bool, navigationOption: NavigationOption?) {
        if(shouldExpand) {
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
                self.centerVC.view.frame.origin.x = self.centerVC.view.frame.width - 80
            }, completion: nil)
        } else {
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.centerVC.view.frame.origin.x = 0
            }) { (_) in
                self.didSelectNavigationOption(navigationOption: navigationOption!)
            }
        }
    }
    
    func didSelectNavigationOption(navigationOption: NavigationOption) {
        switch navigationOption {
        case .NewActivity:
            print("Show new activity")
        case .Activities:
            activitiesVC = ActivitiesVC()
            activitiesVC.delegate = self
            centerVC = UINavigationController(rootViewController: activitiesVC)
            view.addSubview(centerVC.view)
            addChild(centerVC)
            newActivityVC.removeFromParent()
        }
    }
}

extension ContainerVC: NavigationVCDelegate {
    func menuToggle(forOption option: NavigationOption) {
        if (!isExpanded) {
            configureNavigationVC()
            print("Expanding")
        }
        isExpanded = !isExpanded
        showNavigationVC(shouldExpand: isExpanded, navigationOption: option)
        print("Closing")
    }

}
