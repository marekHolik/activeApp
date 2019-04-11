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
        self.font = UIFont(name: "Montserrat-Regular", size: 17)
        
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

extension ActivityLabel {
    private struct AssociatedKeys {
        static var padding = UIEdgeInsets()
    }
    
    public var padding: UIEdgeInsets? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.padding) as? UIEdgeInsets
        }
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(self, &AssociatedKeys.padding, newValue as UIEdgeInsets?, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
    
    override open func draw(_ rect: CGRect) {
        if let insets = padding {
            self.drawText(in: rect.inset(by: insets))
        } else {
            self.drawText(in: rect)
        }
    }
    
    override open var intrinsicContentSize: CGSize {
        guard let text = self.text else { return super.intrinsicContentSize }
        
        var contentSize = super.intrinsicContentSize
        var textWidth: CGFloat = frame.size.width
        var insetsHeight: CGFloat = 0.0
        var insetsWidth: CGFloat = 0.0
        
        if let insets = padding {
            insetsWidth += insets.left + insets.right
            insetsHeight += insets.top + insets.bottom
            textWidth -= insetsWidth
        }
        
        let newSize = text.boundingRect(with: CGSize(width: textWidth, height: CGFloat.greatestFiniteMagnitude),
                                        options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                        attributes: [NSAttributedString.Key.font: self.font], context: nil)
        
        contentSize.height = ceil(newSize.size.height) + insetsHeight
        contentSize.width = ceil(newSize.size.width) + insetsWidth
        
        return contentSize
    }
}
