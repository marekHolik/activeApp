//
//  ViewControllerExt.swift
//  activeApp
//
//  Created by marek holik on 01/07/2019.
//  Copyright © 2019 marek holik. All rights reserved.
//

import UIKit

extension UIViewController {
    func createAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

