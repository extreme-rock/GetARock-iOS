//
//  BandMemberModifyViewController.swift
//  GetARock
//
//  Created by 장지수 on 2023/03/01.
//

import UIKit

//MARK: - DiffableDatasouce section
enum BandMemberModifyTableViewSection {
    case confirmedMembers
    case invitingMembers
}

final class BandMemberModifyViewController: BaseViewController {

    //MARK: - Property

    private var isNavigationButtonTapped: Bool = false
    
    private lazy var addedMembers: [SearchedUserInfo] = getTransformedVOData().filter { $0.memberState != .inviting }
    
    private lazy var invitingMembers: [SearchedUserInfo] = getTransformedVOData().filter { $0.memberState == .inviting } {
        didSet {
            self.invitingMemberSectionTitle.text = "초대중인 멤버 (\(invitingMembers.count)인)"
        }
    }

    //MARK: - View

    private lazy var confirmedMemberSectionTitle: BasicLabel = BasicLabel(
        contentText: "밴드 멤버 (\(self.addedMembers.count)인)",
        fontStyle: .contentBold,
        textColorInfo: .white)

    private lazy var invitingMemberSectionTitle: BasicLabel = BasicLabel(
        contentText: "초대중인 멤버 (\(self.invitingMembers.count)인)",
        fontStyle: .contentBold,
        textColorInfo: .white)

    private lazy var bandMemberTableView: UITableView = {
        $0.register(BandMemberModifyTableViewCell.self,
                    forCellReuseIdentifier: BandMemberModifyTableViewCell.classIdentifier)
        $0.register(BandMemberModifyTableViewHeader.self,
                    forHeaderFooterViewReuseIdentifier: BandMemberModifyTableViewHeader.classIdentifier)
        $0.separatorStyle = .none
        $0.backgroundColor = .dark01
        $0.allowsMultipleSelection = true
        $0.bounces = false
        $0.delegate = self
        return $0
    }(UITableView())
    
    private var indexPathOfLeaderCell: IndexPath = IndexPath(row: 0, section: 0)

    private lazy var dataSource: UITableViewDiffableDataSource<BandMemberModifyTableViewSection, SearchedUserInfo> = self.makeDataSource()

    private lazy var abandonMemberButton: BottomButton = {
        let action = UIAction { _ in
            self.confirmBandMemberList()
        }
        $0.setTitle("내보내기", for: .normal)
        $0.addAction(action, for: .touchUpInside)
        return $0
    }(BottomButton())
    
    private lazy var contentVstack: UIStackView = {
        $0.axis = .vertical
        $0.isLayoutMarginsRelativeArrangement = true
        $0.layoutMargins = UIEdgeInsets(top: 20, left: 16, bottom: 20, right: 0)
        return $0
    }(UIStackView(arrangedSubviews: [bandMemberTableView, abandonMemberButton]))

    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        attribute()
        setupLayout()
        updateSnapShot(addedMembers: self.addedMembers, invitingMembers: self.invitingMembers)
    }

    override func viewWillAppear(_ animated: Bool) {
        self.isNavigationButtonTapped = false
    }

    //MARK: - Method

    private func setupLayout() {
        view.addSubview(contentVstack)
        contentVstack.constraint(to: view)
    }

    private func showBottomButton() {
        abandonMemberButton.isHidden = false
    }

    private func hideBottomButton() {
        abandonMemberButton.isHidden = true
    }

    private func attribute() {
        view.backgroundColor = .dark01
        abandonMemberButton.isHidden = true
    }
}
extension BandMemberModifyViewController {
    
    private func getTransformedVOData() -> [SearchedUserInfo] {
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
                gender: "",
                age: "")
            
            resultData.append(transformedData)
        }
        return resetDataOrder(with: resultData)
    }
    
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
    
    private func updateLeaderPositionIndexPath(indexPath: IndexPath) {
        indexPathOfLeaderCell = indexPath
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
}

//MARK: DiffableDataSource 관련 메소드
extension BandMemberModifyViewController {

    func updateSnapShot(addedMembers: [SearchedUserInfo], invitingMembers: [SearchedUserInfo]) {
        var dataSourceSnapShot: NSDiffableDataSourceSnapshot = NSDiffableDataSourceSnapshot<BandMemberModifyTableViewSection, SearchedUserInfo>()
        dataSourceSnapShot.appendSections([.confirmedMembers, .invitingMembers])
        dataSourceSnapShot.appendItems(addedMembers, toSection: .confirmedMembers)
        dataSourceSnapShot.appendItems(invitingMembers, toSection: .invitingMembers)
        self.dataSource.apply(dataSourceSnapShot, animatingDifferences: true)
    }

