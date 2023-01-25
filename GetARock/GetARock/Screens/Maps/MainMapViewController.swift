//
//  MainMapViewController.swift
//  GetARock
//
//  Created by Mijoo Kim on 2023/01/20.
//

import CoreLocation
import UIKit

import GoogleMaps

final class MainMapViewController: UIViewController {
    
    // MARK: - Property
    
    private var currentLocationLabel: UILabel = {
        $0.text = "포항시 남구 효자동"
        $0.textColor = .white
        $0.font = UIFont.setFont(.largeTitle02)
        return $0
    }(UILabel())
    
    private lazy var bottomButtonStackView: UIStackView = {
        $0.axis = .horizontal
        return $0
    }(UIStackView(arrangedSubviews: [createEventsButton, myBandsButton, myPageButton]))
    
    private lazy var topButtonStackView: UIStackView = {
        $0.axis = .vertical
        return $0
    }(UIStackView(arrangedSubviews: [notificationButton, settingButton, moveToCurrentLocationButton]))
    
    private let createEventsButton: UIButton = {
        $0.setImage(UIImage(named: "createEventsButton"), for: .normal)
        return $0
    }(UIButton())
    
    private let myBandsButton: UIButton = {
        $0.setImage(UIImage(named: "myBandsButton"), for: .normal)
        return $0
    }(UIButton())
    
    private let myPageButton: UIButton = {
        $0.setImage(UIImage(named: "myPageButton"), for: .normal)
        return $0
    }(UIButton())
    
    private let notificationButton: UIButton = {
        $0.setImage(UIImage(named: "notificationButton"), for: .normal)
        return $0
    }(UIButton())
    
    private let settingButton: UIButton = {
        $0.setImage(UIImage(named: "settingButton"), for: .normal)
        return $0
    }(UIButton())
    
    private let moveToCurrentLocationButton: UIButton = {
        $0.setImage(UIImage(named: "currentLocationButton"), for: .normal)
        return $0
    }(UIButton())
    
    private var mapView: GMSMapView!
    private var myLocationMarker = GMSMarker()
    private lazy var camera = GMSCameraPosition.camera(withLatitude: currentCoordinate.latitude,
                                                       longitude: currentCoordinate.longitude,
                                                       zoom: zoomInRange)
    
    private var locationManager = CLLocationManager()
    private var currentCoordinate = CLLocationCoordinate2D(latitude: 36.014, longitude: 129.32)
    private let zoomInRange: Float = 15
    
    // MARK: - Life Cycle
    
    override func loadView() {
        let mapID = GMSMapID(identifier: Bundle.main.gmsMapID)
        
        myLocationMarker.position = CLLocationCoordinate2D(latitude: currentCoordinate.latitude,
                                                   longitude: currentCoordinate.longitude)
        myLocationMarker.icon = UIImage(named: "myLocationMarker")
        myLocationMarker.map = mapView
        
        mapView = GMSMapView(frame: .zero, mapID: mapID, camera: camera)
        self.view = mapView
        mapView.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupLayout()
        self.attribute()
        self.setLocationManager()
    }
    
    // MARK: - Method
    
    private func attribute() {
        self.setMarkers()
    }
    
    private func setupLayout() {
        self.view.addSubview(self.currentLocationLabel)
        self.currentLocationLabel.constraint(
            top: self.view.safeAreaLayoutGuide.topAnchor,
            leading: self.view.leadingAnchor,
            padding: UIEdgeInsets(top: 26, left: 25, bottom: 0, right: 0)
        )
        
        self.view.addSubview(self.bottomButtonStackView)
        self.bottomButtonStackView.constraint(
            bottom: self.view.bottomAnchor,
            centerX: self.view.centerXAnchor,
            padding: UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        )
        
        self.view.addSubview(self.topButtonStackView)
        self.topButtonStackView.constraint(
            top: self.view.safeAreaLayoutGuide.topAnchor,
            trailing: self.view.trailingAnchor,
            padding: UIEdgeInsets(top: 26, left: 0, bottom: 0, right: 25)
        )
        
    }
    
    private func setLocationManager() {
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
    }
    
    private func setMarkers() {
        myLocationMarker.icon = UIImage(named: "myLocationMarker")
    }
    
    private func moveLocation(to coordinate: CLLocationCoordinate2D?) {
        guard let coordinate else { return }
        self.currentCoordinate = coordinate
        camera = GMSCameraPosition.camera(withLatitude: currentCoordinate.latitude,
                                          longitude: currentCoordinate.longitude,
                                          zoom: zoomInRange)
        mapView.camera = camera
        myLocationMarker.position = CLLocationCoordinate2D(latitude: currentCoordinate.latitude,
                                                           longitude: currentCoordinate.longitude)
        myLocationMarker.map = mapView
    }
    
}

// MARK: - GMSMapViewDelegate

extension MainMapViewController: GMSMapViewDelegate {
    
}

// MARK: - CLLocationManagerDelegate

extension MainMapViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            manager.startUpdatingLocation()
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        default:
            print("위치 서비스를 허용하지 않음")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.first else { return }
        moveLocation(to: currentLocation.coordinate)
        
        CLGeocoder().reverseGeocodeLocation(
            currentLocation,
            completionHandler: { placemarks, _ in
                guard let currentPlacemark = placemarks?.first else { return }
                var address: String = ""
                if let city = currentPlacemark.locality {
                    address += city
                }
                if let street = currentPlacemark.thoroughfare {
                    address += " \(street)"
                }
                self.currentLocationLabel.text = address
            }
        )
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
