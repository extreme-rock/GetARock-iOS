//
//  DeleteBandViewController.swift
//  GetARock
//
//  Created by 최동권 on 2023/03/22.
//

import UIKit

protocol DeleteBandViewControllerDelegate: AnyObject {
    func didDeleteBandButtonTapped()
}

final class DeleteBandViewController: UIViewController {
    
    // MARK: - Property

    private let bandData: BandInformationVO
    weak var delegate: DeleteBandViewControllerDelegate?
    
    // MARK: - View
    
    private lazy var titleLabel: BasicLabel = {
        $0.numberOfLines = 0
        return $0
    }(BasicLabel(contentText: "\(self.bandData.name)을(를)\n해체 하시겠습니까?",
                 fontStyle: .largeTitle01,
                 textColorInfo: .white))
    
    private let subTitleLabel = BasicLabel(contentText: "삭제 전 주의사항을 확인해주세요.",
                                           fontStyle: .headline03,
                                           textColorInfo: .lightGray)
    
    private lazy var precautionContentStackView: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 18
        $0.backgroundColor = .dark02
        $0.layer.cornerRadius = 10
        $0.isLayoutMarginsRelativeArrangement = true
        $0.layoutMargins = .init(top: 20, left: 16, bottom: 20, right: 16)
        return $0
    }(UIStackView(arrangedSubviews: [precautionTitleStackView, precautionContentLabel1, precautionContentLabel2]))
    
    private lazy var precautionTitleStackView: UIStackView = {
        $0.axis = .horizontal
        $0.spacing = 5
        return $0
    }(UIStackView(arrangedSubviews: [precautionImageView, precautionTitleLabel]))
    
    private let precautionImageView: UIImageView = {
        $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        $0.tintColor = .white
        return $0
    }(UIImageView(image: ImageLiteral.infoCircleSymbol))
    
    private let precautionTitleLabel = BasicLabel(contentText: "밴드 삭제 시 주의사항",
                                                  fontStyle: .contentLight,
                                                  textColorInfo: .white)
    
    private let precautionContentLabel1: BasicLabel = {
        $0.addLabelSpacing(lineSpacing: 10)
        $0.numberOfLines = 2
        return $0
    }(BasicLabel(contentText: "* 밴드 정보, 하고싶은 말 등 밴드의 모든 활동 정보가 삭제 되며, 삭제된 데이터는 복구할 수 없어요",
                 fontStyle: .contentLight,
                 textColorInfo: .white))
    
    private let precautionContentLabel2: BasicLabel = {
        $0.addLabelSpacing(lineSpacing: 10)
        $0.numberOfLines = 2
        return $0
    }(BasicLabel(contentText: "* 밴드의 리더를 바꾸면 지금의 밴드는 계속 이어갈 수 있어요.",
                 fontStyle: .contentLight,
                 textColorInfo: .white))
    
    private lazy var deleteButton: UIButton = {
        $0.setTitle("삭제하기", for: .normal)
        $0.titleLabel?.font = .setFont(.headline02)
        $0.backgroundColor = .dark03
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 10
        let action = UIAction { [weak self] _ in
            self?.showDeleteAlertView()
        }
        $0.addAction(action, for: .touchUpInside)
        return $0
    }(UIButton())

    // MARK: - Init
    init(bandData: BandInformationVO) {
        self.bandData = bandData
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        attribute()
    }
    
    // MARK: - Method
    
    private func attribute() {
        self.view.backgroundColor = .dark01
    }
    
    private func setupLayout() {
        self.view.addSubview(titleLabel)
        titleLabel.constraint(top: self.view.safeAreaLayoutGuide.topAnchor,
                              leading: self.view.leadingAnchor,
                              trailing: self.view.trailingAnchor,
                              padding: UIEdgeInsets(top: 45, left: 16, bottom: 0, right: 16))
        
        self.view.addSubview(subTitleLabel)
        subTitleLabel.constraint(top: self.titleLabel.bottomAnchor,
                                 leading: self.view.leadingAnchor,
                                 trailing: self.view.trailingAnchor,
                                 padding: UIEdgeInsets(top: 10, left: 16, bottom: 0, right: 16))
        
        self.view.addSubview(precautionContentStackView)
        precautionContentStackView.constraint(top: self.subTitleLabel.bottomAnchor,
                                              leading: self.view.leadingAnchor,
                                              trailing: self.view.trailingAnchor,
                                              padding: UIEdgeInsets(top: 30, left: 16, bottom: 0, right: 16))
        
        self.view.addSubview(deleteButton)
        deleteButton.constraint(leading: self.view.leadingAnchor,
                                bottom: self.view.safeAreaLayoutGuide.bottomAnchor,
                                trailing: self.view.trailingAnchor,
                                padding: UIEdgeInsets(top: 0, left: 16, bottom: 30, right: 16))
        deleteButton.constraint(.heightAnchor, constant: 60)
    }
    
    private func showDeleteAlertView() {
        let alert = UIAlertController(title: "밴드 해체",
                                      message: "밴드가 영구적으로 삭제됩니다.",
                                      preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        let deleteAction = UIAlertAction(title: "해체", style: .destructive) { (action) -> Void in
            self.delegate?.didDeleteBandButtonTapped()
            do {
                try BandNetworkManager.shared.deleteBand(with: self.bandData.bandID)
            } catch {
                // TODO: handle error
            }
        }
            
        [cancelAction, deleteAction].forEach {
            alert.addAction($0)
        }
        
        self.present(alert, animated: true)
    }
}
