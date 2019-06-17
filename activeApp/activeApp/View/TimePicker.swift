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
        addLabels(viewToRelate: view)
    }
    
    func addLabels(viewToRelate view: UIView) {
        let labels = ["hours", "min", "sec"]
        for index in 0..<(labels.count) {
            let labelWidth = self.bounds.size.width / CGFloat(labels.count)
            let label = UILabel(frame: CGRect(x: CGFloat(labelWidth / 2) + 20 + labelWidth * CGFloat(index), y: (self.frame.size.height / 2) - 10, width: labelWidth, height: 20))
            label.text = labels[index]
            label.font = UIFont(name: "Montserrat-Light", size: 18)
            label.textAlignment = .left
            label.textColor = .white
            self.addSubview(label)
        }
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
