//
//  MainMapViewController.swift
//  GetARock
//
//  Created by Mijoo Kim on 2023/01/20.
//

import UIKit

import GoogleMaps

final class MainMapViewController: UIViewController {
    
    // MARK: - Property

    private var mapView: GMSMapView!

    // MARK: - Life Cycle
    
    override func loadView() {
        let camera: GMSCameraPosition = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 11)

        mapView = GMSMapView(frame: .zero, camera: camera)
        self.view = mapView
        mapView.delegate = self
      }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

extension MainMapViewController: GMSMapViewDelegate {
    
}
