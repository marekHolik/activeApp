//
//  SlidableVC.swift
//  activeApp
//
//  Created by marek holik on 16/06/2019.
//  Copyright © 2019 marek holik. All rights reserved.
//

import UIKit

class SlidableVC: UIViewController {

    var button: UIButton!
    var slided: Bool!
    var name: String!
    var deviceWidth: CGFloat!
    var slideConstant: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addButton()
        slided = false
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(showMenu))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(hideMenu))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
    }
    
    init(deviceWidth: CGFloat, slideConstant: CGFloat) {
        super.init(nibName: nil, bundle: nil)
        self.deviceWidth = deviceWidth
        self.slideConstant = slideConstant
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func showMenu() {
        if (!self.slided) {
            self.move()
        }
    }
    
    @objc func hideMenu() {
        if (self.slided) {
            self.move()
        }
    }
    
    func addButton() {
        button = UIButton()
        button.setImage(BURGER, for: .normal)
        button.addTarget(self, action: #selector(move), for: .touchUpInside)
    }
    
    @objc func move() {
        let distance = deviceWidth * slideConstant
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.view.frame.origin.x = self.view.frame.origin.x + (self.slided ? -distance : distance)
        }, completion: nil)
        slided = !slided
    }
    
    func show() {
        parent?.view.addSubview(self.view)
        self.view.isHidden = false
    }
    
    func hide() {
        self.view.removeFromSuperview()
    }
    
    func prepare() {
        parent?.view.addSubview(self.view)
        self.move()
        self.view.isHidden = true
    }
    
    func getRandomColor() -> UIColor{
        let randomRed:CGFloat = CGFloat(arc4random()) / CGFloat(UInt32.max)
        let randomGreen:CGFloat = CGFloat(arc4random()) / CGFloat(UInt32.max)
        let randomBlue:CGFloat = CGFloat(arc4random()) / CGFloat(UInt32.max)
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
    }
}
