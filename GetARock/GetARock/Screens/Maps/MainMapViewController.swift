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
    
    private var isFromSignUp: Bool
    
    // MARK: - Property
    
    private lazy var camera = GMSCameraPosition.camera(withLatitude: currentCoordinate.latitude,
                                                       longitude: currentCoordinate.longitude,
                                                       zoom: zoomInRange)
    
    private var mapView: GMSMapView!
    private var myLocationMarker = GMSMarker()
    private var previousSelectedMarker: GMSMarker?
    private var locationManager = CLLocationManager()
    private var currentCoordinate = CLLocationCoordinate2D(latitude: 36.014, longitude: 129.32)


    private let zoomInRange: Float = 15
    
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
    
    private lazy var myBandsButton: UIButton = {
        $0.setImage(UIImage(named: "myBandsButton"), for: .normal)
        let action = UIAction { _ in
            self.mybandsButtonTapped()
        }
        $0.addAction(action, for: .touchUpInside)
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
    
    private lazy var alertView: GetARockInfoPopUpView = {
        $0.delegate = self
        return $0
    }(GetARockInfoPopUpView())
    
    // MARK: - Life Cycle
    
    init(isFromSignUp: Bool) {
        self.isFromSignUp = isFromSignUp
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        self.requestLocationAuthorization()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        moveMap(to: currentCoordinate)
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
    
    private func setupAlertViewLayout() {
        self.view.addSubview(alertView)
        alertView.constraint(leading: view.leadingAnchor,
                             trailing: view.trailingAnchor,
                             centerY: view.centerYAnchor,
        padding: UIEdgeInsets(top: 0, left: 22, bottom: 0, right: 22))
    }
    
    private func setLocationManager() {
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
    }
    
    private func setMarkers() {
        myLocationMarker.icon = UIImage(named: "myLocationMarker")
        
        for band in BandDummyData.testBands {
            let marker = CustomMarker(bandName: band.name,
                                      coordinate: band.location.coordinate.toCLLocationCoordinate2D(),
                                      category: .band)
            marker.map = mapView
        }
        for event in EventDummyData.testEvents {
            // TODO: 이벤트 이름 -> 밴드 이름으로 변경
            let marker = CustomMarker(bandName: event.name,
                                      coordinate: event.location.coordinate.toCLLocationCoordinate2D(),
                                      category: .event)
            marker.map = mapView
        }
    }
    
    private func moveMap(to coordinate: CLLocationCoordinate2D?) {
        guard let coordinate else { return }
        let camera = GMSCameraUpdate.setTarget(coordinate, zoom: zoomInRange)
        mapView.animate(with: camera)
    }
    
    private func moveMyLocationMarker(to coordinate: CLLocationCoordinate2D?) {
        guard let coordinate else { return }
        self.currentCoordinate = coordinate
        myLocationMarker.position = CLLocationCoordinate2D(latitude: currentCoordinate.latitude,
                                                           longitude: currentCoordinate.longitude)
        myLocationMarker.map = mapView
    }
    
}

// MARK: - GMSMapViewDelegate

extension MainMapViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        if self.previousSelectedMarker == marker {
            return true
        }
        
        if self.previousSelectedMarker != nil {
            let previousSelectedMarker = self.previousSelectedMarker as! CustomMarker
            if previousSelectedMarker.category == .band {
                previousSelectedMarker.changeBandMarkerImageWhenDeselected()
            }
        }

        let selectedMarker = marker as! CustomMarker
        if selectedMarker.category == .band {
            selectedMarker.changeBandMarkerImageWhenSelected()
        }
        moveMap(to: selectedMarker.position)
        self.previousSelectedMarker = selectedMarker
        
        return true
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        if self.previousSelectedMarker != nil {
            let previousSelectedMarker = self.previousSelectedMarker as! CustomMarker
            if previousSelectedMarker.category == .band {
                previousSelectedMarker.changeBandMarkerImageWhenDeselected()
            }
            self.previousSelectedMarker = nil
        }
    }
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
        // TODO: 첫방문일 때만 보여줘야함.
        if self.isFromSignUp {
            self.requestNotificationAutorization()
            self.isFromSignUp = false
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.first else { return }
        moveMyLocationMarker(to: currentLocation.coordinate)
        
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

extension MainMapViewController: GetARockInfoPopUpViewDelegate {
    func makeBandButtonTapped() {
        self.alertView.removeFromSuperview()
        let viewController = UINavigationController(rootViewController: LeaderPositionSelectViewController())
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: true)
    }
    
    func dismissButtonTapped() {
        print("dismiss")
        self.alertView.removeFromSuperview()
    }
}

// MARK: - 권한 관련 함수
extension MainMapViewController {
    private func requestLocationAuthorization() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .denied:
            self.showRequestLocationServiceAlert()
        default:
            return
        }
    }
    
    private func requestNotificationAutorization() {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound, .badge]) { isGranted, error in
                if isGranted {
                    //TODO: 동의 시 뷰 연결
                    DispatchQueue.main.async { [weak self] in
                        self?.setupAlertViewLayout()
                    }
                    print(isGranted)
                } else {
                    //TODO: 비동의 시 뷰 연결
                    DispatchQueue.main.async { [weak self] in
                        self?.setupAlertViewLayout()
                    }
                    print(isGranted)
                }
            }
    }
    
    func showRequestLocationServiceAlert() {
        let requestLocationServiceAlert = UIAlertController(title: "위치 정보 이용", message: "위치 서비스를 사용할 수 없습니다.\n'설정 > 개인정보 보호 및 보안'에서 위치 서비스를 켜주세요.", preferredStyle: .alert)
        let goSetting = UIAlertAction(title: "설정", style: .default) { _ in
            if let appSetting = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSetting)
            }
        }
        let cancel = UIAlertAction(title: "취소", style: .default) { [weak self] _ in
            self?.requestNotificationAutorization()
        }
        requestLocationServiceAlert.addAction(cancel)
        requestLocationServiceAlert.addAction(goSetting)
        
        present(requestLocationServiceAlert, animated: true)
    }
    
}

// MARK: 맵 버튼 관련 함수
extension MainMapViewController {
    private func mybandsButtonTapped() {
        // TODO: band가 없으면 alerview를 띄워줌 있으면 bandDetail로 연결
        setupAlertViewLayout()
        
    }
}
