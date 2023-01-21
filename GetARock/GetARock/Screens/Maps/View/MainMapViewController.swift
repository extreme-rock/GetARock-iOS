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
    
    private var currentLocationLabel: UILabel = {
        $0.text = "포항시 남구 효자동"
        $0.textColor = .white
        $0.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        return $0
    }(UILabel())
    
    private let bottomButtonStackView: UIStackView = {
        $0.axis = .horizontal
        return $0
    }(UIStackView())
    
    private let topButtonStackView: UIStackView = {
        $0.axis = .vertical
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
    
    private let notificationButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setImage(UIImage(named: "notificationButton"), for: .normal)
        return $0
    }(UIButton())
    
    private let settingButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setImage(UIImage(named: "settingButton"), for: .normal)
        return $0
    }(UIButton())
    
    private let currentLocationButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setImage(UIImage(named: "currentLocationButton"), for: .normal)
        return $0
    }(UIButton())
    
    // MARK: - Life Cycle
    
    override func loadView() {
        let camera: GMSCameraPosition = GMSCameraPosition.camera(withLatitude: -33.86,
                                                                 longitude: 151.20,
                                                                 zoom: 11)
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
        self.view.addSubview(self.currentLocationLabel)
        self.currentLocationLabel.constraint(
            top: self.view.safeAreaLayoutGuide.topAnchor,
            leading: self.view.leadingAnchor,
            padding: UIEdgeInsets(top: 26, left: 26, bottom: 0, right: 0)
        )
        
        self.view.addSubview(self.bottomButtonStackView)
        self.bottomButtonStackView.constraint(
            bottom: self.view.bottomAnchor,
            centerX: self.view.centerXAnchor,
            padding: UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        )
        
        bottomButtonStackView.addArrangedSubview(self.createEventsButton)
        bottomButtonStackView.addArrangedSubview(self.myBandsButton)
        bottomButtonStackView.addArrangedSubview(self.myPageButton)
        
        self.view.addSubview(self.topButtonStackView)
        self.topButtonStackView.constraint(
            top: self.view.safeAreaLayoutGuide.topAnchor,
            trailing: self.view.trailingAnchor,
            padding: UIEdgeInsets(top: 26, left: 0, bottom: 0, right: 26)
        )
        
        topButtonStackView.addArrangedSubview(self.notificationButton)
        topButtonStackView.addArrangedSubview(self.settingButton)
        topButtonStackView.addArrangedSubview(self.currentLocationButton)
    }
    
}

// MARK: - GMSMapViewDelegate

extension MainMapViewController: GMSMapViewDelegate {
    
}
