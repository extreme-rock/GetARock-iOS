//
//  BandMemberModifyViewController.swift
//  GetARock
//
//  Created by 장지수 on 2023/03/01.
//

import UIKit

enum BandMemberModifyTableViewSection: String {
    case confirmedMembers
    case invitingMembers
}

final class BandMemberModifyViewController: BaseViewController {
    
    private lazy var addedMembers: [SearchedUserInfo] = getTransformedVOData().filter { $0.memberState != .inviting } {
        didSet {
            guard let headerView = self.bandMemberTableView.headerView(forSection: 0) as? BandMemberModifyTableViewHeader else { return }
            headerView.sectionTitle.text = "밴드 멤버 (\(addedMembers.count)인)"
        }
    }
    
    private lazy var invitingMembers: [SearchedUserInfo] = getTransformedVOData().filter { $0.memberState == .inviting }

    //MARK: - View
    private lazy var bandMemberTableView: UITableView = {
        $0.register(BandMemberModifyTableViewCell.self,
                    forCellReuseIdentifier: BandMemberModifyTableViewCell.classIdentifier)
        $0.register(BandMemberModifyTableViewHeader.self,
                    forHeaderFooterViewReuseIdentifier: BandMemberModifyTableViewHeader.classIdentifier)
        $0.separatorStyle = .none
        $0.backgroundColor = .dark01
        $0.delegate = self
        return $0
    }(UITableView())
    
    private var indexPathOfLeaderCell: IndexPath = IndexPath(row: 0, section: 0)

    private lazy var dataSource: UITableViewDiffableDataSource<BandMemberModifyTableViewSection, SearchedUserInfo> = self.makeDataSource()

    private lazy var nextButton: BottomButton = {
        let action = UIAction { _ in
            self.confirmBandMemberList()
        }
        $0.setTitle("추가", for: .normal)
        $0.addAction(action, for: .touchUpInside)
        return $0
    }(BottomButton())

    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        attribute()
        setupLayout()
        updateSnapShot(addedMembers: self.addedMembers, invitingMembers: self.invitingMembers)
    }

    //MARK: - Method

    private func setupLayout() {
        view.addSubview(bandMemberTableView)
        bandMemberTableView.constraint(
            top: view.safeAreaLayoutGuide.topAnchor,
            leading: view.safeAreaLayoutGuide.leadingAnchor,
            bottom: view.safeAreaLayoutGuide.bottomAnchor,
            trailing: view.safeAreaLayoutGuide.trailingAnchor,
            padding: UIEdgeInsets(top: 20,
                                  left: 16,
                                  bottom: 100,
                                  right: 16))

        view.addSubview(nextButton)
        nextButton.constraint(
            bottom: view.safeAreaLayoutGuide.bottomAnchor,
            centerX: view.centerXAnchor,
            padding: UIEdgeInsets(top: 0,
                                  left: 0,
                                  bottom: 16,
                                  right: 0))
    }

    private func attribute() {
        view.backgroundColor = .dark01
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
        return orderVOData(with: resultData)
    }
    
    private func orderVOData(with data: [SearchedUserInfo]) -> [SearchedUserInfo] {
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
    
    //MARK: escaping 클로저는 함수가 리턴된 이후에 실행된 클로저임
    //그런데 일반 클로저는 함수의 수행 구문 내에 종속되기 때문에 (함수가 리턴되면 클로저는 없어짐) 이스케이핑 클로저는 이스케이핑 클로저만 참조할 수 잇다
    //그래서 작성하게 됨
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

            let changeLeaderAction = UIAction { [weak self] _ in
                self?.showAlertForChangingLeader(newLeader: cell.nameText()) {
                    cell.getLeaderPositionState()
                    guard let previousLeaderCell = self?.bandMemberTableView.cellForRow(at: self?.indexPathOfLeaderCell ?? IndexPath(row: 0, section: 0)) as? BandMemberModifyTableViewCell else { return }
                    previousLeaderCell.abandonLeaderPositionState()
                    self?.updateLeaderPositionIndexPath(indexPath: indexPath)
                    //TODO: Post할 정보에서 리더 정보 바꾸기 필요
                }
            }

            cell.leaderButton.addAction(changeLeaderAction, for: .touchUpInside)
            return cell
        }
    }
}

extension BandMemberModifyViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var headerView: UIView = UIView()
        
        let sectionIdentifier = dataSource.snapshot().sectionIdentifiers[section]
        
        if sectionIdentifier == .confirmedMembers {
            guard let addedMemberTableHeader = tableView.dequeueReusableHeaderFooterView(
                withIdentifier: BandMemberModifyTableViewHeader.classIdentifier) as? BandMemberModifyTableViewHeader else { return UIView() }
            addedMemberTableHeader.sectionTitle.text = "밴드 멤버 (\(addedMembers.count)인)"

            //MARK: 회원 검색 뷰로 이동
            let inviteMemberButtonAction = UIAction { [weak self] _ in
                let nextViewController = UserSearchViewController()
                nextViewController.completion = { selectedUsers in
                    for data in selectedUsers {
                        if self?.addedMembers.contains(where: { $0.id == data.id }) == false {
                            self?.addedMembers.append(data)
                        }
                    }
                    self?.updateSnapShot(addedMembers: self?.addedMembers ?? [], invitingMembers: self?.invitingMembers ?? [])
                }
                self?.navigationController?.pushViewController(nextViewController, animated: true)
            }
            addedMemberTableHeader.inviteMemberButton.addAction(inviteMemberButtonAction, for: .touchUpInside)
            headerView = addedMemberTableHeader
            
        } else if sectionIdentifier == .invitingMembers {
            let sectionTitle: BasicLabel = BasicLabel(contentText: "초대중인 멤버 (\(invitingMembers.count)인)",
                                          fontStyle: .content,
                                          textColorInfo: .white)
            headerView = sectionTitle
        }
        //TODO: 미가입 회원추가 관련 코드 작성 예정
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

