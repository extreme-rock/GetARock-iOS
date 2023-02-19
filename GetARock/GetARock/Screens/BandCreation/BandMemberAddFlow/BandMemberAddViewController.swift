//
//  BandMemberAddViewController.swift
//  GetARock
//
//  Created by 장지수 on 2023/02/13.
//

import UIKit

//DiffableDataSource 생성용 Section
enum BandMemberAddTableViewSection: String {
    case main
}

final class BandMemberAddViewController: BaseViewController {

    var addedMembers: [SearchedUserInfo] = []

    //MARK: - View
    private lazy var tableView: UITableView = {
        $0.register(BandMemberAddTableViewCell.self,
                    forCellReuseIdentifier: BandMemberAddTableViewCell.classIdentifier)
        $0.register(BandMemberAddTableViewHeader.self,
                    forHeaderFooterViewReuseIdentifier: BandMemberAddTableViewHeader.classIdentifier)
        $0.sectionHeaderHeight = 310
        $0.backgroundColor = .dark01
        $0.delegate = self
        return $0
    }(UITableView(frame: .zero, style: .grouped))

    private lazy var dataSource: UITableViewDiffableDataSource<BandMemberAddTableViewSection, SearchedUserInfo> = self.makeDataSource()

    //TODO: Develop Pull 후 비슷한 옵션 추가
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
    }

    //MARK: - Method

    private func setupLayout() {
        view.addSubview(tableView)
        tableView.constraint(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: UIEdgeInsets(top: 20, left: 16, bottom: 100, right: 16))

        view.addSubview(nextButton)
        nextButton.constraint(
            bottom: view.safeAreaLayoutGuide.bottomAnchor,
            centerX: view.centerXAnchor,
            padding: UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0))
    }

    private func attribute() {
        view.backgroundColor = .dark01
        configureAdminCell()
    }

    private func configureAdminCell() {
        guard let admin: MemberList = BasicDataModel.bandCreationData.memberList.first else { return }
        //MARK: 성별과 나이 정보는 추후 개인 유저 정보를 바탕으로 업데이트 해야함
        let transformedInstruments: [SearchedUserInstrumentList] = admin.instrumentList.map { SearchedUserInstrumentList(instrumentId: 0, isMain: false, name: $0.name)
        }
        let initialData: SearchedUserInfo = SearchedUserInfo(memberId: admin.memberId ?? -1, name: admin.name, memberState: admin.memberState, instrumentList: transformedInstruments, gender: "MEN", age: "20대")
        addedMembers.append(initialData)
        updateSnapShot(with: addedMembers)
    }
}

//MARK: DiffableDataSource 관련 메소드
extension BandMemberAddViewController {

    func updateSnapShot(with items: [SearchedUserInfo]) {
        var snapShot = NSDiffableDataSourceSnapshot<BandMemberAddTableViewSection, SearchedUserInfo>()
        snapShot.appendSections([.main])
        snapShot.appendItems(items, toSection: .main)
        self.dataSource.apply(snapShot, animatingDifferences: true)
    }

    func makeDataSource() -> UITableViewDiffableDataSource<BandMemberAddTableViewSection, SearchedUserInfo> {
        return UITableViewDiffableDataSource<BandMemberAddTableViewSection, SearchedUserInfo>(tableView: self.tableView) { tableView, indexPath, cellData in

            guard let cell = tableView.dequeueReusableCell(withIdentifier: BandMemberAddTableViewCell.classIdentifier, for: indexPath) as? BandMemberAddTableViewCell else { return UITableViewCell() }

            cell.configure(data: cellData)

            let deleteAction = UIAction { _ in
                self.addedMembers.removeAll { $0.id == cell.id }
                self.updateSnapShot(with: self.addedMembers)
            }

            cell.deleteButton.addAction(deleteAction, for: .touchUpInside)
            cell.selectionStyle = .none

            if cellData.memberState == .admin {
                cell.deleteButton.isHidden = true
            }

            return cell
        }
    }
}

extension BandMemberAddViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: BandMemberAddTableViewHeader.classIdentifier) as? BandMemberAddTableViewHeader else { return UIView() }

        //MARK: 회원 검색 뷰로 이동
        let inviteMemberButtonAction = UIAction { _ in
            let nextViewController = UserSearchViewController()
            nextViewController.completion = { selectedUsers in
                for data in selectedUsers {
                    if self.addedMembers.contains(where: { $0.id == data.id }) == false {
                        self.addedMembers.append(data)
                    }
                }
                self.updateSnapShot(with: self.addedMembers)
            }
            self.present(nextViewController, animated: true)
        }

        //TODO: 헤더뷰 내용물 캡슐화 필요
        headerView.inviteMemberButton.addAction(inviteMemberButtonAction, for: .touchUpInside)

        let unRegisteredMemberButtonAction = UIAction { _ in
            let nextVC = AddUnRegisteredMemberViewController()
            nextVC.completion = { addedMembers in
                self.addedMembers = self.addedMembers + addedMembers
                self.updateSnapShot(with: self.addedMembers)
            }
            self.present(nextVC, animated: true)
        }

        //TODO: 헤더뷰 내용물 캡슐화 필요
        headerView.inviteUnRegisteredMemberButton.addAction(unRegisteredMemberButtonAction, for: .touchUpInside)
      return headerView
    }
}

extension BandMemberAddViewController {
    func confirmBandMemberList() {
        var confirmedMembers: [MemberList] = []
        self.addedMembers.forEach {

            let instrumentList: [InstrumentList] = $0.instrumentList.map { InstrumentList(name: $0.name) }

            let individualMember: MemberList = MemberList(memberId: $0.memberId, name: $0.name, memberState: $0.memberState, instrumentList: instrumentList)

            confirmedMembers.append(individualMember)
        }
        BasicDataModel.bandCreationData.memberList = confirmedMembers
    }
}
