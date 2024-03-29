//
//  UserSearchViewController.swift
//  GetARock
//
//  Created by Jisu Jang on 2023/02/16.
//

import UIKit


enum BottomScrollSection: Int {
    case main
}

final class UserSearchViewController: BaseViewController {

    private var tempWidth: CGFloat = 0

    var completion: (_ selectedUsers: [SearchedUserInfo]) -> Void = { selectedUsers in }

    var selectedUsers: [SearchedUserInfo] = []
    
    private var selectedListWithID: [(indexPath: IndexPath, id: String)] = []
    
    private lazy var searchBar: SearchTextField = {
        let searchBar = SearchTextField(placeholder: "닉네임으로 검색")
        searchBar.textField.addTarget(self, action: #selector(searchTextDidChange(_:)), for: .editingChanged)
        return searchBar
    }()

    private lazy var searchResultTable: UITableView = {
        $0.delegate = self
        $0.dataSource = self
        $0.backgroundColor = .dark01
        $0.register(UserSearchTableViewCell.self, forCellReuseIdentifier: UserSearchTableViewCell.classIdentifier)
        $0.allowsMultipleSelection = true
        $0.separatorStyle = .none
        return $0
    }(UITableView())

    private lazy var doneButton: BottomButton = {
        $0.setTitle("완료", for: .normal)
        let action = UIAction { _ in
            self.completion(self.selectedUsers)
            self.navigationController?.popViewController(animated: true)
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

    //MARK: 검색 결과 데이터 초기화
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        SearchedUserListDTO.dataSet.memberList = []
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
            padding: UIEdgeInsets(top: 20, left: 16, bottom: 0, right: 0))

        view.addSubview(searchResultTable)
        searchResultTable.constraint(top: searchBar.bottomAnchor,
                                     leading: view.leadingAnchor,
                                     bottom: selectedUserListScrollView.topAnchor,
                                     trailing: view.trailingAnchor,
                                     padding: UIEdgeInsets(top: 20, left: 16, bottom: 10, right: 16))

    }
}

//MARK: TableView data configuration
extension UserSearchViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //TODO: 추후 데이터 업데이트 이후에 변경 필요
        SearchedUserListDTO.dataSet.memberList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: UserSearchTableViewCell.classIdentifier,
            for: indexPath) as? UserSearchTableViewCell else { return UITableViewCell()}
        cell.configure(data: SearchedUserListDTO.dataSet.memberList[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
}
//MARK: TableView delegate
extension UserSearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }

    //MARK: Cell Select
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        guard let selectedCell = tableView.cellForRow(at: indexPath) as? UserSearchTableViewCell else { return }
        //TODO: 추후 백엔드 데이터 모델 확정 후 이대로 init시 이상없는지 체크 필요
        var data = SearchedUserInfo(memberId: selectedCell.memberId,
                                    name: selectedCell.userNameLabel.text ?? "",
                                    memberState: selectedCell.memberState,
                                    instrumentList: selectedCell.instrument,
                                    gender: selectedCell.genderText(),
                                    age: selectedCell.ageText())
        data.id = selectedCell.id
        selectedUsers.append(data)
        self.selectedListWithID.append((indexPath: indexPath, id: selectedCell.id))
        self.updateSnapShot(with: selectedUsers)
    }

    //MARK: Cell deselect
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let selectedCell = tableView.cellForRow(at: indexPath) as? UserSearchTableViewCell else { return }
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
            
            let deleteAction = UIAction { [weak self] _ in
                //MARK: 하단의 가로 스크롤뷰의 데이터 삭제 및 업데이트
                self?.selectedUsers.removeAll { $0.id == cell.id }
                self?.updateSnapShot(with: self?.selectedUsers ?? [])
                
                //MARK: 하단의 가로 스크롤뷰 삭제로 원래 선택된 셀의 UI 업데이트
                
                self?.selectedListWithID.forEach { element in
                    if cell.id == element.id {
                        self?.selectedListWithID.removeAll { $0 == element }
                        self?.searchResultTable.deselectRow(at: element.indexPath, animated: true)
                    }
                }
            }
            cell.deleteButton.addAction(deleteAction, for: .touchUpInside)
            return cell
        })
    }
}

extension UserSearchViewController {
    @objc func searchTextDidChange(_ sender: Any?) {
        if searchBar.inputText().isEmpty {
            self.searchResultTable.reloadData()
        } else {
            Task {
                let searchedUsers = try await MemberSearchNetworkManager().getSearchedMemberList(with: searchBar.inputText())
                SearchedUserListDTO.dataSet.memberList = searchedUsers
                print("================")
                print(searchedUsers)
                print("================")
                self.searchResultTable.reloadData()
            }
        }
    }
}