    func makeDataSource() -> UITableViewDiffableDataSource<BandMemberModifyTableViewSection, SearchedUserInfo> {
        return UITableViewDiffableDataSource<BandMemberModifyTableViewSection, SearchedUserInfo>(tableView: self.bandMemberTableView) { tableView, indexPath, cellData in

            guard let cell = tableView.dequeueReusableCell(withIdentifier: BandMemberModifyTableViewCell.classIdentifier, for: indexPath) as? BandMemberModifyTableViewCell else { return UITableViewCell() }

            cell.configure(data: cellData)
            if cellData.memberState == .admin {
                self.updateLeaderPositionIndexPath(indexPath: indexPath)
                cell.getLeaderPositionState()
            }
            cell.selectionStyle = .none

            cell.setLeaderButtonAction {
                //TODO: Post할 정보에서 리더 정보 바꾸기 필요
                self.showAlertForChangingLeader(newLeader: cell.nameText()) {
                    self.changeLeader(newLeader: cell, newLeaderIndexPath: indexPath)
                }
            }
            return cell
        }
    }
}

extension BandMemberModifyViewController {

    private func didTapInviteMemberButton() {
        let nextViewController = UserSearchViewController()
        // 유저 검색 VC에서 초대할 멤버를 전달받는 로직
        nextViewController.completion = { selectedUsers in
            for data in selectedUsers {
                if self.invitingMembers.contains(where: { $0.id == data.id }) == false {
                    self.invitingMembers.append(data)
                }
            }
            // 전달받는 데이터가 추가되면서 datasource 업데이트
            self.updateSnapShot(addedMembers: self.addedMembers, invitingMembers: self.invitingMembers)
        }

        // 네비게이션 버튼을 여러번 탭하여 여러번 네비게이션 되는 것 방지
        if !self.isNavigationButtonTapped {
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }
        self.isNavigationButtonTapped = true
    }

    private func changeLeader(newLeader: BandMemberModifyTableViewCell, newLeaderIndexPath: IndexPath) {
        newLeader.getLeaderPositionState()
        guard let previousLeaderCell = self.bandMemberTableView.cellForRow(at: self.indexPathOfLeaderCell) as? BandMemberModifyTableViewCell else { return }
        previousLeaderCell.abandonLeaderPositionState()
        self.updateLeaderPositionIndexPath(indexPath: newLeaderIndexPath)
    }
}

//MARK: TableView Delegate
extension BandMemberModifyViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    //MARK: Header Configuration
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var headerView: UIView = UIView()
        
        let sectionIdentifier = dataSource.snapshot().sectionIdentifiers[section]

        switch sectionIdentifier {
        case .confirmedMembers:
            guard let addedMemberTableHeader = tableView.dequeueReusableHeaderFooterView(
                withIdentifier: BandMemberModifyTableViewHeader.classIdentifier) as? BandMemberModifyTableViewHeader else { return UIView() }

            addedMemberTableHeader.setInviteMemberButtonAction {
                self.didTapInviteMemberButton()
            }

            // edit 버튼 누르면 하는 액션 설정
            addedMemberTableHeader.startEditingAction = {
                for index in 0..<self.addedMembers.count {
                    guard let cell = self.bandMemberTableView.cellForRow(at: IndexPath(row: index, section: 0)) as? BandMemberModifyTableViewCell else { return }
                    cell.activateMemberEditingState()
                    self.showBottomButton()
                }
            }

            // 완료 버튼 누르면 하는 액션 설정
            addedMemberTableHeader.finishEditingAction = {
                for index in 0..<self.addedMembers.count {
                    guard let cell = self.bandMemberTableView.cellForRow(at: IndexPath(row: index, section: 0)) as? BandMemberModifyTableViewCell else { return }
                    cell.deActiveMemberEditingState()
                    cell.isSelected = false
                    self.hideBottomButton()
                }
                self.abandonMemberButton.setTitle("내보내기", for: .normal)
            }
            //initialize action
            // didset에 따라서 편집중이면 액션이 바뀐다
            // 그런데 초기에는 didset이 작동하지않아서 초기화가 필요
            addedMemberTableHeader.editButton.addAction(UIAction{ _ in
                addedMemberTableHeader.startEditingAction()
                addedMemberTableHeader.isEditing = true
                addedMemberTableHeader.editButton.setTitle("완료", for: .normal)
            }, for: .touchUpInside)

        addedMemberTableHeader.configureSectionTitle(with: "밴드 멤버 (\(addedMembers.count)인)")
        headerView = addedMemberTableHeader

    case .invitingMembers:
        headerView = invitingMemberSectionTitle
    }
    return headerView
}
}

extension BandMemberModifyViewController {
    func confirmBandMemberList() {
        var confirmedMembers: [MemberList] = []
        self.addedMembers.forEach {

            let instrumentList: [InstrumentList] = $0.instrumentList.map { InstrumentList(name: $0.name) }

            let individualMember: MemberList = MemberList(memberId: $0.memberId,
                                                          name: $0.name,
                                                          memberState: $0.memberState,
                                                          instrumentList: instrumentList)

            confirmedMembers.append(individualMember)
        }
        BasicDataModel.bandCreationData.memberList = confirmedMembers
    }
}

