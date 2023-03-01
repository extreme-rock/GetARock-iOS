//
//  BandMemberModifyViewController.swift
//  GetARock
//
//  Created by 장지수 on 2023/03/01.
//

import UIKit


final class BandMemberModifyViewController: BaseViewController {

    private lazy var addedMembers: [SearchedUserInfo] = getTransformedVOData() {
        didSet {
            guard let headerView = self.bandMemberTableView.headerView(forSection: 0) as? BandMemberModifyTableViewHeader else { return }
            headerView.sectionTitle.text = "밴드 멤버 \(addedMembers.count)인"
        }
    }

    //MARK: - View
    private lazy var bandMemberTableView: UITableView = {
        $0.register(BandMemberModifyTableViewCell.self,
                    forCellReuseIdentifier: BandMemberModifyTableViewCell.classIdentifier)
        $0.register(BandMemberModifyTableViewHeader.self,
                    forHeaderFooterViewReuseIdentifier: BandMemberModifyTableViewHeader.classIdentifier)
        $0.sectionHeaderHeight = 310
        $0.separatorStyle = .none
        $0.backgroundColor = .dark01
        $0.delegate = self
        return $0
    }(UITableView())

    private lazy var dataSource: UITableViewDiffableDataSource<BandMemberAddTableViewSection, SearchedUserInfo> = self.makeDataSource()

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
        updateSnapShot(with: addedMembers)
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
        return resultData
    }
}

//MARK: DiffableDataSource 관련 메소드
extension BandMemberModifyViewController {

    func updateSnapShot(with items: [SearchedUserInfo]) {
        var snapShot = NSDiffableDataSourceSnapshot<BandMemberAddTableViewSection, SearchedUserInfo>()
        snapShot.appendSections([.main])
        snapShot.appendItems(items, toSection: .main)
        self.dataSource.apply(snapShot, animatingDifferences: true)
    }

    func makeDataSource() -> UITableViewDiffableDataSource<BandMemberAddTableViewSection, SearchedUserInfo> {
        return UITableViewDiffableDataSource<BandMemberAddTableViewSection, SearchedUserInfo>(tableView: self.bandMemberTableView) { tableView, indexPath, cellData in

            guard let cell = tableView.dequeueReusableCell(withIdentifier: BandMemberModifyTableViewCell.classIdentifier, for: indexPath) as? BandMemberModifyTableViewCell else { return UITableViewCell() }

            cell.configure(data: cellData)
            cell.selectionStyle = .none

            let changeLeaderAction = UIAction { _ in
                cell.leaderButton.tintColor = .systemPurple
                
            }

            cell.leaderButton.addAction(changeLeaderAction, for: .touchUpInside)

            return cell
        }
    }
    
    func showAlertForChangingLeader(newLeader: String) {
        //TODO: 밴드 데이터 바탕으로 업데이트 해야함
        let alertTitle = "리더 권한 양도"
        let alertMessage = "‘\(newLeader)’님에게 밴드 리더 권한을\n양도하겠습니까?\n권한을 양도하면 내 권한은 일반 멤버로 변경됩니다."
        let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)

        let changeAction = NSLocalizedString("양도", comment: "Alert OK button title")
        let okayAction = NSLocalizedString("취소", comment: "Alert Cancel button title")

        alertController.addAction(UIAlertAction(title: okayAction, style: .default))
        alertController.addAction(UIAlertAction(title: changeAction, style: .destructive, handler: { _ in
            //Change Action
        }))
        present(alertController, animated: true)
    }
}

extension BandMemberModifyViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: BandMemberModifyTableViewHeader.classIdentifier) as? BandMemberModifyTableViewHeader else { return UIView() }

        //MARK: 회원 검색 뷰로 이동
        let inviteMemberButtonAction = UIAction { [weak self] _ in
            let nextViewController = UserSearchViewController()
            nextViewController.completion = { selectedUsers in
                for data in selectedUsers {
                    if self?.addedMembers.contains(where: { $0.id == data.id }) == false {
                        self?.addedMembers.append(data)
                    }
                }
                self?.updateSnapShot(with: self?.addedMembers ?? [])
            }
            self?.navigationController?.pushViewController(nextViewController, animated: true)
        }
        headerView.inviteMemberButton.addAction(inviteMemberButtonAction, for: .touchUpInside)
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
