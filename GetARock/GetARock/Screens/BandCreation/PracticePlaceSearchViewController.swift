//
//  MapSearchViewController.swift
//  GetARock
//
//  Created by 장지수 on 2023/02/26.
//

import CoreLocation
import MapKit
import UIKit

//MARK: 알로라 피알 참고하여 진행

final class PracticePlaceSearchViewController: UIViewController {
    var completion: (_ mapItem: MKMapItem) -> Void = { mapItem in }

    private let locationManager = CLLocationManager()
    
    private var searchCompleter = MKLocalSearchCompleter()
    
    private var searchResults = [MKLocalSearchCompletion]()
    
    private lazy var searchBar = {
        let searchBar = SearchTextField(placeholder: "합주실 주소 검색")
        searchBar.textField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        return searchBar
    }()
    
    private lazy var searchResultTable: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .dark01
        tableView.register(PracticePlaceSearchTableViewCell.self, forCellReuseIdentifier: PracticePlaceSearchTableViewCell.identifier)

        return tableView
    }()
    
    //MARK: Google Map으로 현재 위치 바꿔야함...
    //TODO: 밴드 멤버 추가 버튼 레이아웃 참고하여 바꾸기 
    private lazy var currentLocationButton = {
        let button = BasicButton(text: "현재 위치", widthPadding: 20, heightPadding: 10)
        button.setImage(UIImage(systemName: "scope"), for: .normal)
        button.backgroundColor = .systemPurple
        button.tintColor = . white
        button.layer.cornerRadius = 8
        
        let action = UIAction { _ in
            self.locationManager.requestWhenInUseAuthorization()
        }
        button.addAction(action, for: .touchUpInside)
        return button
    }()


    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .dark01
        self.addSubViews()
        self.configureConstraints()
        self.configureSearchCompleter()
        self.setLocationManager()
    }

    private func addSubViews() {
        view.addSubview(searchBar)
        view.addSubview(searchResultTable)
        view.addSubview(currentLocationButton)
    }

    private func configureConstraints() {
        searchBar.constraint(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 20, left: 25, bottom: 0, right: 25))
        
        currentLocationButton.constraint(top: searchBar.bottomAnchor, leading: searchBar.leadingAnchor, padding: UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0))
        
        searchResultTable.constraint(top: currentLocationButton.bottomAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 20, left: 25, bottom: 10, right: 25))
    }

    private func configureSearchCompleter() {
        self.searchCompleter.delegate = self
        self.searchCompleter.resultTypes = .query
    }
}

extension PracticePlaceSearchViewController {
    @objc func textFieldDidChange(_ sender: Any?) {
        if searchBar.textField.text == "" {
            searchResults.removeAll()
            searchResultTable.reloadData()
        }
      // 사용자가 search bar 에 입력한 text를 자동완성 대상에 넣는다
        searchCompleter.queryFragment = searchBar.textField.text ?? ""
        }
    
    private func setLocationManager() {
          self.locationManager.delegate = self
          self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
      }
}

extension PracticePlaceSearchViewController: CLLocationManagerDelegate {
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
        print("current location is this \(currentLocation)")
    }
}

extension PracticePlaceSearchViewController: MKLocalSearchCompleterDelegate {
  // 자동완성 완료시 결과를 받는 method
  func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        searchResultTable.reloadData()
    }
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        // 에러 처리
    }
}

extension PracticePlaceSearchViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PracticePlaceSearchTableViewCell.identifier, for: indexPath) as? PracticePlaceSearchTableViewCell else { return UITableViewCell()}

        let searchResult = searchResults[indexPath.row]
        cell.setUI(mapSearchResult: searchResult)

        return cell
    }
}

extension PracticePlaceSearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedResult = searchResults[indexPath.row]
        let searchRequest = MKLocalSearch.Request(completion: selectedResult)
        let search = MKLocalSearch(request: searchRequest)
        search.start { (response, error) in
            guard error == nil else { return }
            guard let mapItem = response?.mapItems.first else { return }
            self.dismiss(animated: true){
                print("함수 종료")
                self.completion(mapItem)
            }
        }
    }
}

extension PracticePlaceSearchViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        self.searchBar.searchTextField.becomeFirstResponder()
        self.searchBar.textField.becomeFirstResponder()
    }
}

//MARK: Merge 이후 삭제 예정
import UIKit

final class SearchTextField: UIView {

    var placeholder: String

    lazy var textField: UITextField = {
        let textField = UITextField.makeBasicTextField(placeholder: placeholder)
        textField.layer.borderWidth = 0
        return textField
    }()
    
    let searchImage = MagnifyGlassImageView(frame: .zero)

    init(placeholder: String) {
        self.placeholder = placeholder
        super.init(frame: .zero)
        setupLayout()
        attribute()
    }
    
    private func setupLayout() {
        self.constraint(.heightAnchor, constant: 55)

        self.addSubview(textField)
        self.addSubview(searchImage)
        textField.constraint(leading: self.leadingAnchor, trailing: self.trailingAnchor, centerY: self.centerYAnchor, padding: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0))
        
        searchImage.constraint(.widthAnchor, constant: 20)
        searchImage.constraint(.heightAnchor, constant: 20)
        searchImage.constraint(leading: self.leadingAnchor, centerY: self.centerYAnchor, padding: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0))
    }
    
    private func attribute() {
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 10
        self.layer.borderColor = UIColor.white.cgColor
        self.backgroundColor = .dark02
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MagnifyGlassImageView: UIImageView {
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        self.image = UIImage(systemName: "magnifyingglass")
        self.tintColor = .white
        self.contentMode = .scaleAspectFill
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: Merge 이후 삭제 예정

import UIKit

final class BasicButton : UIButton {
    
    var contentText: String
    var widthPadding: Double?
    var heightPadding: Double?
    
    init(text: String, widthPadding: Double? = nil, heightPadding: Double? = nil) {
        self.contentText = text
        if let widthPadding = widthPadding { self.widthPadding = widthPadding }
        if let heightPadding = heightPadding { self.heightPadding = heightPadding }
        super.init(frame: .zero)
        titleLabel?.font = UIFont.setFont(.contentBold)
        self.setTitle(contentText, for: .normal)
        backgroundColor = .systemPurple
        layer.cornerRadius = 10
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        get {
            let baseSize = super.intrinsicContentSize
            return CGSize(width: baseSize.width + (widthPadding ?? 0), height: baseSize.height + (heightPadding ?? 0))
        }
    }
}
