//
//  BandMemberModifyViewController.swift
//  GetARock
//
//  Created by 장지수 on 2023/03/19.
//

import UIKit

final class BandMemberModifyViewController: UIViewController {
    
    //MARK: - Property
    
    private let editState: Bool = false
    
    private let rootViewController: UIViewController
    
    private var leaderCellId: String = ""
    
    private var selectedCellIds: [String] = [] {
        didSet {
            setAbandonButtonState()
        }
    }

    private let bandData: BandInformationVO
    
    private lazy var addedMembers: [SearchedUserInfo] = transformVOData().filter { $0.memberState != .inviting }
    
    private lazy var invitingMembers: [SearchedUserInfo] = transformVOData().filter { $0.memberState == .inviting }
    
    //MARK: - View
    
    private lazy var inviteMemberButton: DefaultButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.image = ImageLiteral.magnifyingGlassSymbol
        configuration.title = "멤버 초대"
        configuration.attributedTitle?.font = UIFont.setFont(.contentBold)
        configuration.imagePadding = 5
        let button = DefaultButton(configuration: configuration)
        button.tintColor = .white
        button.constraint(.heightAnchor, constant: 55)
        let action = UIAction { [weak self] _ in
            self?.setNavigationForMemberInviting(navigationRoot: self?.rootViewController ?? UIViewController())
        }
        button.addAction(action, for: .touchUpInside)
        return button
    }()
    
    private lazy var inviteUnRegisteredMemberButton: DefaultButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.image = ImageLiteral.plusSymbol
        configuration.title = "미가입 회원 추가"
        configuration.attributedTitle?.font = UIFont.setFont(.contentBold)
        configuration.imagePadding = 5
        let button = DefaultButton(configuration: configuration)
        button.tintColor = .white
        button.constraint(.heightAnchor, constant: 55)
        let action = UIAction { [weak self] _ in
            self?.setNavigationForUnRegisteredMember(navigationRoot: self?.rootViewController ?? UIViewController())
        }
        button.addAction(action, for: .touchUpInside)
        return button
    }()
    
    private lazy var buttonHstack: UIStackView = {
        $0.axis = .horizontal
        $0.spacing = 10
        return $0
    }(UIStackView(arrangedSubviews: [inviteMemberButton,
                                     inviteUnRegisteredMemberButton]))
    
    private let bandMemberSectionTitle: BasicLabel = BasicLabel(contentText: "밴드 멤버",
                                                                fontStyle: .contentBold,
                                                                textColorInfo: .white)
    
    private lazy var editStartButton: UIButton = {
        $0.setTitle("편집", for: .normal)
        $0.setTitleColor(.blue01, for: .normal)
        $0.titleLabel?.font = UIFont.setFont(.headline04)
        let action = UIAction { [weak self] _ in
            self?.setEditingStateForMemberCell()
            self?.setAbandonButtonState()
        }
        $0.addAction(action, for: .touchUpInside)
        return $0
    }(UIButton())
    
    private lazy var editEndButton: UIButton = {
        $0.setTitle("완료", for: .normal)
        $0.setTitleColor(.blue01, for: .normal)
        $0.titleLabel?.font = UIFont.setFont(.headline04)
        let action = UIAction { [weak self] _ in
            self?.setNormalStateForMemberCell()
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
        contentText: "초대중인 멤버",
        fontStyle: .contentBold,
        textColorInfo: .white)
    
    private lazy var invitingMemberVstack: UIStackView = {
        $0.axis = .vertical
        $0.distribution = .equalSpacing
        $0.spacing = 30
        $0.backgroundColor = .dark01
        return $0
    }(UIStackView(arrangedSubviews: []))
    
    private lazy var abandonMemberButton: BottomButton = {
        $0.setTitle("내보내기", for: .normal)
        $0.setBackgroundColor(.dark02, for: .normal)
        $0.isEnabled = false
        $0.addTarget(self, action: #selector(showAlertForMemberAbandon), for: .touchUpInside)
        return $0
    }(BottomButton())
    
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
                                     invitingMemberVstack,
                                     abandonMemberButton]))
    
    //MARK: - Life Cycle
    
    init(navigateDelegate: UIViewController, bandData: BandInformationVO) {
        self.rootViewController = navigateDelegate
        self.bandData = bandData
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
        editEndButton.isHidden = true
        abandonMemberButton.isHidden = true
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
            if data.memberState == .admin { leaderCellId = data.id }
            
            //MARK: 리더버튼 클릭시 리더 변경 action 추가
            bandMemberCell.setLeaderButtonAction {
                self.showAlertForChangingLeader(newLeader: data.name) {
                    let previousLeader = self.bandMemberVstack.arrangedSubviews
                        .compactMap { $0 as? BandMemberModifyCell }
                        .first { $0.id == self.leaderCellId }
                    self.changeLeader(previousLeader: previousLeader ?? BandMemberModifyCell(),
                                      newLeader: bandMemberCell)
                }
            }
            bandMemberVstack.addArrangedSubview(bandMemberCell)
        }
        bandMemberSectionTitle.text = "밴드 멤버"
    }
    
    private func setInvitingMemberData() {
        for data in invitingMembers {
            let invitingMembers = BandMemberModifyCell()
            invitingMembers.configure(data: data)
            invitingMemberVstack.addArrangedSubview(invitingMembers)
        }
        invitingMemberSectionTitle.text = "초대중인 멤버"
    }
    
    private func setAbandonButtonState() {
        if selectedCellIds.isEmpty {
            abandonMemberButton.isEnabled = false
        } else {
            abandonMemberButton.isEnabled = true
        }
    }
}


