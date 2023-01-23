//
//  GetARock++Bundle.swift
//  GetARock
//
//  Created by Mijoo Kim on 2023/01/19.
//

import Foundation

extension Bundle {
    var apiKey: String {
        guard let file = self.path(forResource: "MapsInfo", ofType: "plist") else { return "" }
        guard let resource = NSDictionary(contentsOfFile: file) else { return "" }
        guard let key = resource["MAPS_API_KEY"] as? String else { fatalError("MapsInfo.plist에 MAPS_API_KEY를 입력해주세요") }
        return key
    }
    
    var gmsMapID: String {
        guard let file = self.path(forResource: "MapsInfo", ofType: "plist") else { return "" }
        guard let resource = NSDictionary(contentsOfFile: file) else { return "" }
        guard let key = resource["GMS_MAP_ID"] as? String else { fatalError("MapsInfo.plist에 GMS_MAP_ID를 입력해주세요") }
        return key
    }
}
