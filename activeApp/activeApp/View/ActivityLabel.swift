//
//  ActivityLabel.swift
//  activeApp
//
//  Created by Marek Holík on 19/03/2019.
//  Copyright © 2019 marek holik. All rights reserved.
//

import UIKit

class ActivityLabel: UILabel {

    func create(text: String) {
        self.textColor = #colorLiteral(red: 0.1019607843, green: 0.6862745098, blue: 1, alpha: 1)
        self.text = text
        self.font = UIFont(name: "Montserrat-Regular", size: 20)
        
    }
    
    func configureAsTop(viewToRelate view: AnyObject, text: String) {
        super.configureAsTopView(viewToRelate: view)
        create(text: text)
    }
    
    func configureFromTop(viewToRelate view: AnyObject, itemToRelate item: AnyObject, constant: CGFloat, text: String) {
        super.configureFromTopView(viewToRelate: view, itemToRelate: item, constant: constant)
        create(text: text)
    }
    
    func configureAsBottom(viewToRelate view: AnyObject, text: String) {
        super.configureAsBottomView(viewToRelate: view)
        create(text: text)
    }
    
    func configureFromBottom(viewToRelate view: AnyObject, itemToRelate item: AnyObject, constant: CGFloat, text: String) {
        super.configureFromBottomView(viewToRelate: view, itemToRelate: item, constant: constant)
        create(text: text)
    }
    
    func createAsTextField() {
        //        super.configureAsTop(viewToRelate: view)
        //        create(text: "")
        self.layer.borderWidth = 1
        self.layer.borderColor = LIGHT_BLUE.cgColor
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
    }

}
