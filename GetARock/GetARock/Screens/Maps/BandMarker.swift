//
//  BandMarker.swift
//  GetARock
//
//  Created by Mijoo Kim on 2023/01/26.
//

import UIKit

import GoogleMaps

final class BandMarker: GMSMarker {
    
    // MARK: - View
    
    private var label: UILabel!
    private let markerImage = UIImageView(image: UIImage(named: "bandMarker"))
    
    private lazy var stackView: UIStackView = {
        $0.axis = .vertical
        $0.alignment = .center
        $0.spacing = 3
        return $0
    }(UIStackView(arrangedSubviews: [markerImage, label]))
    
    // MARK: - Init
    
    init(labelText: String) {
        super.init()
        
        label = UILabel()
        label.text = labelText

        self.setupLayout()
        self.attribute()
    }
    
    // MARK: - Method
    
    func attribute() {
        label.textColor = .blue03
        label.font = .setFont(.caption)
    }
    
    func setupLayout() {
        self.iconView?.addSubview(stackView)
        self.stackView.constraint(
            centerX: self.iconView?.centerXAnchor,
            centerY: self.iconView?.centerYAnchor
        )
        
        self.iconView = stackView
    }
}
