//
//  HeadlineLabel.swift
//  activeApp
//
//  Created by Marek Holík on 19/03/2019.
//  Copyright © 2019 marek holik. All rights reserved.
//

import UIKit

class HeadlineLabel: UILabel {

    func create(text: String) {
        self.textColor = #colorLiteral(red: 0.1019607843, green: 0.6862745098, blue: 1, alpha: 1)
        self.text = text
        self.font = UIFont(name: "Montserrat-Regular", size: 30)
        self.textAlignment = .center
    }
    
    func configureAsTop(viewToRelate view: AnyObject, constant: CGFloat, text: String) {
        self.removeConstraints(self.constraints)
        super.configure(viewToRelate: view)

        self.topAnchor.constraint(equalTo: (view.safeAreaLayoutGuide?.topAnchor)!, constant: constant).isActive = true
        create(text: text)
    }

}
