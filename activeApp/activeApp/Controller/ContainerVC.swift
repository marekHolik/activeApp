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
            print("Added navigationVC")
        }
    }
    
    func showNavigationVC(shouldExpand: Bool) {
        if(shouldExpand) {
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
                self.centerVC.view.frame.origin.x = self.centerVC.view.frame.width - 80
            }, completion: nil)
        } else {
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
                self.centerVC.view.frame.origin.x = 0
            }, completion: nil)
        }
    }
}

extension ContainerVC: NewActivityVCDelegate {
    func menuToggle() {
        if (!isExpanded) {
            configureNavigationVC()
        }
        isExpanded = !isExpanded
        showNavigationVC(shouldExpand: isExpanded)
    }
}
