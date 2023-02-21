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
        hideKeyboardWhenTappedAround()
    }
    
    private func attribute() {
        self.view.backgroundColor = .dark01
    }
}
