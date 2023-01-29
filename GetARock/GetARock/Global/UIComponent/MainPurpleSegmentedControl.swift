//
//  MainPurpleSegmentedControl.swift
//  GetARock
//
//  Created by 최동권 on 2023/01/29.
//

import UIKit

protocol MainPurpleSegmentedControlDelegate: AnyObject {
    func segmentValueChanged(to index: Int)
}

final class MainPurpleSegmentedControl: UIView {
    
    // MARK: - Property
    
    weak var delegate: MainPurpleSegmentedControlDelegate?
    private var buttonTitles = [String]()
    private var buttons = [UIButton]()
    private let textColor: UIColor = .white
    private let selectedColor: UIColor = .mainPurple
    
    // MARK: - View
    
    private lazy var selectorView: UIView = {
        $0.backgroundColor = selectedColor
        
        let selectorWidth = frame.width / CGFloat(self.buttonTitles.count)
        $0.frame = CGRect(x: 0, y: self.frame.height - 3, width: selectorWidth, height: 3)
        return $0
    }(UIView())
    
    private let staticLineView: UIView = {
        $0.backgroundColor = .dark03
        return $0
    }(UIView())
    
    private lazy var buttonStackView: UIStackView = {
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.distribution = .fillEqually
        $0.backgroundColor = .clear
        return $0
    }(UIStackView(arrangedSubviews: buttons))
    
    init(buttonTitles: [String]) {
        super.init(frame: .zero)
        self.buttonTitles = buttonTitles
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        updateView()
    }
    
    // MARK: - Method
    
    private func updateView() {
        setupButtons()
        setupLayout()
    }
    
    private func setupButtons() {
        for buttonTitle in buttonTitles {
            let button = UIButton()
            button.setTitle(buttonTitle, for: .normal)
            button.setTitleColor(textColor, for: .normal)
            button.titleLabel?.font = .setFont(.content)
            button.titleLabel?.textAlignment = .center
            button.titleLabel?.constraint(.heightAnchor, constant: self.bounds.height)
            button.titleLabel?.constraint(.widthAnchor, constant: self.bounds.width / 3)
            
            button.addTarget(
                self,
                action: #selector(buttonAction(_:)),
                for: .touchUpInside)
            buttons.append(button)
        }
        buttons[0].setTitleColor(selectedColor, for: .normal)
        buttons[0].titleLabel?.font = .setFont(.contentBold)
    }
    
    private func setupLayout() {
        addSubview(buttonStackView)
        buttonStackView.constraint(to: self)
        
        addSubview(selectorView)
        
        addSubview(staticLineView)
        staticLineView.constraint(top: self.bottomAnchor,
                                  leading: self.leadingAnchor,
                                  trailing: self.trailingAnchor,
                                  centerX: self.centerXAnchor)
        staticLineView.constraint(.heightAnchor, constant: 1)
    }
    
    @objc
    func buttonAction(_ sender: UIButton) {
        for (buttonIndex, button) in buttons.enumerated() {
            button.setTitleColor(textColor, for: .normal)
            button.titleLabel?.font = .setFont(.content)
            
            if button == sender {
                delegate?.segmentValueChanged(to: buttonIndex)
                let selectorPosition = frame.width / CGFloat(buttonTitles.count) * CGFloat(buttonIndex)
                UIView.animate(withDuration: 0.2) {
                    self.selectorView.frame.origin.x = selectorPosition
                }
                button.setTitleColor(selectedColor, for: .normal)
                button.titleLabel?.font = .setFont(.contentBold)
            }
        }
    }
}

final class UnderlineSegmentedControl: UISegmentedControl {
    
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
        let image = UIImage()
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
