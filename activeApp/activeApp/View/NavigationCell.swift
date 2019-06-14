//
//  NavigationCell.swift
//  activeApp
//
//  Created by marek holik on 14/06/2019.
//  Copyright © 2019 marek holik. All rights reserved.
//

import UIKit

class NavigationCell: UITableViewCell {

    let optionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "Montserrat-Light", size: 20)
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(optionLabel)
        optionLabel.translatesAutoresizingMaskIntoConstraints = false
        optionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        optionLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
