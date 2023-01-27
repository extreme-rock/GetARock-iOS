//
//  LandingViewController.swift
//  GetARock
//
//  Created by Mijoo Kim on 2023/01/18.
//

import UIKit

 class LandingViewController: UIViewController {

     let test = ActiveGradationButton()
     let testview = UIView()
     let myView = View(frame: CGRect(x: 0, y: 0, width: 200, height: 100), cornerRadius: 25, colors: [UIColor.red, .orange, .yellow], lineWidth: 2)
         
     override func viewDidLoad() {
         super.viewDidLoad()
         view.backgroundColor = .black
         view.addSubview(test)
         test.setTitle("dddddd", for: .normal)
         test.constraint( centerX: view.centerXAnchor, centerY: view.centerYAnchor)
         test.constraint(.widthAnchor, constant: 200)
         test.constraint(.heightAnchor, constant: 50)

//         view.addSubview(myView)
//         myView.constraint(centerX: view.centerXAnchor, centerY: view.centerYAnchor)
//         myView.constraint(.widthAnchor, constant: 200)
//         myView.constraint(.heightAnchor, constant: 100)
//         myView.addSubview(test)
//         test.constraint(centerX: myView.centerXAnchor,
//                         centerY: myView.centerYAnchor)
//         test.constraint(.widthAnchor, constant: 200)
//         test.constraint(.heightAnchor, constant: 100)
//         let action = UIAction { _ in
//             print("hi")
//         }
//         test.addAction(action, for: .touchUpInside)
//         view.addSubview(testview)
//         testview.constraint( centerX: view.centerXAnchor, centerY: view.centerYAnchor)
//         testview.constraint(.widthAnchor, constant: 200)
//         testview.constraint(.heightAnchor, constant: 50)
//         let gradient = UIImage.gradientImage(bounds: testview.bounds, colors: [.systemBlue, .systemRed])
//         let gradientColor = UIColor(patternImage: gradient)
//         testview.layer.borderColor = gradientColor.cgColor
//         testview.layer.borderWidth = 3
         // Do any additional setup after loading the view.
     }


     /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
     }
     */

 }
