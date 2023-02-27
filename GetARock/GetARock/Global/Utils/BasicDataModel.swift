//
//  ModelData.swift
//  GetARock
//
//  Created by Jisu Jang on 2023/02/13.
//

struct BasicDataModel {
    static var bandCreationData: BandCreationDTO = BandCreationDTO(
        name: "user",
        address: Address(city: "default",
                         street: "default",
                         detail: "default",
                         longitude: 0.0,
                         latitude: 0.0),

        songList: nil,

        memberList: [],
        introduction: nil,

        snsList: nil
    )
}

