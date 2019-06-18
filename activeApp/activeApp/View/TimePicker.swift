//
//  TimePicker.swift
//  activeApp
//
//  Created by Marek Holík on 19/03/2019.
//  Copyright © 2019 marek holik. All rights reserved.
//

import UIKit

class TimePicker: UIPickerView {

    let data = [Data().getHours(), Data().getSeconds(), Data().getSeconds()]
    
    var labelView: UIView!
    
    var seconds = Int()
    var minutes = Int()
    var hours = Int()

    var label1: UILabel!
    var label2: UILabel!
    var label3: UILabel!
   
    var constraint1P: NSLayoutConstraint!
    var constraint1L: NSLayoutConstraint!
    var constraint2P: NSLayoutConstraint!
    var constraint2L: NSLayoutConstraint!
    var constraint3P: NSLayoutConstraint!
    var constraint3L: NSLayoutConstraint!
    
    let labelWidth = CGFloat(40)
    let labelHeight = CGFloat(20)
    
    func getTime() -> Int {
        let time = hours * 3600 + minutes * 60 + seconds
        return time
    }
    
    func configurePicker(viewToRelate view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = BLUE
        self.dataSource = self
        self.delegate = self
        addLabels()
        setupConstraints()
    }
    
    func setupConstraints() {
        let portraitRatioS = CGFloat(0.1)
        let portraitRatioH = CGFloat(0.4)
        constraint1P = label1.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: self.frame.height * portraitRatioH)
        constraint2P = label2.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: labelWidth)
        constraint3P = label3.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -self.frame.height * portraitRatioS)
        
        let landscapeRatio = CGFloat(0.6)
        constraint1L = label1.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: self.frame.height * landscapeRatio)
        constraint2L = label2.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: labelWidth)
        constraint3L = label3.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -self.frame.height * landscapeRatio)
    }
    
    func activatePortraitConstraints() {
        
//        if (label1.constraints.count > 3) {
//            label1.removeConstraint(constraint1L)
//            label2.removeConstraint(constraint2L)
//            label3.removeConstraint(constraint3L)
//        }
//        label1.addConstraint(constraint1P)
//        label2.addConstraint(constraint2P)
//        label3.addConstraint(constraint3P)
        NSLayoutConstraint.deactivate([constraint1L, constraint2L, constraint3L])
        NSLayoutConstraint.activate([constraint1P, constraint2P, constraint3P])
        print("Portraint constraints activated")
    }
    
    func activateLandscapeConstraints() {
//        label1.removeConstraint(constraint1P)
//        label2.removeConstraint(constraint2P)
//        label3.removeConstraint(constraint3P)
//        label1.addConstraint(constraint1L)
//        label2.addConstraint(constraint2L)
//        label3.addConstraint(constraint3L)
        NSLayoutConstraint.deactivate([constraint1P, constraint2P, constraint3P])
        NSLayoutConstraint.activate([constraint1L, constraint2L, constraint3L])
        print("Landscape constraints activated")
    }
    
    func addLabels() {
        label1 = UILabel()
        label2 = UILabel()
        label3 = UILabel()
        let labels = [label1, label2, label3]
        label1.text = "hours"
        label2.text = "min"
        label3.text = "sec"
        for label in labels {
            self.addSubview(label!)
            label!.font = UIFont(name: "Montserrat-Light", size: 12)
            label!.textAlignment = .left
            label!.textColor = .white
            label!.translatesAutoresizingMaskIntoConstraints = false
            label!.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
            label!.widthAnchor.constraint(equalToConstant: labelWidth).isActive = true
            label!.heightAnchor.constraint(equalToConstant: labelHeight).isActive = true
        }
        label3.textAlignment = .right
    }
}

extension TimePicker: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return data.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data[component].count
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let text = data[component][row]
        return NSAttributedString(string: String(text), attributes: [NSAttributedString.Key.font : UIFont(name: "Montserrat-Light", size: 18)!, NSAttributedString.Key.foregroundColor : #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            hours = data[0][row]
        } else if component == 1 {
            minutes = data[1][row]
        } else {
            seconds = data[2][row]
        }
    }

}
