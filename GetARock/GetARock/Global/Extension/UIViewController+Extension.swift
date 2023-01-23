//
//  UIViewController+Extension.swift
//  GetARock
//
//  Created by 장지수 on 2023/01/23.
//

import UIKit

extension UIViewController {
    func hidekeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        print("함수 작동")
        view.endEditing(true)
    }
}
