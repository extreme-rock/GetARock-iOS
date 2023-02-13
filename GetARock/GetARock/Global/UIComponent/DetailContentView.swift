//
//  DetailContentView.swift
//  GetARock
//
//  Created by Yu ahyeon on 2023/02/13.
//

import UIKit

class DetailContentView: UIView {
    
    // MARK: - Property
    enum DetailTopInfoType {
         case band
         case event
         case myPage
     }
    
    private lazy var SegmentTitle: [String] = {
        switch detailtopInfoType {
        case .band:
            return ["밴드상세", "타임라인", "방명록"]
        case .event:
            return ["모여락상세", "댓글"]
        case .myPage:
            return ["프로필", "타임라인", "방명록"]
        }
    }()
    
    private var detailtopInfoType : DetailTopInfoType
    
    var currentPage: Int = 0 {
        didSet {
            let direction: UIPageViewController.NavigationDirection = oldValue <= self.currentPage ? .forward : .reverse
            self.pageViewController.setViewControllers(
                [dataViewControllers[self.currentPage]],
                direction: direction,
                animated: true,
                completion: nil
            )
        }
    }
    
    // MARK: - View
    
    private lazy var segmentedControl: InformationPageSegmentedControl = {
        $0.addTarget(self, action: #selector(changeValue(control:)), for: .valueChanged)
        $0.selectedSegmentIndex = 0
        return $0
    }(InformationPageSegmentedControl(items: SegmentTitle))
    
    var dataViewControllers: [UIViewController] = []
    

    
    
    private lazy var pageViewController: UIPageViewController = {
        $0.delegate = self
        $0.dataSource = self
        $0.view.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil))
    
    
    
    // MARK: - Init
    
    init(type: DetailTopInfoType) {
        self.detailtopInfoType = type
        super.init(frame: .zero)
        setupLayout()
        attribute()
        setDetailViewController()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Method
    
    private func attribute() {
        self.backgroundColor = .dark01
    }
    
    private func setupLayout() {
        
        self.addSubview(self.segmentedControl)
        self.segmentedControl.constraint(top: self.topAnchor,
                                             leading: self.leadingAnchor,
                                             trailing: self.trailingAnchor,
                                             padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        segmentedControl.constraint(.heightAnchor, constant: 60)
        
        self.addSubview(self.pageViewController.view)
        self.pageViewController.view.constraint(top:segmentedControl.bottomAnchor,
                                                leading: self.leadingAnchor,
                                                bottom: self.bottomAnchor,
                                                trailing: self.trailingAnchor,
                                                padding: UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0))
    }
    
    @objc
    private func changeValue(control: UISegmentedControl) {
        self.currentPage = control.selectedSegmentIndex
    }
    
        private func setDetailViewController() {
            switch detailtopInfoType {
            case .band:
                
                //임시 View들입니다..! 추후 삭제예쩡
               let vc1: UIViewController = {
                   $0.view.backgroundColor = .red
                   return $0
                }(UIViewController())
                
               let vc2: UIViewController = {
                    $0.view.backgroundColor = .orange
                    return $0
                }(UIViewController())
                
                let vc3: UIViewController = {
                    $0.view.backgroundColor = .yellow
                    return $0
                }(UIViewController())
                
                dataViewControllers = [vc1, vc2, vc3]
                
            case .event:
                
                //임시 View들입니다..! 추후 삭제예정
                let vc1: UIViewController = {
                     $0.view.backgroundColor = .green
                     return $0
                 }(UIViewController())
                 
                let vc2: UIViewController = {
                     $0.view.backgroundColor = .blue
                     return $0
                 }(UIViewController())
                 
                 dataViewControllers = [vc1, vc2]
                
            case .myPage:
                let vc1: UIViewController = {
                     $0.view.backgroundColor = .purple
                     return $0
                 }(UIViewController())
                 
                let vc2: UIViewController = {
                     $0.view.backgroundColor = .systemPink
                     return $0
                 }(UIViewController())
                 
                 let vc3: UIViewController = {
                     $0.view.backgroundColor = .black
                     return $0
                 }(UIViewController())
                 
                 dataViewControllers = [vc1, vc2, vc3]
            }
            pageViewController.setViewControllers([self.dataViewControllers[0]],
                                                  direction: .forward, animated: true)
        }
    }


// MARK: - extension BandDetailViewController

extension DetailContentView: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController,viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let index = self.dataViewControllers.firstIndex(of: viewController),
              index - 1 >= 0
        else { return nil }
        return self.dataViewControllers[index - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let index = self.dataViewControllers.firstIndex(of: viewController),
              index + 1 < self.dataViewControllers.count
        else { return nil }
        return self.dataViewControllers[index + 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],transitionCompleted completed: Bool) {
        
        guard let viewController = pageViewController.viewControllers?[0],
            let index = self.dataViewControllers.firstIndex(of: viewController)
        else { return }
        self.currentPage = index
        self.segmentedControl.selectedSegmentIndex = index
    }
}

