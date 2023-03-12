//
//  BandTopInfoView.swift
//  GetARock
//
//  Created by Yu ahyeon on 2023/02/13.
//

import UIKit

protocol BandTopInfoViewDelegate: AnyObject {
    func didBandSelectButtonTapped(isBandSelectButton: Bool)
}

final class BandTopInfoView: UIView {
    
    // MARK: - Property
    
    weak var delegate: BandTopInfoViewDelegate?
    private var bandName = ""
    private var bandAddress: AddressVO
    private lazy var isBandSelectButton: Bool = false {
        didSet {
            self.bandSelectToggleButton.setImage(
                self.isBandSelectButton
                ? ImageLiteral.chevronUpSymbol
                : ImageLiteral.chevronDownSymbol
                , for: .normal)
        }
    }
    
    // MARK: - View
    
    //TODO: 추후 밴드 데이터를 이용해 이름을 각 라벨 업데이트 필요
    
    private lazy var bandNameStackView: UIStackView = {
        $0.axis = .horizontal
        $0.spacing = 5
        $0.alignment = .center
        return $0
    }(UIStackView(arrangedSubviews: [bandNameLabel, bandSelectToggleButton]))
    
    private lazy var bandNameLabel: BasicLabel = {
        $0.numberOfLines = 2
        return $0
    }(BasicLabel(contentText: bandName,
                 fontStyle: .headline04,
                 textColorInfo: .white))
    
    private lazy var bandSelectToggleButton: UIButton = {
        // TODO: 터치영역이 작은 문제 해결해야함
        $0.setImage(ImageLiteral.chevronDownSymbol, for: .normal)
        $0.tintColor = .white
        $0.constraint(.heightAnchor, constant: 24)
        $0.addTarget(self, action: #selector(didBandSelectToggleButtonTapped), for: .touchUpInside)
        return $0
    }(UIButton())
    
    //TODO: 추후 밴드 데이터를 이용해 이름을 각 라벨 업데이트 필요
    private lazy var locationLabel: BasicLabel = {
        $0.numberOfLines = 2
        return $0
    }(BasicLabel(
        contentText: "",
        fontStyle: .content,
        textColorInfo: .white)
    )
    
    private let customPinIconImage: UIImageView = {
        $0.image = ImageLiteral.customPinIcon
        $0.constraint(.widthAnchor, constant: 12)
        $0.contentMode = .scaleAspectFit
        return $0
    }(UIImageView())
    
    private lazy var locationStackView: UIStackView = {
        $0.axis = .horizontal
        $0.spacing = 10
        return $0
    }(UIStackView(arrangedSubviews: [customPinIconImage,locationLabel]))
    
    private lazy var infoStackView: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 5
        $0.alignment = .leading
        return $0
    }(UIStackView(arrangedSubviews: [bandNameStackView,locationStackView]))
    
    private let divider: UIView = {
        $0.backgroundColor = .dark02
        return $0
    }(UIView())
    
    // MARK: - Init
    
    init(name: String, address: AddressVO) {
        self.bandName = name
        self.bandAddress = address
        super.init(frame: .zero)
        setupLayout()
        attribute()
        addModifyObserver()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Method
    
    private func attribute() {
        self.backgroundColor = .dark01
        setBandAddress()
    }
    
    private func setupLayout() {
        self.addSubview(infoStackView)
        infoStackView.constraint(
            top: self.topAnchor,
            leading: self.leadingAnchor,
            trailing: self.trailingAnchor,
            padding: UIEdgeInsets(top: 30, left: 16, bottom: 0, right: 16)
        )
        
        self.addSubview(divider)
        divider.constraint(
            top: infoStackView.bottomAnchor,
            leading: self.leadingAnchor,
            bottom: self.bottomAnchor ,
            trailing: self.trailingAnchor,
            padding: UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        )
        self.divider.constraint(.heightAnchor, constant: DividerSize.height)
    }
    
    private func setBandAddress() {
        let city = bandAddress.city
        let street = bandAddress.street
        let detail = bandAddress.detail
        let bandAddressText = city + " " + street + " " +  detail
        locationLabel.text = bandAddressText
    }
    
    @objc
    private func didBandSelectToggleButtonTapped() {
        self.isBandSelectButton.toggle()
        delegate?.didBandSelectButtonTapped(isBandSelectButton: self.isBandSelectButton)
    }
    
    @objc
    private func configure(with notification: Notification) {
        
        guard let bandInfo = notification.userInfo?["bandInfo"] as? BandInformationVO else { return }
        self.bandNameLabel.text = bandInfo.name
        self.bandAddress = bandInfo.address
        setBandAddress()
    }
}

extension BandTopInfoView {
    private func addModifyObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(configure(with: )),
                                               name: NSNotification.Name.configureBandData,
                                               object: nil)
    }
}
