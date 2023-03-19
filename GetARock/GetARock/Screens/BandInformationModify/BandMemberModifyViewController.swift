//
//  BandMemberModifyViewController.swift
//  GetARock
//
//  Created by 장지수 on 2023/03/19.
//

import UIKit

final class BandMemberModifyViewController: UIViewController {
    
    //MARK: - View
    
    private let editState: Bool = false
    
    private let rootViewController: UIViewController
    
    private lazy var addedMembers: [SearchedUserInfo] = transformVOData().filter { $0.memberState != .inviting }
    
    private lazy var invitingMembers: [SearchedUserInfo] = transformVOData().filter { $0.memberState == .inviting }
    
    let inviteMemberButton: DefaultButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.image = ImageLiteral.magnifyingGlassSymbol
        configuration.title = "멤버 초대"
        configuration.attributedTitle?.font = UIFont.setFont(.contentBold)
        configuration.imagePadding = 5
        let button = DefaultButton(configuration: configuration)
        button.tintColor = .white
        button.constraint(.heightAnchor, constant: 55)
        return button
    }()
    
    let inviteUnRegisteredMemberButton: DefaultButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.image = ImageLiteral.plusSymbol
        configuration.title = "미가입 회원 추가"
        configuration.attributedTitle?.font = UIFont.setFont(.contentBold)
        configuration.imagePadding = 5
        let button = DefaultButton(configuration: configuration)
        button.tintColor = .white
        button.constraint(.heightAnchor, constant: 55)
        return button
    }()
    
    private lazy var buttonHstack: UIStackView = {
        $0.axis = .horizontal
        $0.spacing = 10
        return $0
    }(UIStackView(arrangedSubviews: [inviteMemberButton,
                                     inviteUnRegisteredMemberButton]))
    
    private let bandMemberSectionTitle: BasicLabel = BasicLabel(contentText: "밴드 멤버 (1인)",
                                                      fontStyle: .contentBold,
                                                      textColorInfo: .white)
    
    private lazy var editStartButton: UIButton = {
        $0.setTitle("편집", for: .normal)
        $0.setTitleColor(.blue01, for: .normal)
        $0.titleLabel?.font = UIFont.setFont(.headline04)
        let action = UIAction { _ in
        }
        $0.addAction(action, for: .touchUpInside)
        return $0
    }(UIButton())
    
    private lazy var editEndButton: UIButton = {
        $0.setTitle("완료", for: .normal)
        $0.setTitleColor(.blue01, for: .normal)
        $0.titleLabel?.font = UIFont.setFont(.headline04)
        let action = UIAction { _ in
        }
        $0.addAction(action, for: .touchUpInside)
        return $0
    }(UIButton())
    
    
    private lazy var bandMemberSectionHeader: UIStackView = {
        $0.axis = .horizontal
        $0.isLayoutMarginsRelativeArrangement = true
        $0.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        return $0
    }(UIStackView(arrangedSubviews: [bandMemberSectionTitle,
                                     editStartButton,
                                     editEndButton]))
    
    private lazy var bandMemberVstack: UIStackView = {
        $0.axis = .vertical
        $0.distribution = .equalSpacing
        $0.spacing = 30
        $0.backgroundColor = .dark01
        return $0
    }(UIStackView(arrangedSubviews: []))
    
    private let invitingMemberSectionTitle: BasicLabel = BasicLabel(
        contentText: "초대중인 멤버 (1인)",
        fontStyle: .contentBold,
        textColorInfo: .white)
    
    private lazy var invitingMemberVstack: UIStackView = {
        $0.axis = .vertical
        $0.distribution = .equalSpacing
        $0.spacing = 30
        $0.backgroundColor = .dark01
        return $0
    }(UIStackView(arrangedSubviews: []))
    
    // Overall layout
    
    private lazy var mainScrollView: UIScrollView = {
        $0.showsVerticalScrollIndicator = true
        $0.backgroundColor = .dark01
        return $0
    }(UIScrollView())
    
    private lazy var contentView: UIStackView = {
        $0.axis = .vertical
        $0.distribution = .equalSpacing
        $0.spacing = 30
        $0.backgroundColor = .dark01
        $0.constraint(.widthAnchor, constant: BasicComponentSize.width)
        return $0
    }(UIStackView(arrangedSubviews: [buttonHstack,
                                     bandMemberSectionHeader,
                                     bandMemberVstack,
                                     invitingMemberSectionTitle,
                                     invitingMemberVstack]))
    
    //MARK: - Life Cycle
    
    init(navigateDelegate: UIViewController) {
        self.rootViewController = navigateDelegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        attribute()
        setupLayout()
    }
    
    private func attribute() {
        setEditButtonForNormalState()
        setBandMemberData()
        setInvitingMemberData()
    }
    
    private func setupLayout() {
        view.addSubview(mainScrollView)
        mainScrollView.addSubview(contentView)
        
        mainScrollView.constraint(top: view.topAnchor,
                                  leading: view.leadingAnchor,
                                  bottom: view.bottomAnchor,
                                  trailing: view.trailingAnchor)
        
        contentView.constraint(top: mainScrollView.topAnchor,
                               bottom: mainScrollView.bottomAnchor,
                               centerX: mainScrollView.centerXAnchor)
    }
    
    private func setBandMemberData() {
        for data in addedMembers {
            let bandMemberCell = BandMemberModifyCell()
            bandMemberCell.configure(data: data)
            bandMemberVstack.addArrangedSubview(bandMemberCell)
        }
        bandMemberSectionTitle.text = "밴드 멤버 (\(addedMembers.count))인"
    }
    
    private func setInvitingMemberData() {
        for data in invitingMembers {
            let invitingMembers = BandMemberModifyCell()
            invitingMembers.configure(data: data)
            invitingMemberVstack.addArrangedSubview(invitingMembers)
        }
        invitingMemberSectionTitle.text = "초대중인 멤버 (\(invitingMembers.count))인"
    }
    
    private func setEditButtonForNormalState() {
        editEndButton.isHidden = true
    }
    
    private func setEditButtonForEditingState() {
        editEndButton.isHidden = false
        editStartButton.isHidden = true
    }
}


