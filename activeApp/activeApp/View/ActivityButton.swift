//
//  ActivityButton.swift
//  activeApp
//
//  Created by Marek Holík on 19/03/2019.
//  Copyright © 2019 marek holik. All rights reserved.
//

import UIKit

class ActivityButton: UIButton {

    func create(text: String) {
        self.setTitle(text, for: .normal)
        self.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        self.titleLabel!.font = UIFont(name: "Montserrat-Regular", size: 25)!
        self.backgroundColor = #colorLiteral(red: 0.1019607843, green: 0.6862745098, blue: 1, alpha: 1)
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
    }
    
    func configureFromBottom(viewToRelate view: AnyObject, text: String) {
        super.configure(viewToRelate: view)
        self.bottomAnchor.constraint(equalTo: ((view as AnyObject).safeAreaLayoutGuide as AnyObject).bottomAnchor, constant: -20).isActive = true
        create(text: text)
    }
}
