//
//  HolderView.swift
//  activeApp
//
//  Created by Marek Holík on 19/03/2019.
//  Copyright © 2019 marek holik. All rights reserved.
//

import UIKit

class HolderView: UIView {

    func configureLeft(viewToRelate view: AnyObject) {
        configureBase(viewToRelate: view)
        self.leadingAnchor.constraint(equalTo: (view.safeAreaLayoutGuide?.leadingAnchor)!).isActive = true
        self.topAnchor.constraint(equalTo: (view.safeAreaLayoutGuide?.topAnchor)!).isActive = true
        
    }
    
    func configureRight(viewToRelate view: AnyObject) {
        configureBase(viewToRelate: view)
        self.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func configureBase(viewToRelate view: AnyObject) {
        translatesAutoresizingMaskIntoConstraints = false
        
        removeConstraints(self.constraints)
        
        let superWidth = view.safeAreaLayoutGuide?.layoutFrame.width
        let superHeight = view.safeAreaLayoutGuide?.layoutFrame.height
        let width =  self.widthAnchor.constraint(equalToConstant: ((superWidth?.isLess(than: superHeight!))!) ? superWidth! : superWidth! / 2)
        let height = self.heightAnchor.constraint(equalToConstant: ((superWidth?.isLess(than: superHeight!))!) ? superHeight! / 2 : superHeight!)
        NSLayoutConstraint.activate([width, height])
    }

}
