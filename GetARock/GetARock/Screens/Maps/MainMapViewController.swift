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
    private var markers = MapMarkerVO(bandList: [], eventList: [])
    
    private var minLatitude: Double = 0.0
    private var maxLatitude: Double = 0.0
    private var minLongitude: Double = 0.0
    private var maxLongitude: Double = 0.0
    
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
    
    private lazy var myPageButton: UIButton = {
        $0.setImage(UIImage(named: "myPageButton"), for: .normal)
        let action = UIAction { [weak self] _ in
            let viewController = UINavigationController(rootViewController: MypageDetailViewController(userID: UserDefaultStorage.memberID))
            self?.present(viewController, animated: true)
        }
        $0.addAction(action, for: .touchUpInside)
        return $0
    }(UIButton())
    
    private lazy var notificationButton: UIButton = {
        $0.setImage(UIImage(named: "notificationButton"), for: .normal)
        let action = UIAction { [weak self] _ in
            let viewController = NotificationListViewController()
            self?.navigationController?.pushViewController(viewController, animated: true)
        }
        $0.addAction(action, for: .touchUpInside)
        return $0
    }(UIButton())
    
    private lazy var settingButton: UIButton = {
        $0.setImage(UIImage(named: "settingButton"), for: .normal)
        let action = UIAction { [weak self] _ in
            let viewController = SettingViewController()
            self?.navigationController?.pushViewController(viewController, animated: true)
        }
        $0.addAction(action, for: .touchUpInside)
        return $0
    }(UIButton())
    
    private let moveToCurrentLocationButton: UIButton = {
        $0.setImage(UIImage(named: "currentLocationButton"), for: .normal)
        return $0
    }(UIButton())
    
    private lazy var deleteBandNoticeView: DeleteBandNoticeView = {
        $0.delegate = self
        return $0
    }(DeleteBandNoticeView())
    
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
        self.setLocationManager()
        self.requestLocationAuthorization()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        moveMap(to: currentCoordinate)
    }
    
    // MARK: - Method

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
    
    func setupLayoutDeleteBandNoticeView() {
        self.view.addSubview(deleteBandNoticeView)
        deleteBandNoticeView.constraint(leading: self.view.leadingAnchor,
                        trailing: self.view.trailingAnchor,
                        centerY: self.view.centerYAnchor,
                        padding: UIEdgeInsets(top: 0, left: 22, bottom: 0, right: 22))
        deleteBandNoticeView.constraint(.heightAnchor, constant: 321)
    }
    
    private func setupAlertViewLayout() {
        self.view.addSubview(alertView)
        alertView.constraint(to: self.view)
    }
    
    private func setLocationManager() {
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
    }
    
    private func setMarkers() {
        myLocationMarker.icon = UIImage(named: "myLocationMarker")
        Task {
            await fetchMarkers()
            mapView.clear()
            for band in markers.bandList {
                let marker = CustomMarker(bandName: band.name,
                                          coordinate: band.toCLLocationCoordinate2D(),
                                          category: .band)
                marker.map = mapView
            }
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
        
        let selectedMarker = marker as? CustomMarker
        if selectedMarker?.category == .band {
            selectedMarker?.changeBandMarkerImageWhenSelected()
        }
        moveMap(to: selectedMarker?.position)
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
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        // 현재 보이는 지도의 경계를 구하기 위해 GMSVisibleRegion 객체를 가져옵니다.
        let visibleRegion = mapView.projection.visibleRegion()
        
        // 경계를 구하기 위해 최소, 최대 위도와 경도를 가져옵니다.
        let bounds = GMSCoordinateBounds(coordinate: visibleRegion.farLeft, coordinate: visibleRegion.nearRight)
        
        // 최소 위도와 최대 위도를 가져옵니다.
        let updatedMinLatitude = bounds.southWest.latitude
        let updatedMaxLatitude = bounds.northEast.latitude
        
        // 최소 경도와 최대 경도를 가져옵니다.
        let updatedMinLongitude = bounds.southWest.longitude
        let updatedMaxLongitude = bounds.northEast.longitude
        
        // 현재 보이는 지도의 경계가 기존의 경계를 벗어나는 경우 새롭게 마커를 로드합니다.
        if (updatedMinLatitude < minLatitude) || (updatedMinLongitude < minLongitude) || (updatedMaxLatitude > maxLatitude) || (updatedMaxLongitude > maxLongitude) {
            setMarkers()
        }
        
        // 최소 위도와 최대 위도를 저장합니다.
        minLatitude = bounds.southWest.latitude - 0.1
        maxLatitude = bounds.northEast.latitude + 0.3
        
        // 최소 경도와 최대 경도를 저장합니다.
        minLongitude = bounds.southWest.longitude - 0.1
        maxLongitude = bounds.northEast.longitude + 0.1
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
        Task {
            let memberID = UserDefaultStorage.memberID
            guard let user = await UserInfoNetworkManager.shared.fetchUserData(with: memberID) else { return }
            if user.bandList.isEmpty {
                setupAlertViewLayout()
            } else {
                let bandList = user.bandList.map {
                    BandList(bandId: $0.bandID,
                             name: $0.name,
                             memberCount: $0.memberCount,
                             memberAge: $0.memberAge)
                }
                let viewController = UINavigationController(rootViewController: BandDetailViewController(myBands: bandList, entryPoint: .myBand)) 
                viewController.modalPresentationStyle = .pageSheet
                if let sheet = viewController.sheetPresentationController {
                    sheet.detents = [.medium(), .large()]
                    sheet.prefersGrabberVisible = true
                }
                present(viewController, animated: true, completion: nil)
            }
        }
    }
}

extension MainMapViewController {
    private func fetchMarkers() async {
        var queryURLComponent = URLComponents(string: "https://api.ryomyom.com/map")
        queryURLComponent?.queryItems = [
            URLQueryItem(name: "minLatitude", value: "\(minLatitude)"),
            URLQueryItem(name: "maxLatitude", value: "\(maxLatitude)"),
            URLQueryItem(name: "minLongitude", value: "\(minLongitude)"),
            URLQueryItem(name: "maxLongitude", value: "\(maxLongitude)")
        ]
        
        guard let url = queryURLComponent?.url else {
            print("An error has occurred while creating URL")
            return
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            let decodedData = try JSONDecoder().decode(MapMarkerVO.self, from: data)
            print(String(data: data, encoding: String.Encoding.utf8) ?? "no responce")
            print("응답 내용 : \(response)")
            self.markers = decodedData
        } catch {
            print("An error has occurred while decoding JSONObject: \(error.localizedDescription)")
        }
    }
}

//MARK: DeleteBandNoticeViewDelegate

extension MainMapViewController: DeleteBandNoticeViewDelegate {
    func didOKButtonTapped() {
        self.deleteBandNoticeView.removeFromSuperview()
    }
}
