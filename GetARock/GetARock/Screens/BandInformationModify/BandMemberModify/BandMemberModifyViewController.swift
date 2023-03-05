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

final class BandMemberModifyViewController: UIViewController {

    //MARK: - Property
    
    private let rootViewController: UIViewController

    private var isNavigationButtonTapped: Bool = false
    
    private lazy var addedMembers: [SearchedUserInfo] = getTransformedVOData().filter { $0.memberState != .inviting }
    
    private lazy var invitingMembers: [SearchedUserInfo] = getTransformedVOData().filter { $0.memberState == .inviting } {
        didSet {
            self.invitingMemberSectionTitle.text = "초대중인 멤버 (\(invitingMembers.count)인)"
        }
    }
    
    private var indexPathOfLeaderCell: IndexPath = IndexPath(row: 0, section: 0)
    
    private var selectedCellInformationList: [(indexPath: IndexPath, id: String)] = []

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
        $0.separatorStyle = .none
        $0.backgroundColor = .dark01
        $0.allowsSelectionDuringEditing = true
        $0.bounces = false
        $0.delegate = self
        return $0
    }(UITableView(frame: .zero, style: .grouped)) // headerview 전체로 같이 스크롤을 위해 설정

    private lazy var dataSource: UITableViewDiffableDataSource<BandMemberModifyTableViewSection, SearchedUserInfo> = self.makeDataSource()

    private lazy var abandonMemberButton: BottomButton = {
        $0.setTitle("내보내기", for: .normal)
        $0.addTarget(self, action: #selector(didTapAbandonButton), for: .touchUpInside)
        return $0
    }(BottomButton())
    
    private lazy var contentVstack: UIStackView = {
        $0.axis = .vertical
        $0.isLayoutMarginsRelativeArrangement = true
        $0.layoutMargins = UIEdgeInsets(top: 20, left: 16, bottom: 20, right: 0)
        return $0
    }(UIStackView(arrangedSubviews: [bandMemberTableView, abandonMemberButton]))
    
    init(navigateDelegate: UIViewController) {
        self.rootViewController = navigateDelegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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

    //MARK: - Methods

    private func setupLayout() {
        view.addSubview(contentVstack)
        contentVstack.constraint(to: view)
    }
    
    private func attribute() {
        view.backgroundColor = .dark01
        abandonMemberButton.isHidden = true
    }

    private func showBottomButton() {
        abandonMemberButton.isHidden = false
    }

    private func hideBottomButton() {
        abandonMemberButton.isHidden = true
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

//MARK: TableView Delegate
extension BandMemberModifyViewController: UITableViewDelegate {

    //MARK: ❗️TableView Header Configuration
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let sectionIdentifier = dataSource.snapshot().sectionIdentifiers[section]

        switch sectionIdentifier {
        case .confirmedMembers:
            let addedMemberTableHeader = BandMemberModifyTableViewHeader()

            addedMemberTableHeader.setInviteMemberButtonAction {
                self.setNavigationAttribute(navigationRoot: self.rootViewController)
            }

            // 편집 버튼 누르면 하는 액션 설정
            addedMemberTableHeader.actionForTappingEditButton = {
                self.bandMemberTableView.isEditing = true
                self.showBottomButton()
            }

            // 완료 버튼 누르면 하는 액션 설정
            addedMemberTableHeader.actionForTappingDoneButton = {
                self.bandMemberTableView.isEditing = false
                self.selectedCellInformationList = [] // initialize selected cell
                self.hideBottomButton()
            }
            // didset에 따라서 편집중이면 액션이 바뀐다
            // 그런데 초기에는 didset이 작동하지않아서 초기화가 필요
            addedMemberTableHeader.editButton.addAction(UIAction{ _ in
                addedMemberTableHeader.actionForTappingEditButton()
                addedMemberTableHeader.isEditing = true
                addedMemberTableHeader.editButton.setTitle("완료", for: .normal)
            }, for: .touchUpInside)

            addedMemberTableHeader.configureSectionTitle(with: "밴드 멤버 (\(addedMembers.count)인)")
            return addedMemberTableHeader

        case .invitingMembers:
            return invitingMemberSectionTitle
        }
    }
    
    // cellForRowAt은 스크린에서 보이지않는 Cell에 적용되지 않기 때문에 선택된 cell의 인덱스를 따로 관리하는 배열을 만듬
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedCell = tableView.cellForRow(at: indexPath) as? BandMemberModifyTableViewCell else { return }
        if selectedCellInformationList.map({ $0.indexPath }).contains(indexPath) {
            selectedCell.isSelectedState = false
            selectedCellInformationList.removeAll { $0.indexPath == indexPath }
        } else {
            selectedCell.isSelectedState = true
            selectedCellInformationList.append((indexPath: indexPath, id: selectedCell.id))
        }
        self.updateSnapShot(addedMembers: self.addedMembers, invitingMembers: self.invitingMembers)
    }
    
    // 테이블뷰의 편집모드시 셀 왼쪽의 indentation 삭제
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    // 테이블뷰의 편집모드시 셀 왼쪽의 기본 편집아이콘 삭제
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

//MARK: 데이터 추가 삭제 관련 로직
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
            // 전달받는 데이터가 추가되면서 datasource 업데이트
            self.updateSnapShot(addedMembers: self.addedMembers, invitingMembers: self.invitingMembers)
        }
        // 네비게이션 버튼을 여러번 탭하여 여러번 네비게이션 되는 것 방지
        print("Button tapped")
        if !self.isNavigationButtonTapped {
            navigationRoot.navigationController?.pushViewController(nextViewController, animated: true)
        }
        self.isNavigationButtonTapped = true
    }
    
    private func abandonMembers() {
        for cellInfo in selectedCellInformationList {
            addedMembers.removeAll { $0.id == cellInfo.id }
            invitingMembers.removeAll { $0.id == cellInfo.id }
        }
        updateSnapShot(addedMembers: addedMembers, invitingMembers: invitingMembers)
    }
    
    private func showAlertForAbandoningMembers(completion: @escaping ()->Void ) {
        //TODO: 밴드 데이터 바탕으로 업데이트 해야함
        let alertTitle = "멤버 내보내기"
        let alertMessage = "선택하신 멤버를 내보내시겠습니까?\n더이상 밴드에서 해당 멤버를 확인할 수 없습니다."
        let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)

        let okayActionTitle = "확인"
        let cancleActionTitle = "취소"

        alertController.addAction(UIAlertAction(title: cancleActionTitle, style: .default))
        alertController.addAction(UIAlertAction(title: okayActionTitle, style: .destructive, handler: { _ in
            completion()
        }))
        present(alertController, animated: true)
    }
    
    private func showAlertForLeaderAbandon() {
        let alertTitle = "리더는 내보낼 수 없어요!"
        let alertMessage = "리더를 양도하신 후 내보내기를 진행해주세요"
        let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        let okayActionTitle = "확인"
        alertController.addAction(UIAlertAction(title: okayActionTitle, style: .default))
        present(alertController, animated: true)
    }
    
    @objc
    private func didTapAbandonButton() {
        let isLeaderIncluded: Bool = self.selectedCellInformationList.map({ $0.indexPath }).contains(self.indexPathOfLeaderCell)
        
        if isLeaderIncluded {
            self.showAlertForLeaderAbandon()
        } else {
            self.showAlertForAbandoningMembers(completion: {
                self.abandonMembers()
            })
        }
    }
}

//MARK: TableView를 그리기 위한 데이터를 전처리하는 로직
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
}

//MARK: 리더포지션 변경 관련 로직
extension BandMemberModifyViewController {
    
    private func changeLeader(newLeader: BandMemberModifyTableViewCell, newLeaderIndexPath: IndexPath) {
        newLeader.getLeaderPositionState()
        guard let previousLeaderCell = self.bandMemberTableView.cellForRow(at: self.indexPathOfLeaderCell) as? BandMemberModifyTableViewCell else { return }
        previousLeaderCell.abandonLeaderPositionState()
        self.updateLeaderPositionIndexPath(indexPath: newLeaderIndexPath)
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
