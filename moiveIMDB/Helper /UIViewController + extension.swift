//
//  UIViewController + extension.swift
//  moiveIMDB
//
//  Created by manukant tyagi on 30/11/24.
//

import Foundation
import UIKit

extension UIViewController {
        func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
