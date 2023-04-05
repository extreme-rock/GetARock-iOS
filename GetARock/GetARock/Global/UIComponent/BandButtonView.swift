//
//  BandButton.swift
//  GetARock
//
//  Created by Yu ahyeon on 2023/01/30.
//

import UIKit

final class BandButtonView: UIView {
    
    // MARK: - Property
//    private let bandData: BandListVO
    private let bandID: Int
    private let bandName: String
    private let membersNumber: Int
    private let membersAge: String
    
    // MARK: - View
    
    private let backgroundImage: UIImageView = {
        $0.image = UIImage(named: "bandButton")
        $0.contentMode = .scaleAspectFit
        return $0
    }(UIImageView())
    
    private lazy var bandNameLabel: BasicLabel = {
        $0.numberOfLines = 2
        return $0
    }(BasicLabel(contentText: bandName,
                 fontStyle: .headline01,
                 textColorInfo: .white))
    
    private let memberIconImage: UIImageView = {
        $0.image = ImageLiteral.personThreeFillSymbol
        $0.image?.withConfiguration(SFIconSize.smallIconSize)
        $0.contentMode = .scaleAspectFit
        $0.tintColor = .white
        return $0
    }(UIImageView())
    
    private lazy var memberInfoLabel: BasicLabel = {
        return $0
    }(BasicLabel(contentText: "\(membersNumber)인 | \(membersAge)",
                 fontStyle: .content,
                 textColorInfo: .white))
    
    private lazy var memberstackView: UIStackView = {
        $0.axis = .horizontal
        $0.spacing = 5
        return $0
    }(UIStackView(arrangedSubviews: [memberIconImage, memberInfoLabel]))
    
    private lazy var bandInfoStackView: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 8
        $0.alignment = .leading
        $0.isLayoutMarginsRelativeArrangement = true
        $0.layoutMargins = UIEdgeInsets(top: 0.0, left: 25.0, bottom: 0.0, right: 0.0)
        return $0
    }(UIStackView(arrangedSubviews: [bandNameLabel,memberstackView]))
    
    // MARK: - Init
    
    init(
//        bandData: BandListVO,
        bandID: Int,
         bandName: String,
         membersNumber: Int,
         membersAge: String) {
//        self.bandData = bandData
        self.bandID = bandID
        self.bandName = bandName
        self.membersNumber = membersNumber
        self.membersAge = membersAge
        super.init(frame: .zero)
        setupLayout()
        attribute()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Method
    
    private func attribute() {
        self.constraint(.widthAnchor, constant: BandButtonSize.width)
        self.constraint(.heightAnchor, constant: BandButtonSize.height)
    }
    
    private func setupLayout() {
        
        self.addSubview(backgroundImage)
        self.backgroundImage.constraint(to: self)
        
        self.backgroundImage.addSubview(bandInfoStackView)
        self.bandInfoStackView.constraint(.widthAnchor, constant: BandButtonSize.width/1.8)
        self.bandInfoStackView.constraint(centerY: backgroundImage.centerYAnchor)
        addBandButtonAction()
    }
    
    private func addBandButtonAction() {
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(moveBandInfo(_:))
        )
        self.addGestureRecognizer(tapGesture)
        self.isUserInteractionEnabled = true
    }
    
    @objc
       func moveBandInfo(_ gesture: UITapGestureRecognizer) {
           let selectbandData = BandList(bandId: bandID,
                                   name: bandName,
                                   memberCount: membersNumber,
                                   memberAge: membersAge)
           NotificationCenter.default.post(name: NSNotification.Name.presentBandDetailViewController,
                                           object: nil,
                                           userInfo: ["selectbandData": selectbandData])
       }
}
