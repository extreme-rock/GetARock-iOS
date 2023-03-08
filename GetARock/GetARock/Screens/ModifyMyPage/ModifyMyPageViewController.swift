//
//  ModifyMyPageViewController.swift
//  GetARock
//
//  Created by 최동권 on 2023/02/13.
//

import UIKit

final class ModifyMyPageViewController: UIViewController {
    
    //MARK: - Property
    
    private var userInfo: User

    private lazy var pageViewControllers: [UIViewController] = [
        ModifyPositionViewController(selectedPositions: self.userInfo.instrumentList),
        ModifyUserProfileViewController(userInfo: self.userInfo)
        ]
    
    private var currentPageNumber: Int = 0 {
        didSet {
            let direction: UIPageViewController.NavigationDirection = oldValue <= self.currentPageNumber ? .forward : .reverse
            
            self.pageViewController.setViewControllers(
                [pageViewControllers[self.currentPageNumber]],
                direction: direction,
                animated: true
            )
        }
    }
    
    //MARK: - View
    
    private lazy var customNavigationBarStackView: UIStackView = {
        $0.backgroundColor = .dark02
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.backgroundColor = .dark01
        return $0
    }(UIStackView(arrangedSubviews: [dismissButton, viewControllerTitleLabel, completeButton]))
    
    private lazy var dismissButton: UIButton = {
        $0.setImage(ImageLiteral.xmarkSymbol, for: .normal)
        $0.tintColor = .white
        let action = UIAction { [weak self] _ in
            self?.dismissButtonTapped()
        }
        $0.addAction(action, for: .touchUpInside)
        $0.addAction(action, for: .touchUpInside)
        $0.setContentHuggingPriority(
            .defaultHigh,
            for: .horizontal
        )
        return $0
    }(UIButton())
    
    private lazy var completeButton: UIButton = {
        $0.setTitle("완료", for: .normal)
        $0.setTitleColor(.blue01, for: .normal)
        $0.titleLabel?.font = .setFont(.headline04)
        let action = UIAction { [weak self] _ in
            self?.completeButtonTapped()
        }
        $0.addAction(action, for: .touchUpInside)
        $0.setContentHuggingPriority(
            .defaultHigh,
            for: .horizontal
        )
        return $0
    }(UIButton())
    
    private let viewControllerTitleLabel: BasicLabel = {
        $0.textAlignment = .center
        return $0
    }(BasicLabel(contentText: "프로필 수정",
        fontStyle: .headline02,
        textColorInfo: .white))
        
    private lazy var segmentedController: ModifyPageSegmentedControl = {
        $0.addTarget(self,
                     action: #selector(segmentedControlValueChanged(_:)),
                     for: .valueChanged)
        return $0
    }(ModifyPageSegmentedControl(items: ["포지션", "내 정보"]))
    
    private lazy var pageViewController: UIPageViewController = {
        if let viewController = pageViewControllers.first {
            $0.setViewControllers([viewController],
                                  direction: .forward,
                                  animated: true)
        }
        $0.dataSource = self
        $0.delegate = self
        return $0
    }(UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal))
    
    //MARK: - Life Cycle
    
    init(userInfo: User) {
        self.userInfo = userInfo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        attribute()
        setupLayout()
    }
    
    //MARK: - Method
    
    private func attribute() {
        self.view.backgroundColor = .dark01
    }
    
    private func dismissButtonTapped() {
        self.dismiss(animated: true)
    }
    
    private func completeButtonTapped() {
        guard let modifyPositionViewController = self.pageViewControllers.first as? ModifyPositionViewController,
              let modifyUserProfileViewController = self.pageViewControllers.last as? ModifyUserProfileViewController else { return }
        
        var modiFiedUserInfo = self.userInfo
        // ModifyUserProfileViewController가 열리지 않으면 상태를 체크할 수 없어서 viewDidLoad를 체크하여, load되지 않았으면 기존 userInfo를 입력하고, load되었다면 현재 입력된 info값을 가져옴
        
        let isModifyUserProfileAllFilled = !modifyUserProfileViewController.isViewLoaded
        || modifyUserProfileViewController.checkCompleteButtonEnabledState()
        let isPositionInfoFilled = modifyPositionViewController.checkCompleteButtonEnabledState()
        let isAllUserInfoFilled = isModifyUserProfileAllFilled && isPositionInfoFilled
        print(isAllUserInfoFilled)
        if isAllUserInfoFilled {
            if !modifyUserProfileViewController.isViewLoaded {
                modiFiedUserInfo.instrumentList = modifyPositionViewController.instrumentList()
            } else {
                guard let userInfo = modifyUserProfileViewController.userInfoWithoutInstrumentList() else { return }
                modiFiedUserInfo = userInfo
                modiFiedUserInfo.instrumentList = modifyPositionViewController.instrumentList()
            }
            
            Task {
                try await SignUpNetworkManager.putUserInformation(user: userInfo, completion: { result in
                    switch result {
                    case .success(_):
                        self.dismiss(animated: true)
                    case .failure(let error):
                        // TODO: error에 따른 대응
                        print(error)
                    }
                })
            }
        }
    }
    
    private func setupLayout() {
        self.view.addSubview(customNavigationBarStackView)
        customNavigationBarStackView.constraint(top: view.safeAreaLayoutGuide.topAnchor,
                                        leading: view.leadingAnchor,
                                        trailing: view.trailingAnchor,
                                        padding: UIEdgeInsets(top: 19, left: 16, bottom: 0, right: 16))
        customNavigationBarStackView.constraint(.heightAnchor, constant: 20)
        
        self.view.addSubview(segmentedController)
        segmentedController.constraint(top: customNavigationBarStackView.bottomAnchor,
                                       leading: view.leadingAnchor,
                                       trailing: view.trailingAnchor,
                                       padding: UIEdgeInsets(top: 25, left: 16, bottom: 0, right: 16))
        segmentedController.constraint(.heightAnchor, constant: 50)

        self.view.addSubview(pageViewController.view)
        pageViewController.view.constraint(top: segmentedController.bottomAnchor,
                                           leading: view.leadingAnchor,
                                           bottom: view.bottomAnchor,
                                           trailing: view.trailingAnchor,
                                           padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        
    }
    
    @objc
    private func segmentedControlValueChanged(_ sender: ModifyPageSegmentedControl) {
        currentPageNumber = self.segmentedController.selectedSegmentIndex
    }
}

// MARK: - UIPageViewControllerDataSource

 extension ModifyMyPageViewController: UIPageViewControllerDataSource {

     func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore
                             viewController: UIViewController) -> UIViewController? {

         guard let index = self.pageViewControllers.firstIndex(of: viewController),
               index - 1 >= 0
         else { return nil }
         return self.pageViewControllers[index - 1]
     }

     func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter
                             viewController: UIViewController) -> UIViewController? {

         guard let index = self.pageViewControllers.firstIndex(of: viewController),
               index + 1 < self.pageViewControllers.count
         else { return nil }
         return self.pageViewControllers[index + 1]
     }
 }

 // MARK: - UIPageViewControllerDelegate

 extension ModifyMyPageViewController: UIPageViewControllerDelegate {

     func pageViewController(_ pageViewController: UIPageViewController,
                             didFinishAnimating finished: Bool,
                             previousViewControllers: [UIViewController],
                             transitionCompleted completed: Bool) {

         guard let viewController = pageViewController.viewControllers?[0],
               let index = self.pageViewControllers.firstIndex(of: viewController)
         else { return }
         self.currentPageNumber = index
         self.segmentedController.selectedSegmentIndex = index
     }
 }

