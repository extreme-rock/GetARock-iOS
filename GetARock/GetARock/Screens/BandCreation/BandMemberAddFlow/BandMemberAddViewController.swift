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

    private var addedMembers: [MemberList] = []

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

    private lazy var dataSource: UITableViewDiffableDataSource<BandMemberAddTableViewSection, MemberList> = self.makeDataSource()

    //TODO: Default 버튼 사용해서 바꿔야함
    private let nextButton = BasicButton(text: "다음", widthPadding: 300, heightPadding: 35)

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
        nextButton.constraint(leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 20))
    }

    private func attribute() {
        view.backgroundColor = .dark01
    }
}

//MARK: DiffableDataSource 관련 메소드
extension BandMemberAddViewController {

    func updateSnapShot(with items: [MemberList]) {
        var snapShot = NSDiffableDataSourceSnapshot<BandMemberAddTableViewSection, MemberList>()
        snapShot.appendSections([.main])
        snapShot.appendItems(items, toSection: .main)
        self.dataSource.apply(snapShot, animatingDifferences: true)
    }

    func makeDataSource() -> UITableViewDiffableDataSource<BandMemberAddTableViewSection, MemberList> {
        return UITableViewDiffableDataSource<BandMemberAddTableViewSection, MemberList>(tableView: self.tableView) { tableView, indexPath, cellData in

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

//MARK: Identifier에 따른 정수형 index 추출 extension
//extension Array where Element == CellInformation {
//    func cellIndex(with id: CellInformation.ID) -> Self.Index {
//        guard let index = firstIndex(where: { $0.id == id }) else { return 0 }
//        return index
//    }
//}
