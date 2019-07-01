//
//  SlidingVC.swift
//  activeApp
//
//  Created by marek holik on 30/06/2019.
//  Copyright © 2019 marek holik. All rights reserved.
//

import UIKit

class SlidingVC: UIViewController {

    var button: NavigationButton!
    var name: String!
    var delegate: ControllerNCDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureButton()
        addSwipe()
    }
    
    init(controllerNC: ControllerNC, name: String) {
        super.init(nibName: nil, bundle: nil)
        self.delegate = controllerNC
        self.name = name
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //objc methods
    
    @objc func slide() {
        delegate.dismissVC()
        dismiss(animated: false, completion: nil)
    }
    
    //UX methods
    
    func addSwipe() {
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(slide))
        swipe.direction = .right
        view.addGestureRecognizer(swipe)
    }
    
    //UI methods
    
    func configureButton() {
        button = NavigationButton()
        view.addSubview(button)
        button.setImage(BURGER, for: .normal)
        button.addTarget(self, action: #selector(slide), for: .touchUpInside)
        button.controllerBehind = self
    }
    
}
