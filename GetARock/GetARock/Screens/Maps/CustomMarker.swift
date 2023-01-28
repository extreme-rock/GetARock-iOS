//
//  CustomMarker.swift
//  GetARock
//
//  Created by Mijoo Kim on 2023/01/26.
//

import UIKit

import GoogleMaps

final class CustomMarker: GMSMarker {

    enum MarkerCategory {
        case band
        case event
        
        var image: UIImage {
            switch self {
            case .band:
                return UIImage(named: "bandMarker") ?? UIImage()
            case .event:
                return UIImage(named: "eventMarker") ?? UIImage()
            }
        }
    }
    
    private var bandName: String
    private var coordinate: CLLocationCoordinate2D
    var category: MarkerCategory
    
    private var label: UILabel = {
        $0.textColor = .blue03
        $0.font = .setFont(.caption)
        return $0
    }(UILabel())
    
    private var markerImageView: UIImageView = {
        return $0
    }(UIImageView())
    
    private lazy var stackView: UIStackView = {
        $0.axis = .vertical
        $0.alignment = .center
        $0.spacing = 3
        return $0
    }(UIStackView(arrangedSubviews: [markerImageView, label]))
    
    // MARK: - Init
    
    init(bandName: String, coordinate: CLLocationCoordinate2D, category: MarkerCategory) {
        self.bandName = bandName
        self.coordinate = coordinate
        self.category = category

        super.init()
        
        label.text = bandName
        markerImageView.image = category.image
        
        setupLayout()
        attribute()
    }
    
    // MARK: - Method
    
    private func attribute() {
        self.position = coordinate
        self.iconView = stackView
    }
    
    private func setupLayout() {
        self.iconView?.addSubview(stackView)
        self.stackView.constraint(
            centerX: self.iconView?.centerXAnchor,
            centerY: self.iconView?.centerYAnchor
        )
    }
    
    func changeBandMarkerImageWhenSelected() {
        markerImageView.image = UIImage(named: "selectedBandMarker")
    }
    
    func changeBandMarkerImageWhenDeselected() {
        markerImageView.image = UIImage(named: "bandMarker")
    }
}
