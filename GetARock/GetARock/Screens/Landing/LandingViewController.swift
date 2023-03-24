//
//  LandingViewController.swift
//  GetARock
//
//  Created by Mijoo Kim on 2023/01/18.
//

import UIKit

class LandingViewController: UIViewController {
    
    // MARK: - Property
    
    private let backgroundImageView: UIImageView = {
        $0.image = ImageLiteral.landingBackground
        $0.contentMode = .scaleAspectFill
        return $0
    }(UIImageView(frame: UIScreen.main.bounds))
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    // MARK: - Methods
    
    private func setupLayout() {
        self.view.insertSubview(backgroundImageView, at: 0)
    }
     }
 }
