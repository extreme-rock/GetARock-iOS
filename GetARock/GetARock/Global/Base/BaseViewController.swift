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
    
    private func customizeBackButton() {
        let backButton = UIButton(type: .system)
        backButton.setImage(ImageLiteral.chevronLeftSymbol, for: .normal)
        backButton.tintColor = .white
        backButton.addTarget(self, action: #selector(didBackButtonTapped), for: .touchUpInside)
        let backButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = backButtonItem
    }
    
    private func fixNavigationBarColorWhenScrollDown() {
        guard let navigationBar = navigationController?.navigationBar else { return }
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .clear
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = navigationBar.standardAppearance
    }
    
    @objc
    func didBackButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
