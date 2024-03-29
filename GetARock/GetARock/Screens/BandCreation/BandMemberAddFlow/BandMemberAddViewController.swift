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

    private var addedMembers: [SearchedUserInfo] = [] {
        didSet {
            guard let headerView = self.bandMemberTableView.headerView(forSection: 0) as? BandMemberAddTableViewHeader else { return }
            headerView.sectionTitle.text = "밴드 멤버 \(addedMembers.count)인"
        }
    }

    //MARK: - View
    private lazy var bandMemberTableView: UITableView = {
        $0.register(BandMemberAddTableViewCell.self,
                    forCellReuseIdentifier: BandMemberAddTableViewCell.classIdentifier)
        $0.register(BandMemberAddTableViewHeader.self,
                    forHeaderFooterViewReuseIdentifier: BandMemberAddTableViewHeader.classIdentifier)
        $0.sectionHeaderHeight = 310
        $0.separatorStyle = .none
        $0.backgroundColor = .dark01
        $0.delegate = self
        return $0
    }(UITableView(frame: .zero, style: .grouped))

    private lazy var dataSource: UITableViewDiffableDataSource<BandMemberAddTableViewSection, SearchedUserInfo> = self.makeDataSource()

    private lazy var nextButton: BottomButton = {
        let action = UIAction { _ in
            self.confirmBandMemberList()
            self.navigationController?.pushViewController(BandInformationSetViewController(), animated: true)
        }
        $0.setTitle("다음", for: .normal)
        $0.addAction(action, for: .touchUpInside)
        return $0
    }(BottomButton())

    //MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        attribute()
        setupLayout()
    }

    // View가 나타나기전 추가된 멤버 정보 업데이트
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateSnapShot(with: self.addedMembers)
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
                                  right: 0))

        view.addSubview(nextButton)
        nextButton.constraint(
            bottom: view.safeAreaLayoutGuide.bottomAnchor,
            centerX: view.centerXAnchor,
            padding: UIEdgeInsets(top: 0,
                                  left: 0,
                                  bottom: 16,
                                  right: 16))
    }

    private func attribute() {
        view.backgroundColor = .dark01
        configureAdminCell()
    }

    private func configureAdminCell() {
        Task {
            guard let admin = await UserInfoNetworkManager.shared.fetchUserData(with: UserDefaultStorage.memberID) else { return }
            let transformedInstruments: [SearchedUserInstrumentList] = admin.instrumentList.map {
                SearchedUserInstrumentList(instrumentId: 0,
                                           isMain: false,
                                           name: $0.name)
            }
            let bandAdminData: SearchedUserInfo = SearchedUserInfo(
                memberId: admin.userID,
                name: admin.name,
                memberState: .admin,
                instrumentList: transformedInstruments,
                gender: Gender.CodingKeys(rawValue: admin.gender)?.inKorean ?? "",
                age: Age.CodingKeys(rawValue: admin.age)?.inKorean ?? "")
            addedMembers.append(bandAdminData)
            updateSnapShot(with: addedMembers)
        }
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
        return UITableViewDiffableDataSource<BandMemberAddTableViewSection, SearchedUserInfo>(tableView: self.bandMemberTableView) { tableView, indexPath, cellData in

            guard let cell = tableView.dequeueReusableCell(withIdentifier: BandMemberAddTableViewCell.classIdentifier, for: indexPath) as? BandMemberAddTableViewCell else { return UITableViewCell() }

            cell.configure(data: cellData)
            cell.selectionStyle = .none
            if cellData.memberState == .admin {
                cell.deleteButton.isHidden = true
            }

            let deleteAction = UIAction { _ in
                self.addedMembers.removeAll { $0.id == cell.id }
                self.updateSnapShot(with: self.addedMembers)
            }

            cell.deleteButton.addAction(deleteAction, for: .touchUpInside)

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
        let inviteMemberButtonAction = UIAction { [weak self] _ in
            let nextViewController = UserSearchViewController()
            nextViewController.completion = { selectedUsers in
                for data in selectedUsers {
                    if self?.addedMembers.contains(where: { $0.id == data.id }) == false {
                        self?.addedMembers.append(data)
                    }
                }
            }
            self?.navigationController?.pushViewController(nextViewController, animated: true)
        }
        headerView.inviteMemberButton.addAction(inviteMemberButtonAction, for: .touchUpInside)
        
        //MARK: 미가입 멤버 추가 뷰로 이동
        let unRegisteredMemberButtonAction = UIAction { _ in
            let nextViewController = AddUnRegisteredMemberViewController()
            nextViewController.completion = { newAddedMembers in
                self.addedMembers = self.addedMembers + newAddedMembers
            }
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }
        headerView.inviteUnRegisteredMemberButton.addAction(unRegisteredMemberButtonAction, for: .touchUpInside)
        
        return headerView
    }
}

extension BandMemberAddViewController {
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
        print("+++++++++++++++++++++++++++++=")
        print(confirmedMembers)
        BasicDataModel.bandCreationData.memberList = confirmedMembers
    }
}
