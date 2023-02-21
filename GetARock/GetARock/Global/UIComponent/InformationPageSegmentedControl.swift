//
//  InformationPageSegmentedControlDelegate.swift
//  GetARock
//
//  Created by 최동권 on 2023/01/29.
//

import UIKit

final class InformationPageSegmentedControl: UISegmentedControl {
    
    // MARK: - View
    
    private lazy var underlineView: UIView = {
        let width = self.bounds.size.width / CGFloat(self.numberOfSegments)
        let height = 3.0
        let xPosition = CGFloat(self.selectedSegmentIndex * Int(width))
        let yPosition = self.bounds.size.height - 4.0
        let frame = CGRect(x: xPosition, y: yPosition, width: width, height: height)
        $0.frame = frame
        $0.backgroundColor = .mainPurple
        self.addSubview($0)
        return $0
    }(UIView())

    private let staticLineView: UIView = {
        $0.backgroundColor = .dark03
        return $0
    }(UIView())
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 0
        self.layer.masksToBounds = true
        
        let underlineFinalXPosition = (self.bounds.width / CGFloat(self.numberOfSegments)) * CGFloat(self.selectedSegmentIndex)
        UIView.animate(
            withDuration: 0.2,
            animations: {
                self.underlineView.frame.origin.x = underlineFinalXPosition
                self.underlineView.frame.size.height = 10
            }
        )
    }
    
    // MARK: - Init
    
    override init(items: [Any]?) {
        super.init(items: items)
        self.removeBackgroundAndDivider()
        self.attributeText()
        self.setupLayout()
        self.addTarget(self, action: #selector(valueChagend(_:)), for: .valueChanged)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Method
    
    private func setupLayout() {
        
        self.addSubview(staticLineView)
        staticLineView.constraint(top: self.bottomAnchor,
                                  leading: self.leadingAnchor,
                                  trailing: self.trailingAnchor,
                                  padding: UIEdgeInsets(top: -1, left: 0, bottom: 0, right: 0))
        staticLineView.constraint(.heightAnchor, constant: 1)
    }
    
    private func removeBackgroundAndDivider() {
        let image = UIColor.clear.toImage()
        self.selectedSegmentTintColor = .clear
        self.setBackgroundImage(image, for: .normal, barMetrics: .default)
        self.setDividerImage(image, forLeftSegmentState: .selected, rightSegmentState: .normal, barMetrics: .default)
    }
    
    private func attributeText() {
        self.setTitleTextAttributes(
            [
                NSAttributedString.Key.foregroundColor: UIColor.white,
                .font: UIFont.setFont(.content)
            ],
            for: .normal)
        self.setTitleTextAttributes(
            [
                NSAttributedString.Key.foregroundColor: UIColor.mainPurple,
                .font: UIFont.setFont(.contentBold)
            ],
            for: .selected
        )
        self.setTitleTextAttributes(
            [
                NSAttributedString.Key.foregroundColor: UIColor.white,
                .font: UIFont.setFont(.contentBold)
            ],
            for: .highlighted
        )
        self.selectedSegmentIndex = 0
    }
    
    @objc
    func valueChagend(_ sender: UISegmentedControl) -> Int {
        return sender.selectedSegmentIndex
    }
}
