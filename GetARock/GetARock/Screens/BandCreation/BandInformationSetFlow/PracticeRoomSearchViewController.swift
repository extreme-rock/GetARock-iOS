//
//  MapSearchViewController.swift
//  GetARock
//
//  Created by 장지수 on 2023/02/26.
//

import CoreLocation
import MapKit
import UIKit

final class PracticeRoomSearchViewController: BaseViewController {

    // MARK: Property

    var completion: (_ locationInfo: String) -> Void = { locationInfo in }

    private let locationManager: CLLocationManager = CLLocationManager()

    private var searchCompleter: MKLocalSearchCompleter = MKLocalSearchCompleter()

    private var searchResults: [LocationInfo] = []

    // MARK: View

    private lazy var searchBar: SearchTextField = {
        $0.textField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        return $0
    }(SearchTextField(placeholder: "합주실 주소 검색"))

    private lazy var searchResultTable: UITableView = {
        $0.delegate = self
        $0.dataSource = self
        $0.backgroundColor = .dark01
        $0.separatorStyle = .none
        $0.register(PracticeRoomSearchTableViewCell.self,
                    forCellReuseIdentifier: PracticeRoomSearchTableViewCell.classIdentifier)
        return $0
    }(UITableView())

    private lazy var currentLocationButton: DefaultButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.image = ImageLiteral.scopeSymbol
        configuration.title = "현재 위치"
        configuration.attributedTitle?.font = UIFont.setFont(.contentBold)
        configuration.imagePadding = 5

        let button = DefaultButton(configuration: configuration)
        button.tintColor = .white
        button.constraint(.widthAnchor, constant: 118)
        button.constraint(.heightAnchor, constant: 45)
        button.addTarget(self, action: #selector(didTapCurrentLocationButton), for: .touchUpInside)
        return button
    }()

    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        attribute()
        setSearchCompleter()
        setLocationManager()
    }

    // MARK: Method

    private func attribute() {
        self.view.backgroundColor = .dark01
        self.searchBar.textField.becomeFirstResponder()
    }

    private func setupLayout() {

        view.addSubview(searchBar)
        searchBar.constraint(top: view.safeAreaLayoutGuide.topAnchor,
                             leading: view.leadingAnchor,
                             trailing: view.trailingAnchor,
                             padding: UIEdgeInsets(top: 20, left: 16, bottom: 0, right: 16))

        view.addSubview(currentLocationButton)
        currentLocationButton.constraint(top: searchBar.bottomAnchor,
                                         leading: searchBar.leadingAnchor,
                                         padding: UIEdgeInsets(top: 19, left: 5, bottom: 0, right: 0))

        view.addSubview(searchResultTable)
        searchResultTable.constraint(top: currentLocationButton.bottomAnchor,
                                     leading: view.leadingAnchor,
                                     bottom: view.bottomAnchor,
                                     trailing: view.trailingAnchor,
                                     padding: UIEdgeInsets(top: 20, left: 16, bottom: 10, right: 16))
    }

    private func setSearchCompleter() {
        searchCompleter.delegate = self
        searchCompleter.resultTypes = .query
    }

    private func setLocationManager() {
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
}

extension PracticeRoomSearchViewController {
    @objc func textFieldDidChange(_ sender: Any?) {
        if searchBar.textField.text == "" {
            searchResults.removeAll()
            searchResultTable.reloadData()
        }
        // 사용자가 search bar 에 입력한 text를 자동완성 대상에 넣는다
        searchCompleter.queryFragment = searchBar.textField.text ?? ""
    }
}

// MARK: CLLocationManager delegate
extension PracticeRoomSearchViewController: CLLocationManagerDelegate {
    // 위치 정보 권한 설정에 관계된 함수
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

    // 현재 위치를 좌표로 받고, 그 좌표를 이용해서 주소를 찾아 텍스트 필드에 업로드하는 함수
    func getCurrentAddressInfo() {
        guard let userLocation = locationManager.location else { return }
        let location = CLLocation(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in

            guard let placemark = placemarks?.first else { return }

            var address = ""

            if let administrativeArea = placemark.administrativeArea {
                address = administrativeArea //ex.서울특별시
            }
            if let locality = placemark.locality {
                address += " "+locality //ex.광진구
            }
            if let thoroughfare = placemark.thoroughfare {
                address += " "+thoroughfare //ex.중곡동
            }
            if let subThoroughfare = placemark.subThoroughfare {
                address += " "+subThoroughfare //ex.272-13
            }
            self.searchBar.textField.text = address
            self.searchCompleter.queryFragment = address
        }
    }
}

// MARK: SearchCompleter delegate
extension PracticeRoomSearchViewController: MKLocalSearchCompleterDelegate {
    // 자동완성 완료시 결과를 받는 함수
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        let locationInfoList: [LocationInfo] = completer.results.map { LocationInfo(title: $0.title, subtitle: $0.subtitle) }
        searchResults = locationInfoList

        searchResultTable.reloadData()
    }

    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print(error)
    }
}

// MARK: TableView datasource
extension PracticeRoomSearchViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PracticeRoomSearchTableViewCell.classIdentifier,
                                                       for: indexPath) as? PracticeRoomSearchTableViewCell else { return UITableViewCell() }
        let searchResult = searchResults[indexPath.row]
        cell.configure(mapSearchResult: searchResult)
        cell.selectionStyle = .none
        return cell
    }
}

// MARK: TableView delegate
extension PracticeRoomSearchViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedResult = searchResults[indexPath.row]
        if selectedResult.subtitle.isEmpty {
            completion(selectedResult.title)
        } else {
            completion(selectedResult.subtitle)
        }
        self.navigationController?.popViewController(animated: true)
    }
}

extension PracticeRoomSearchViewController {
    @objc func didTapCurrentLocationButton() {
        self.locationManager.requestWhenInUseAuthorization()
        self.getCurrentAddressInfo()
    }
}

//MARK: 위치 검색 결과에서 title과 subtitle을 처리하기위한 데이터 모델
struct LocationInfo {
    let title: String
    let subtitle: String
}

