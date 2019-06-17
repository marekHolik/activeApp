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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
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
    }
    
    func addLabels() {
        let labelWidth = CGFloat(40)
        let labelHeight = CGFloat(20)
        let label1 = UILabel()
        let label2 = UILabel()
        let label3 = UILabel()
        let labels = [label1, label2, label3]
        label1.text = "hours"
        label2.text = "min"
        label3.text = "sec"
        for label in labels {
            self.addSubview(label)
            label.font = UIFont(name: "Montserrat-Light", size: 12)
            label.textAlignment = .left
            label.textColor = .white
            label.translatesAutoresizingMaskIntoConstraints = false
            label.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
            label.widthAnchor.constraint(equalToConstant: labelWidth).isActive = true
            label.heightAnchor.constraint(equalToConstant: labelHeight).isActive = true
        }
        label1.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: self.frame.width * 0.1 + labelWidth + 7).isActive = true
        label2.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: labelWidth).isActive = true
        label3.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: self.frame.width * 0.9 + labelWidth + 5).isActive = true
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
