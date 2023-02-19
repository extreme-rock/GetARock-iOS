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
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    private func attribute() {
        self.view.backgroundColor = .dark01
    }
    
    private func customizeBackButton() {
        let backButton = UIButton(type: .system)
        backButton.setImage(ImageLiteral.chevronLeftSymbol, for: .normal)
        backButton.tintColor = .white
        backButton.addTarget(self, action: #selector(dudBackButtonTapped), for: .touchUpInside)
        let backButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = backButtonItem
    }
    
    @objc
    func dudBackButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
