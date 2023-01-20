//
//  MainMapViewController.swift
//  GetARock
//
//  Created by Mijoo Kim on 2023/01/20.
//

import UIKit

import GoogleMaps

final class MainMapViewController: UIViewController {
    
    // MARK: - Property
    
    private var mapView: GMSMapView!
    
    private let bottomButtonStackView: UIStackView = {
        $0.alignment = .center
        $0.axis = .horizontal
        return $0
    }(UIStackView())
    
    private let createEventsButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setImage(UIImage(named: "createEventsButton"), for: .normal)
        return $0
    }(UIButton())
    
    private let myBandsButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setImage(UIImage(named: "myBandsButton"), for: .normal)
        return $0
    }(UIButton())
    
    private let myPageButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setImage(UIImage(named: "myPageButton"), for: .normal)
        return $0
    }(UIButton())
    
    // MARK: - Life Cycle
    
    override func loadView() {
        let camera: GMSCameraPosition = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 11)
        let mapID = GMSMapID(identifier: Bundle.main.gmsMapID)
        
        mapView = GMSMapView(frame: .zero, mapID: mapID, camera: camera)
        self.view = mapView
        mapView.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupLayout()
    }
    
    // MARK: - Method
    
    private func setupLayout() {
        self.view.addSubview(self.bottomButtonStackView)
        self.bottomButtonStackView.constraint(
            bottom: self.view.bottomAnchor,
            centerX: self.view.centerXAnchor,
            padding: UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        )
        
        bottomButtonStackView.addArrangedSubview(self.createEventsButton)
        bottomButtonStackView.addArrangedSubview(self.myBandsButton)
        bottomButtonStackView.addArrangedSubview(self.myPageButton)
    }
    
}

// MARK: - GMSMapViewDelegate

extension MainMapViewController: GMSMapViewDelegate {
    
}
