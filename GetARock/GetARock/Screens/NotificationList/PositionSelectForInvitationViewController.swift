//
//  PositionSelectForInvitationViewController.swift
//  GetARock
//
//  Created by 장지수 on 2023/03/02.
//

import UIKit

final class PositionSelectForInvitationViewController: BaseViewController {
    
    //MARK: - Property

    //TODO: 추후 유저 데이터에서 유저가 가능하다고 응답한 악기들로 대체되어야함.
    private let positions: [Item] = [
        .position(Position(instrumentName: "보컬", instrumentImageName: .vocal, isETC: false)),
        .position(Position(instrumentName: "기타", instrumentImageName: .guitar, isETC: false)),
        .position(Position(instrumentName: "키보드", instrumentImageName: .keyboard, isETC: false)),
        .position(Position(instrumentName: "드럼", instrumentImageName: .drum, isETC: false)),
        .position(Position(instrumentName: "베이스", instrumentImageName: .bass, isETC: false))
    ]
    
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
            alertId: 0,
            bandId: 0,
            memberId: 0,
            memberInstrument: getSelectedInstrumentList(),
            completion: {
                //TODO: 지도 View로 navigate하도록 바꿔야함
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


