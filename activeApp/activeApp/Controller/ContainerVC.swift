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
    var isExpanded = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = BLUE
        configureNewActivityVC()
    }
    
    func configureNewActivityVC() {
        let newActivityVC = NewActivityVC()
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
            print("Added navigationVC")
        }
    }
    
    func showNavigationVC(shouldExpand: Bool, navigationOption: NavigationOption?) {
        if(shouldExpand) {
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
                self.centerVC.view.frame.origin.x = self.centerVC.view.frame.width - 80
            }, completion: nil)
        } else {
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
                
            }, completion: nil)
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
            if (activitiesVC == nil) {
                activitiesVC = ActivitiesVC()
            }
            self.present(activitiesVC, animated: true, completion: nil)
        }
    }
}

extension ContainerVC: NewActivityVCDelegate {
    func menuToggle(forOption option: NavigationOption) {
        if (!isExpanded) {
            configureNavigationVC()
        }
        isExpanded = !isExpanded
        showNavigationVC(shouldExpand: isExpanded, navigationOption: option)
    }

}