extension BandMemberModifyViewController {
    // 데이터는 memberList 형태로 받아오지만, cell을 만들 때는 SearchedUserInfo 모델을 맞춰야하기 때문에 데이터를 변형시키는 메소드
    private func transformVOData() -> [SearchedUserInfo] {
        var resultData: [SearchedUserInfo] = []
        for data in self.bandData.memberList {
            print("++++++++기존의 밴드 멤버 데이터들++++++")
            print(data.name)
            print(data.memberState)
            print(data.memberID)
            print("++++++++기존의 밴드 멤버 데이터들++++++")
            let instrumentListInfo: [SearchedUserInstrumentList] = data.instrumentList.map {
                SearchedUserInstrumentList(instrumentId: $0.instrumentID ?? -1, isMain: $0.isMain ?? false, name: $0.name)
            }
            let transformedData: SearchedUserInfo = SearchedUserInfo(
                memberId: data.memberID!,
                name: data.name,
                memberState: data.memberState,
                instrumentList: instrumentListInfo,
                //TODO: 성별, 나이 정보가 memberList에 없음
                gender: "",
                age: "")
            
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
    
    func confirmModifiedMembers() {
        let addedMembers = addedMembers.map { MemberList(
            memberId: $0.memberId,
            name: $0.name,
            memberState: $0.memberState,
            instrumentList: $0.instrumentList
                .map({ searchedInstrument in
                    InstrumentList(name: searchedInstrument.name)})
        )}
        
        let invitingMembers = invitingMembers.map { MemberList(
            memberId: $0.memberId,
            name: $0.name,
            memberState: $0.memberState,
            instrumentList: $0.instrumentList
                .map({ searchedInstrument in
                    InstrumentList(name: searchedInstrument.name)})
        )}
        
        BasicDataModel.bandPUTData.memberList = addedMembers + invitingMembers
    }
}

extension BandMemberModifyViewController {
    
    private func setNavigationForMemberInviting(navigationRoot: UIViewController) {
        let nextViewController = UserSearchViewController()
        // 유저 검색 VC에서 초대할 멤버를 전달받는 로직
        nextViewController.completion = { selectedUsers in
            for data in selectedUsers {
                var selectedUserData = data
                selectedUserData.memberState = .inviting
                if self.invitingMembers.contains(where: { $0.id == selectedUserData.id }) == false {
                    self.invitingMembers.append(selectedUserData)
                    let newInvitingMember = BandMemberModifyCell()
                    newInvitingMember.configure(data: selectedUserData)
                    self.invitingMemberVstack.addArrangedSubview(newInvitingMember)
                }
            }
        }
        navigationRoot.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    private func setNavigationForUnRegisteredMember(navigationRoot: UIViewController) {
        let nextViewController = AddUnRegisteredMemberViewController()
        // 유저 검색 VC에서 초대할 멤버를 전달받는 로직
        nextViewController.completion = { selectedUsers in
            for data in selectedUsers {
                var selectedUserData = data
                selectedUserData.memberState = .annonymous
                if self.addedMembers.contains(where: { $0.id == selectedUserData.id }) == false {
                    self.addedMembers.append(selectedUserData)
                    let newInvitingMember = BandMemberModifyCell()
                    newInvitingMember.configure(data: selectedUserData)
                    self.bandMemberVstack.addArrangedSubview(newInvitingMember)
                }
            }
        }
        navigationRoot.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    
    
    private func showAlertForChangingLeader(newLeader: String, completion: @escaping ()->Void ) {
        //TODO: 밴드 데이터 바탕으로 업데이트 해야함
        let alertTitle = "리더 권한 양도"
        let alertMessage = "‘\(newLeader)’님에게 밴드 리더 권한을\n양도하겠습니까?\n권한을 양도하면 내 권한은 일반 멤버로 변경됩니다."
        let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        
        let changeActionTitle = "양도"
        let okayActionTitle = "취소"
        
        alertController.addAction(UIAlertAction(title: okayActionTitle, style: .default))
        alertController.addAction(UIAlertAction(title: changeActionTitle, style: .destructive, handler: { _ in
            completion()
        }))
        present(alertController, animated: true)
    }
    
    private func changeLeader(previousLeader: BandMemberModifyCell, newLeader: BandMemberModifyCell) {
        //TODO: 현재 cell UI만 리더로 변경하지만 추후 데이터 자체로 리더로 변경하게끔 하는 코드가 추가되어야함
        newLeader.getLeaderPositionState()
        previousLeader.abandonLeaderPositionState()
        leaderCellId = newLeader.id
        
        let previousLeaderIndex = self.addedMembers.firstIndex { $0.name == previousLeader.nameText() }!
        self.addedMembers[previousLeaderIndex].memberState = .member
        
        let newLeaderIndex = self.addedMembers.firstIndex { $0.name == newLeader.nameText() }!
        self.addedMembers[newLeaderIndex].memberState = .admin
    }
}

extension BandMemberModifyViewController {
    private func setEditingStateForMemberCell() {
        let bandMemberCells = bandMemberVstack.arrangedSubviews.compactMap { $0 as? BandMemberModifyCell }
        bandMemberCells.forEach { if $0.id != leaderCellId { $0.activateMemberEditingState() } }
        bandMemberCells.forEach { cell in
            cell.setSelectButtonAction {
                cell.isSelectedState.toggle()
                if !self.selectedCellIds.contains(cell.id) {
                    self.selectedCellIds.append(cell.id)
                } else {
                    self.selectedCellIds.removeAll { $0 == cell.id }
                }
            }
        }
        
        let invitingMemberCells = invitingMemberVstack.arrangedSubviews.compactMap { $0 as? BandMemberModifyCell }
        invitingMemberCells.forEach { $0.activateMemberEditingState() }
        invitingMemberCells.forEach { cell in
            cell.setSelectButtonAction {
                cell.isSelectedState.toggle()
                if !self.selectedCellIds.contains(cell.id) {
                    self.selectedCellIds.append(cell.id)
                } else {
                    self.selectedCellIds.removeAll { $0 == cell.id }
                }
            }
        }
        
        editStartButton.isHidden = true
        editEndButton.isHidden = false
        abandonMemberButton.isHidden = false
    }
    
    private func setNormalStateForMemberCell() {
        let bandMemberCells = bandMemberVstack.arrangedSubviews.compactMap { $0 as? BandMemberModifyCell }
        bandMemberCells.forEach {
            if $0.id != leaderCellId { $0.deactiveMemberEditingState() }
        }
        bandMemberCells.forEach { cell in
            cell.setSelectButtonAction {
                cell.isSelectedState.toggle()
                if !self.selectedCellIds.contains(cell.id) {
                    self.selectedCellIds.append(cell.id)
                } else {
                    self.selectedCellIds.removeAll { $0 == cell.id }
                }
            }
        }
        
        let invitingMemberCells = invitingMemberVstack.arrangedSubviews.compactMap { $0 as? BandMemberModifyCell }
        invitingMemberCells.forEach { $0.deactiveMemberEditingState() }
        invitingMemberCells.forEach { cell in
            cell.setSelectButtonAction {
                cell.isSelectedState.toggle()
                if !self.selectedCellIds.contains(cell.id) {
                    self.selectedCellIds.append(cell.id)
                } else {
                    self.selectedCellIds.removeAll { $0 == cell.id }
                }
            }
        }
        editStartButton.isHidden = false
        editEndButton.isHidden = true
        abandonMemberButton.isHidden = true
    }
    
    private func abandonMembers() {
        var deletingCells: [BandMemberModifyCell] = []
        let bandMemberCells = bandMemberVstack.arrangedSubviews.compactMap({ $0 as? BandMemberModifyCell })
        let invitingMemberCells = invitingMemberVstack.arrangedSubviews.compactMap({ $0 as? BandMemberModifyCell })
        
        for cell in bandMemberCells {
            for id in selectedCellIds {
                if cell.id == id { deletingCells.append(cell)}
            }
        }
        
        for cell in invitingMemberCells {
            for id in selectedCellIds {
                if cell.id == id { deletingCells.append(cell)}
            }
        }
        
        deletingCells.forEach { cell in
            UIView.animate(withDuration: 0.4, animations: {
                cell.alpha = 0 // fade out 애니메이션
            }, completion: { _ in
                cell.removeFromSuperview()
            })
        }
    }
    
    @objc
    private func showAlertForMemberAbandon() {
        //TODO: 밴드 데이터 바탕으로 업데이트 해야함
        let alertTitle = "멤버 내보내기"
        let alertMessage = "선택한 멤버를 정말로 내보내시겠어요?"
        let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        
        let changeActionTitle = "내보내기"
        let okayActionTitle = "취소"
        
        alertController.addAction(UIAlertAction(title: okayActionTitle, style: .default))
        alertController.addAction(UIAlertAction(title: changeActionTitle, style: .destructive, handler: { _ in
            self.abandonMembers()
            self.setAbandonButtonState()
        }))
        present(alertController, animated: true)
    }
}
