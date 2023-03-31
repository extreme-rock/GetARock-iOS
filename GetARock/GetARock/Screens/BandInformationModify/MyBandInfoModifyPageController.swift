//
//  MyBandInfoModifyPageController.swift
//  GetARock
//
//  Created by 장지수 on 2023/03/19.
//

import UIKit

final class MyBandInfoModifyPageController: UIViewController {

    //MARK: - Property

    private var isBandInfoModifyTapped: Bool = false

    private var bandInfo: BandInformationVO

    private lazy var bandMemberModifyViewController = BandMemberModifyViewController(navigateDelegate: self, bandData: bandInfo)
    
    private lazy var bandInfoModifyViewController = BandInfoModifyViewController(navigateDelegate: self, bandData: bandInfo)
    
    private lazy var pageViewControllers: [UIViewController] = [
        bandMemberModifyViewController,
        bandInfoModifyViewController
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

    private lazy var dismissButton: UIButton = {
        $0.setImage(ImageLiteral.xmarkSymbol, for: .normal)
        $0.tintColor = .white
        let action = UIAction { [weak self] _ in
            self?.dismissButtonTapped()
        }
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
        let action = UIAction { _ in
            // MARK: 수정된 정보 확정
            Task {
                self.setOriginalBandData()

                self.bandMemberModifyViewController.confirmModifiedMembers()

                //MARK: 밴드 정보뷰가 탭된 경우에만 데이터 업데이트
                if self.isBandInfoModifyTapped {
                    self.bandInfoModifyViewController.confirmModifiedBandInformation()
                }

                print("서버로 보내는 수정 정보 데이터")
                print(BasicDataModel.bandPUTData.name)
                print(BasicDataModel.bandPUTData.address.street)
                print(BasicDataModel.bandPUTData.address.detail)
                print(BasicDataModel.bandPUTData.songList)
                print(BasicDataModel.bandPUTData.introduction)
                print(BasicDataModel.bandPUTData.snsList)

                try await BandInformationNetworkManager().putModifiedBandMemberInformation(data: BasicDataModel.bandPUTData)
            }
            self.showAlertForEditComplete()
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
    }(BasicLabel(contentText: "내 밴드 수정",
        fontStyle: .headline02,
        textColorInfo: .white))

    private lazy var segmentedController: ModifyPageSegmentedControl = {
        $0.addTarget(self,
                     action: #selector(segmentedControlValueChanged(_:)),
                     for: .valueChanged)
        return $0
    }(ModifyPageSegmentedControl(items: ["멤버", "밴드 정보"]))

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

    // init 시에 유저에 대한 정보가 들어와야함
    override func viewDidLoad() {
        super.viewDidLoad()
        attribute()
        setNavigationItem()
        setupLayout()
        setNotification()
    }

    init(bandData: BandInformationVO) {
        self.bandInfo = bandData
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationInlineTitle(title: "밴드 수정")
    }

    //MARK: - Method

    private func attribute() {
        self.view.backgroundColor = .dark01
    }
    
    private func setNavigationItem() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: dismissButton)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: completeButton)
        //TODO: 추후 수정 필요
        setNavigationInlineTitle(title: "밴드 수정")
    }

    private func setNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(toggleBandInfoTapped),
            name: Notification.Name.toggleBandInfoTapped,
            object:nil
        )
    }

    @objc
    private func toggleBandInfoTapped() {
        self.isBandInfoModifyTapped = true
        self.bandInfoModifyViewController.confirmModifiedBandInformation()
    }

    private func dismissButtonTapped() {
        self.dismiss(animated: true)
    }

    private func setupLayout() {

        self.view.addSubview(segmentedController)
        segmentedController.constraint(top: view.safeAreaLayoutGuide.topAnchor,
                                       leading: view.leadingAnchor,
                                       trailing: view.trailingAnchor,
                                       padding: UIEdgeInsets(top: 25, left: 16, bottom: 0, right: 16))
        segmentedController.constraint(.heightAnchor, constant: 50)

        self.view.addSubview(pageViewController.view)
        pageViewController.view.constraint(top: segmentedController.bottomAnchor,
                                           leading: view.leadingAnchor,
                                           bottom: view.bottomAnchor,
                                           trailing: view.trailingAnchor,
                                           padding: UIEdgeInsets(top: 25, left: 0, bottom: 0, right: 0))

    }

    @objc
    private func segmentedControlValueChanged(_ sender: ModifyPageSegmentedControl) {
        currentPageNumber = self.segmentedController.selectedSegmentIndex
    }

    private func setOriginalBandData() {

        let originalData = BandPUTDTO(bandId: bandInfo.bandID,

                                      name: bandInfo.name,

                                      address: Address(city: bandInfo.address.city,
                                                         street: bandInfo.address.street,
                                                         detail: bandInfo.address.detail,
                                                         longitude: bandInfo.address.longitude,
                                                         latitude: bandInfo.address.latitude),

                                      songList: bandInfo.songList?.compactMap({ SongList(name: $0.name, artist: $0.artist, link: $0.link)}),

                                      memberList: bandInfo.memberList.map({ MemberList(memberId: $0.memberID,
                                                                                       name: $0.name,
                                                                                       memberState: $0.memberState,
                                                                                       instrumentList: $0.instrumentList.map({ data in InstrumentList(name: data.name) }))}),
                                      introduction: bandInfo.introduction,

                                      snsList: bandInfo.snsList.map({ SnsList(type: $0.snsType, link: $0.link) }))

        BasicDataModel.bandPUTData = originalData
        print("original data Set")
        print(originalData)
    }
}

// MARK: - UIPageViewControllerDataSource
 extension MyBandInfoModifyPageController: UIPageViewControllerDataSource {

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
 extension MyBandInfoModifyPageController: UIPageViewControllerDelegate {

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

extension MyBandInfoModifyPageController {
    private func showAlertForEditComplete() {
        //TODO: 밴드 데이터 바탕으로 업데이트 해야함
        let alertTitle = "밴드 정보 편집 완료"
        let alertMessage = "새롭게 입력해주신 정보로 밴드 정보가 편집되었어요!"
        let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        let okayActionTitle = "확인"
        alertController.addAction(UIAlertAction(title: okayActionTitle, style: .default, handler: { _ in
            self.dismiss(animated: true)
        }))
        present(alertController, animated: true)
    }
}
