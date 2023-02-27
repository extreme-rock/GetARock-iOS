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

final class PracticePlaceSearchViewController: BaseViewController {
    
    var completion: (_ mapItem: MKMapItem) -> Void = { mapItem in }

    private let locationManager = CLLocationManager()
    
    private var searchCompleter = MKLocalSearchCompleter()
    
    private var searchResults = [MKLocalSearchCompletion]()
    
    private lazy var searchBar: SearchTextField = {
        $0.textField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        return $0
    }(SearchTextField(placeholder: "합주실 주소 검색"))
    
    private lazy var searchResultTable: UITableView = {
        $0.delegate = self
        $0.dataSource = self
        $0.backgroundColor = .dark01
        $0.separatorStyle = .none
        $0.register(PracticePlaceSearchTableViewCell.self,
                    forCellReuseIdentifier: PracticePlaceSearchTableViewCell.classIdentifier)
        return $0
    }(UITableView())
    
    //MARK: Google Map으로 현재 위치 바꿔야함...
    //TODO: 밴드 멤버 추가 버튼 레이아웃 참고하여 바꾸기
    
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
        let action = UIAction { _ in
            self.locationManager.requestWhenInUseAuthorization()
        }
        button.addAction(action, for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        attribute()
        configureSearchCompleter()
        setLocationManager()
    }
    
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
                                     padding: UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0))
        
    }

    private func configureSearchCompleter() {
        searchCompleter.delegate = self
        //TODO: 이게 뭔지 조사필요
        searchCompleter.resultTypes = .query
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
        print(error)
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PracticePlaceSearchTableViewCell.classIdentifier, for: indexPath) as? PracticePlaceSearchTableViewCell else { return UITableViewCell()}

        let searchResult = searchResults[indexPath.row]
        cell.configure(mapSearchResult: searchResult)

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
            self.completion(mapItem)
            self.navigationController?.popViewController(animated: true)
        }
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
