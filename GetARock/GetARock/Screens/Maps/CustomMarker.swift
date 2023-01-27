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
    
    private var bandName: String!
    private var coordinate: CLLocationCoordinate2D!
    var category: MarkerCategory!
    
    private var label: UILabel!
    private var markerImage: UIImageView!
    
    private lazy var stackView: UIStackView = {
        $0.axis = .vertical
        $0.alignment = .center
        $0.spacing = 3
        return $0
    }(UIStackView(arrangedSubviews: [markerImage, label]))
    
    // MARK: - Init
    
    init(bandName: String, coordinate: CLLocationCoordinate2D, category: MarkerCategory) {
        super.init()
        
        self.bandName = bandName
        self.coordinate = coordinate
        self.category = category

        label = UILabel()
        label.text = bandName
        label.textColor = .blue03
        label.font = .setFont(.caption)
        
        markerImage = UIImageView(image: self.category.image)

        attribute()
        setupLayout()
    }
    
    // MARK: - Method
    
    private func attribute() {
        self.position = coordinate
    }
    
    private func setupLayout() {
        self.iconView?.addSubview(stackView)
        self.stackView.constraint(
            centerX: self.iconView?.centerXAnchor,
            centerY: self.iconView?.centerYAnchor
        )
        
        self.iconView = stackView
    }
    
    func changeBandMarkerImageWhenSelected() {
        markerImage.image = UIImage(named: "selectedBandMarker")
    }
    
    func changeBandMarkerImageWhenDeselected() {
        markerImage.image = UIImage(named: "bandMarker")
    }
}
