//
//  UIViewController+Extension.swift
//  GetARock
//
//  Created by Jisu Jang on 2023/02/20.
//
import UIKit

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func customizeBackButton() {
        let backButton = UIButton(type: .system)
        backButton.setImage(ImageLiteral.chevronLeftSymbol, for: .normal)
        backButton.tintColor = .white
        backButton.addTarget(self, action: #selector(didBackButtonTapped), for: .touchUpInside)
        let backButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = backButtonItem
    }
    
    @objc
    func didBackButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    func fixNavigationBarColorWhenScrollDown(fixingColor: UIColor = .dark01) {
        guard let navigationBar = navigationController?.navigationBar else { return }
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = fixingColor
        appearance.shadowColor = .clear
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = navigationBar.standardAppearance
    }
    
    func setNavigationInlineTitle(title: String, color: UIColor = .white) {
        self.navigationItem.title = title
        guard let navigationBar = navigationController?.navigationBar else { return }
        navigationBar.standardAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor : color]
        navigationBar.scrollEdgeAppearance?.titleTextAttributes = [NSAttributedString.Key.foregroundColor : color]
    }
}