extension BandMemberModifyViewController {
    // 데이터는 memberList 형태로 받아오지만, cell을 만들 때는 SearchedUserInfo 모델을 맞춰야하기 때문에 데이터를 변형시키는 메소드
    private func transformVOData() -> [SearchedUserInfo] {
        var resultData: [SearchedUserInfo] = []
        //MARK: 추후 더미데이터가 아니라 API 데이터로 해야함
        for data in BasicDataModel.dummyBandInfo.memberList {
            let instrumentListInfo: [SearchedUserInstrumentList] = data.instrumentList.map {
                SearchedUserInstrumentList(instrumentId: $0.instrumentID ?? -1, isMain: $0.isMain ?? false, name: $0.name)
            }
            let transformedData: SearchedUserInfo = SearchedUserInfo(
                memberId: data.memberID ?? 0,
                name: data.name,
                memberState: data.memberState,
                instrumentList: instrumentListInfo,
                gender: "남",
                age: "20대")
            
            resultData.append(transformedData)
        }
        return resetDataOrder(with: resultData)
    }
    
    // 리더 - 멤버 - 미가입 - 초대중 순으로 데이터를 배열하는 메소드
    private func resetDataOrder(with data: [SearchedUserInfo]) -> [SearchedUserInfo] {
        var resultList: [SearchedUserInfo] = []
        let leader = data.filter { $0.memberState == .admin }
        let members = data.filter { $0.memberState == .none }
        let annonymous = data.filter({ $0.memberState == .annonymous })
        let invitingMembers = data.filter { $0.memberState == .inviting }
        resultList += leader
        resultList += members
        resultList += annonymous
        resultList += invitingMembers
        return resultList
    }
}

extension BandMemberModifyViewController {
    
    private func setNavigationAttribute(navigationRoot: UIViewController) {
        let nextViewController = UserSearchViewController()
        // 유저 검색 VC에서 초대할 멤버를 전달받는 로직
        nextViewController.completion = { selectedUsers in
            for data in selectedUsers {
                if self.invitingMembers.contains(where: { $0.id == data.id }) == false {
                    self.invitingMembers.append(data)
                }
            }
            // 전달받는 데이터가 추가되면서 datasource 업데이트 + 밴드 멤버 숫자를 나타내는 레이블 업데이트
            self.invitingMemberSectionTitle.text = "초대중인 멤버 (\(self.invitingMembers.count))인"
        }
    }
}
