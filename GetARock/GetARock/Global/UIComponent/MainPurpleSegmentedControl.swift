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
    
    // MARK: - Properties
    
    weak var delegate: MainPurpleSegmentedControlDelegate?
    private var buttonTitles = [String]()
    private var buttons = [UIButton]()
    private let textColor: UIColor = .white
    private let selectedColor: UIColor = .mainPurple
    
    // MARK: - View
    
    private lazy var selectorView: UIView = {
        $0.backgroundColor = selectedColor
        
        let selectorWidth = frame.width / CGFloat(self.buttonTitles.count)
        $0.frame = CGRect(x: 0, y: self.frame.height, width: selectorWidth, height: 3)
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
    
    private func setupButtons() {
        for buttonTitle in buttonTitles {
            let button = UIButton()
            button.setTitle(buttonTitle, for: .normal)
            button.setTitleColor(textColor, for: .normal)
            button.titleLabel?.font = .setFont(.content)
            button.addTarget(
                self,
                action: #selector(buttonAction(_:)),
                for: .touchUpInside)
            buttons.append(button)
        }
        buttons[0].setTitleColor(selectedColor, for: .normal)
        buttons[0].titleLabel?.font = .setFont(.contentBold)
    }
    
    @objc func buttonAction(_ sender: UIButton) {
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
