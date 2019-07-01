//
//  ViewExt.swift
//  activeApp
//
//  Created by Marek Holík on 19/03/2019.
//  Copyright © 2019 marek holik. All rights reserved.
//

import UIKit

extension UIView {
    
    //base method for configuring a view in NewActivityVC
    func configure(viewToRelate view: AnyObject) {
        self.removeConstraints(self.constraints)
        self.translatesAutoresizingMaskIntoConstraints = false
        let horizontalCenter = self.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        let width = self.widthAnchor.constraint(equalToConstant: 250)
        let height = self.heightAnchor.constraint(equalToConstant: 30)
        
        NSLayoutConstraint.activate([horizontalCenter, width, height])
    }
    
    //configuring a view as a first element in a view, other views' constraints are related to this view
    
    func configureAsTopView(viewToRelate view: AnyObject) {
        configure(viewToRelate: view)
        let superWidth = view.frame.size.width
        let superHeight = view.frame.size.height
        self.topAnchor.constraint(equalTo: view.topAnchor, constant: superWidth > superHeight ? (superHeight / 2) - 50 : 0).isActive = true
    }
    
    func configureAsBottomView(viewToRelate view: AnyObject) {
        configure(viewToRelate: view)
        let superWidth = view.frame.size.width
        let superHeight = view.frame.size.height
        self.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: superWidth > superHeight ? (50 - superHeight / 2) : -30).isActive = true
    }
    
    //relating a view to view's first element
    
    func configureFromTopView(viewToRelate view: AnyObject, itemToRelate item: AnyObject, constant: CGFloat) {
        configure(viewToRelate: view)
        self.topAnchor.constraint(equalTo: item.bottomAnchor, constant: constant).isActive = true
    }
    
    func configureFromBottomView(viewToRelate view: AnyObject, itemToRelate item: AnyObject, constant: CGFloat) {
        configure(viewToRelate: view)
        self.bottomAnchor.constraint(equalTo: item.topAnchor, constant: constant).isActive = true
    }
}
