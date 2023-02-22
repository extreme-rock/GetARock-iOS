//
//  LandingViewController.swift
//  GetARock
//
//  Created by Mijoo Kim on 2023/01/18.
//

import UIKit

class LandingViewController: UIViewController {
    
    private let button = UIButton(type: .system)
    
     override func viewDidLoad() {
         super.viewDidLoad()
         button.setTitle("모달", for: .normal)
         view.addSubview(button)
         button.constraint(centerX: view.centerXAnchor,
                           centerY: view.centerYAnchor)
         addAction()
         
     }
    
    func addAction() {
        let titleLabel: UILabel = {
            $0.text = "룩희님!\n모여락에 오신걸\n환영해요! 🥳"
            $0.font = .setFont(.largeTitle02)
            $0.numberOfLines = 3
            $0.textColor = .white
            return $0
        }(UILabel())
        
        let subTitleLabel: UILabel = {
            $0.text = "모여락에서 주변의 밴드와 소통하며\n즐거운 밴드 생활을 즐겨볼 준비되셨나요?\n시작하기전에 아래 주의사항을 확인해주세요!"
            $0.font = .setFont(.headline03)
            $0.numberOfLines = 3
            $0.textColor = .white
            $0.addLabelSpacing(lineSpacing: 10)
            return $0
        }(UILabel())
        
        let contentLabel: UILabel = {
            $0.text = "모여락에서 주변의 밴드와 소통하며\n즐거운 밴드 생활을 즐겨볼 준비되셨나요?\n시작하기전에 아래 주의사항을 확인해주세요!모여락에서 주변의 밴드와 소통하며\n즐거운 밴드 생활을 즐겨볼 준비되셨나요?\n시작하기전에 아래 주의사항을 확인해주세요!모여락에서 주변의 밴드와 소통하며\n즐거운 밴드 생활을 즐겨볼 준비되셨나요?\n시작하기전에 아래 주의사항을 확인해주세요!"
            $0.font = .setFont(.headline03)
            $0.numberOfLines = 0
            $0.addLabelSpacing(lineSpacing: 10)
            $0.textColor = .white
            return $0
        }(UILabel())
        
        let action = UIAction { _ in
            let vc = InstructionViewController(titleLabel: titleLabel,
                                               subTitleLabel: subTitleLabel,
                                               contentView: contentLabel)
//            vc.modalPresentationStyle =
            self.present(vc, animated: true)
        }
        button.addAction(action, for: .touchUpInside)
    }
 }

