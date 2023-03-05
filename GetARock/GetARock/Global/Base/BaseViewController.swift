//
//  BaseViewController.swift
//  GetARock
//
//  Created by Mijoo Kim on 2023/01/18.
//

import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        attribute()
        customizeBackButton()
        fixNavigationBarColorWhenScrollDown()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        hideKeyboardWhenTappedAround()
    }
    
    private func attribute() {
        self.view.backgroundColor = .dark01
    }
}
