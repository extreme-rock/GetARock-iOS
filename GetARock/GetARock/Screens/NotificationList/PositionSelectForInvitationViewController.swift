//
//  PositionSelectForInvitationViewController.swift
//  GetARock
//
//  Created by 장지수 on 2023/03/02.
//

import UIKit

final class PositionSelectForInvitationViewController: BaseViewController {
    
    //MARK: - Property

    private let notification: NotificationInfo

    private let positions: [Item]
    
    //MARK: - View
    
    private lazy var positionCollectionView: PositionCollectionView = PositionCollectionView(
        cellType: .position,
        items: positions,
        isNeedHeader: true,
        headerView: LeaderPositionSelectHeaderView()
    )
    
    private lazy var confirmSignUpButton: BottomButton = {
        $0.setTitle("가입하기", for: .normal)
        $0.isEnabled = false
        let action = UIAction { [weak self] _ in self?.navigateToNext() }
        $0.addAction(action, for: .touchUpInside)
        return $0
    }(BottomButton())
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        attribute()
        configureDelegate()
        setObserver()
    }

    init(notificationInfo: NotificationInfo, positions: [Item]) {
        self.notification = notificationInfo
        self.positions = positions
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: - Method
    
    private func attribute() {
        self.view.backgroundColor = .dark01
    }
    
    private func configureDelegate() {
        positionCollectionView.delegate = self
    }
    
    private func setObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(setButtonEnableState),
            name: Notification.Name.didTapPositionItem,
            object: nil
        )
    }
    
    @objc private func setButtonEnableState() {
        if positionCollectionView.getSelectedInstruments().count > 0 {
            confirmSignUpButton.isEnabled = true
        } else {
            confirmSignUpButton.isEnabled = false
        }
    }
    
    private func setupLayout() {
        self.view.addSubview(positionCollectionView)
        self.view.addSubview(confirmSignUpButton)
        
        positionCollectionView.constraint(top: view.safeAreaLayoutGuide.topAnchor,
                                          leading: view.leadingAnchor,
                                          bottom: confirmSignUpButton.topAnchor,
                                          trailing: view.trailingAnchor,
                                          padding: UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16))
        
        
        confirmSignUpButton.constraint(bottom: view.bottomAnchor,
                              centerX: view.centerXAnchor,
                              padding: UIEdgeInsets(top: 0, left: 0, bottom: 42, right: 0))
    }
}

extension PositionSelectForInvitationViewController {
    private func getSelectedInstrumentList() -> [String] {
        let selectedInstruments: [InstrumentList] = self.positionCollectionView.getSelectedInstruments()
        return selectedInstruments.map { $0.name }
    }
    
    private func navigateToNext() {
        //TODO: 추후 유저 정보에 따른 쿼리 컴포넌트 변경 필요 + 실패할경우 completion 처리 필요
        NotificationNetworkManager.shared.acceptInvitation(
            alertId: notification.alertID,
            bandId: notification.bandID!,
            memberId: UserDefaultStorage.memberID,
            memberInstrument: getSelectedInstrumentList(),
            completion: {
                self.navigationController?.pushViewController(MainMapViewController(isFromSignUp: false), animated: true)
            })
    }
}

//MARK: 포지션 최대 선택 개수 제한
extension PositionSelectForInvitationViewController: PositionCollectionViewDelegate {
    func canSelectPosition(_ collectionView: UICollectionView, indexPath: IndexPath, selectedItemsCount: Int) -> Bool {
        if selectedItemsCount > 1 { return false }
        return true
    }
}


