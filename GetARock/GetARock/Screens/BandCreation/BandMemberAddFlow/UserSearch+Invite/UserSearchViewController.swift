//
//  UserSearchViewController.swift
//  GetARock
//
//  Created by Jisu Jang on 2023/02/16.
//

import UIKit


//TODO: API 업데이트 되면 TableCell에 선택한 여러 악기가 표기 되게 만들기 
enum BottomScrollSection: Int {
    case main
}

final class UserSearchViewController: BaseViewController {

    private enum Size {
        static let cellHeight: CGFloat = 36
        static let cellContentInset: CGFloat = 50
    }

    private var tempWidth: CGFloat = 0

    var completion: (_ selectedUsers: [SearchedUserInfo]) -> Void = { selectedUsers in }

    var selectedUsers: [SearchedUserInfo] = []

    private lazy var searchBar: SearchTextField = {
        let searchBar = SearchTextField(placeholder: "닉네임으로 검색")
        let action = UIAction { _ in
            if searchBar.textField.text == "" {
                self.searchResultTable.reloadData()
            }
        }
        searchBar.textField.addAction(action, for: .editingChanged)
        return searchBar
    }()

    private lazy var searchResultTable: UITableView = {
        $0.delegate = self
        $0.dataSource = self
        $0.backgroundColor = .dark01
        $0.register(UserSearchTableViewCell.self, forCellReuseIdentifier: UserSearchTableViewCell.classIdentifier)
        $0.allowsMultipleSelection = true
        return $0
    }(UITableView())

    private lazy var doneButton: BottomButton = {
        //TODO: 밴드 정보 POST action 추가 필요
        $0.setTitle("완료", for: .normal)
        let action = UIAction { _ in
            self.dismiss(animated: true){
                self.completion(self.selectedUsers)
            }
        }
        $0.addAction(action, for: .touchUpInside)
        return $0
    }(BottomButton())

    private lazy var selectedUserListScrollView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .dark01
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.register(
            AddedBandMemberCell.self,
            forCellWithReuseIdentifier: AddedBandMemberCell.classIdentifier)
        return collectionView
    }()

    //MARK: Bottom CollectionView
    private lazy var bottomScrollViewDataSource: UICollectionViewDiffableDataSource<BottomScrollSection, SearchedUserInfo> = self.makeDataSource()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        updateSnapShot(with: selectedUsers)
    }

    private func setupLayout() {
        view.addSubview(searchBar)
        searchBar.constraint(top: view.safeAreaLayoutGuide.topAnchor,
                             leading: view.leadingAnchor,
                             trailing: view.trailingAnchor,
                             padding: UIEdgeInsets(top: 20, left: 25, bottom: 0, right: 25))

        view.addSubview(doneButton)
        doneButton.constraint(leading: view.leadingAnchor,
                              bottom: view.safeAreaLayoutGuide.bottomAnchor,
                              trailing: view.trailingAnchor,
                              padding: UIEdgeInsets(top: 20, left: 16, bottom: 20, right: 16))

        view.addSubview(selectedUserListScrollView)
        selectedUserListScrollView.constraint(.heightAnchor, constant: 80)
        selectedUserListScrollView.constraint(
            leading: view.safeAreaLayoutGuide.leadingAnchor,
            bottom: doneButton.topAnchor,
            trailing: view.safeAreaLayoutGuide.trailingAnchor,
            padding: UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0))

        view.addSubview(searchResultTable)
        searchResultTable.constraint(top: searchBar.bottomAnchor,
                                     leading: view.leadingAnchor,
                                     bottom: selectedUserListScrollView.topAnchor,
                                     trailing: view.trailingAnchor,
                                     padding: UIEdgeInsets(top: 20, left: 25, bottom: 10, right: 25))

    }
}

//MARK: TableView data configuration
extension UserSearchViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        SearchedUserListDTO.testData.memberList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: UserSearchTableViewCell.classIdentifier,
            for: indexPath) as? UserSearchTableViewCell else { return UITableViewCell()}
        cell.configure(data: SearchedUserListDTO.testData.memberList[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
}
//MARK: TableView delegate
extension UserSearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let selectedCell = tableView.cellForRow(at: indexPath) as! UserSearchTableViewCell
        // 선택된 tableView의 데이터만 따로 추출
        // 선택된 셀에 접근할 수 있으나 데이터는 따로 만들어야함
        // CellInformation만들 때 임의의 id를 만들기 때문에, 만들고나서 선택한 cell의 id를 주입해줘야함
        var data = SearchedUserInfo(memberId: 0,
                               name: selectedCell.userNameLabel.text ?? "",
                                    memberState: .none,
                              instrumentList: [SearchedUserInstrumentList(
                                instrumentId: 0,
                                isMain: true,
                                name: selectedCell.userInstrumentLabel.text ?? "")], gender: "MEN", age: "TWENTIES")
        // 선택될 때 Cell의 아이디 그대로 데이터에 넣기
        data.id = selectedCell.id
        //MARK: 이미 배열에 들어가있는 셀 없애기
        //TODO: 함수로 따로 빼서 만들기
        selectedUsers.append(data)
        selectedCell.isChecked = true
        self.updateSnapShot(with: selectedUsers)
    }

    //MARK: Deselect Function
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let selectedCell = tableView.cellForRow(at: indexPath) as! UserSearchTableViewCell
        selectedCell.isChecked = false
        selectedUsers.removeAll { $0.id == selectedCell.id }
        self.updateSnapShot(with: selectedUsers)
    }
}

extension UserSearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //MARK: 동적 셀 크기 배정 코드
         let leadingTrailingInset: CGFloat = 60
         let cellHeight: CGFloat = 50
         
        let nameText = selectedUsers[indexPath.row].name
         let size: CGSize = .init(width: collectionView.frame.width, height: cellHeight)
         let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .regular)]
         
         let estimatedFrame = nameText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
         let cellWidth: CGFloat = estimatedFrame.width + leadingTrailingInset
         
         return CGSize(width: cellWidth, height: cellHeight)
    }
}

//MARK: SelectedUserScollView DiffableData Source
extension UserSearchViewController {

    func updateSnapShot(with items: [SearchedUserInfo]) {
        var snapShot = NSDiffableDataSourceSnapshot<BottomScrollSection, SearchedUserInfo>()
        snapShot.appendSections([.main])
        snapShot.appendItems(items, toSection: .main)
        self.bottomScrollViewDataSource.apply(snapShot, animatingDifferences: true)
    }

    func makeDataSource() -> UICollectionViewDiffableDataSource<BottomScrollSection, SearchedUserInfo> {
        return UICollectionViewDiffableDataSource<BottomScrollSection, SearchedUserInfo>(collectionView: self.selectedUserListScrollView, cellProvider: { collectionView, indexPath, person in

            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddedBandMemberCell.classIdentifier, for: indexPath) as? AddedBandMemberCell else { return UICollectionViewCell() }

            cell.configure(data: person)

            let deleteAction = UIAction { _ in
                self.selectedUsers.removeAll { $0.id == cell.id }
                self.updateSnapShot(with: self.selectedUsers)

                //TODO: Deselect 로직 수정 필요. 애초에 선택된 애들만 없앨 수 있게
                for index in 0..<SearchedUserListDTO.testData.memberList.count {
                    let searchResultTablecell = self.searchResultTable.cellForRow(at: IndexPath(row: index, section: 0)) as! UserSearchTableViewCell
                    if searchResultTablecell.id == cell.id {
                        searchResultTablecell.isChecked = false
                    }
                }
            }
            cell.deleteButton.addAction(deleteAction, for: .touchUpInside)
            return cell
        })
    }
}
