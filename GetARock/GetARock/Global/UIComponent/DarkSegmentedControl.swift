//
//  CustomSegmentedControl.swift
//  GetARock
//
//  Created by 최동권 on 2023/01/29.
//

import UIKit

final class DarkSegmentedControl: UISegmentedControl {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        
        let selectedImageViewIndex = numberOfSegments
        if let selecImageView = subviews[selectedImageViewIndex] as? UIImageView {
            selecImageView.bounds = selecImageView.bounds.insetBy(dx: 5, dy: 5)
            selecImageView.layer.masksToBounds = true
            selecImageView.layer.cornerRadius = 10
            selecImageView.layer.removeAnimation(forKey: "SelectionBounds")
        }
    }
    
    override init(items: [Any]?) {
        super.init(items: items)
        self.selectedSegmentIndex = 0
        self.addTarget(self, action: #selector(valueChagend(_:)), for: .valueChanged)
        self.selectedSegmentTintColor = .dark04
        self.backgroundColor = .dark03
        self.selectedSegmentIndex = 0
        let selectedTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white,
                                   NSAttributedString.Key.font: UIFont.setFont(.headline02)]
        let normalTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white,
                                    NSAttributedString.Key.font: UIFont.setFont(.headline04)]
        
        self.setTitleTextAttributes(selectedTitleTextAttributes, for: .selected)
        self.setTitleTextAttributes(normalTitleTextAttributes, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    func valueChagend(_ sender: UISegmentedControl) -> Int {
        return sender.selectedSegmentIndex
    }
}
