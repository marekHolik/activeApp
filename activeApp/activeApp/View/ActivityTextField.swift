//
//  ActivityTextField.swift
//  activeApp
//
//  Created by Marek Holík on 19/03/2019.
//  Copyright © 2019 marek holik. All rights reserved.
//

import UIKit

class ActivityTextField: UITextField {

    func create() {
        self.textColor = BLUE
        self.font = UIFont(name: "Montserrat-Regular", size: 20)
        self.layer.borderWidth = 1
        self.layer.borderColor = #colorLiteral(red: 0.3764705882, green: 0.7843137255, blue: 1, alpha: 1)
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        
        self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: self.frame.height))
        self.leftViewMode = .always
    }
    
    func configureFromTop(viewToRelate view: AnyObject, itemToRelate item: AnyObject, constant: CGFloat) {
        super.configureFromTopView(viewToRelate: view, itemToRelate: item, constant: constant)
        create()
    }
    
    func configureFromBottom(viewToRelate view: AnyObject, itemToRelate item: AnyObject, constant: CGFloat) {
        super.configureFromBottomView(viewToRelate: view, itemToRelate: item, constant: constant)
        create()
    }
}
