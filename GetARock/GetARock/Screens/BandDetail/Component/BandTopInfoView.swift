//
//  BandTopInfoView.swift
//  GetARock
//
//  Created by Yu ahyeon on 2023/02/13.
//

import UIKit

protocol BandTopInfoViewDelegate: AnyObject {
    func didBandSelectButtonTapped(isBandSelectButton: Bool)
    func showBandOptionActionSheet()
}

final class BandTopInfoView: UIView {
    
    // MARK: - Property
    
    weak var delegate: BandTopInfoViewDelegate?
    private var bandName = ""
    private var bandAddress: AddressVO
    private lazy var isBandButtonSelect: Bool = false {
        didSet {
            self.bandListDisclosureButton.setImage(
                self.isBandButtonSelect
                ? ImageLiteral.chevronUpSymbol
                : ImageLiteral.chevronDownSymbol
                , for: .normal)
        }
    }
    
    // MARK: - View
    
    //TODO: 추후 밴드 데이터를 이용해 이름을 각 라벨 업데이트 필요
    
    private lazy var bandNameLabel: BasicLabel = {
        $0.numberOfLines = 2
        return $0
    }(BasicLabel(contentText: bandName,
                 fontStyle: .headline01,
                 textColorInfo: .white))
    
    private lazy var bandNameStackView: UIStackView = {
        $0.axis = .horizontal
        $0.alignment = .center
        return $0
    }(UIStackView(arrangedSubviews: [bandNameLabel]))
    
    private lazy var bandListDisclosureButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.contentInsets = .init(top: 10, leading: 10, bottom: 10, trailing: 10)
        let button = UIButton(configuration: configuration)
        button.setImage(ImageLiteral.chevronDownSymbol, for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(didBandSelectToggleButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var optionButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.contentInsets = .init(top: 10, leading: 10, bottom: 10, trailing: 10)
        let button = UIButton(configuration: configuration)
        button.setImage(ImageLiteral.ellipsisSymbol, for: .normal)
        button.tintColor = .white
        button.transform = button.transform.rotated(by: .pi / 2)
        let action = UIAction { [weak self] _ in
            self?.showOptionActionSheet()
        }
        button.addAction(action, for: .touchUpInside)
        return button
    }()
    
    //TODO: 추후 밴드 데이터를 이용해 이름을 각 라벨 업데이트 필요
    private lazy var locationLabel: BasicLabel = {
        $0.numberOfLines = 0
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
        $0.spacing = 10
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
            padding: UIEdgeInsets(top: 10, left: 16, bottom: 0, right: 35)
        )
//
//        self.addSubview(optionButton)
//        optionButton.constraint(top: self.topAnchor,
//                                trailing: self.trailingAnchor,
//                                padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16))
        
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

    func setupOptionButtonLayout() {
        self.addSubview(optionButton)
        optionButton.constraint(top: self.topAnchor,
                                trailing: self.trailingAnchor,
                                padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16))

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
        self.isBandButtonSelect.toggle()
        delegate?.didBandSelectButtonTapped(isBandSelectButton: self.isBandButtonSelect)
    }

    
    func setupToggleButtonLayout() {
        self.bandNameStackView.addArrangedSubview(self.bandListDisclosureButton)
    }

    private func showOptionActionSheet() {
        // TODO: 리더이면 밴드 삭제를 넣고 아님 말고
        self.delegate?.showBandOptionActionSheet()
    }

    func configure(bandInfo: BandInformationVO) {
        self.bandNameLabel.text = bandInfo.name
        self.bandAddress = bandInfo.address
        setBandAddress()
        self.isBandButtonSelect = false
    }
}

extension BandTopInfoView {
    private func addModifyObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(configure(with: )),
            name: NSNotification.Name.configureBandData,
            object: nil
        )
    }

    @objc
    private func configure(with notification: Notification) {
        guard let bandInfo = notification.userInfo?["bandInfo"] as? BandInformationVO else { return }
        self.bandNameLabel.text = bandInfo.name
        self.bandAddress = bandInfo.address
        setBandAddress()
        self.isBandButtonSelect = false
    }
}
