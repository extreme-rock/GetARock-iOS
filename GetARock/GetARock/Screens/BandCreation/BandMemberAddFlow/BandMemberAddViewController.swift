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

final class BandMemberAddViewController: UIViewController {

    private var addedMembers: [SearchedUserInfo] = []

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
    private let nextButton: BottomButton = {
        //TODO: 밴드 정보 POST action 추가 필요
        $0.setTitle("추가", for: .normal)
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
            print("Person print")
            print(cellData)
            cell.configure(data: cellData)

            let deleteAction = UIAction { _ in
                self.addedMembers.removeAll { $0.id == cell.id }
                self.updateSnapShot(with: self.addedMembers)
            }

            cell.deleteButton.addAction(deleteAction, for: .touchUpInside)
            cell.selectionStyle = .none
            print(self.addedMembers)

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
    func passInstrumentData(with data: MemberList) {
//        self.addedMembers.append(data)
    }
}
