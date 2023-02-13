//
//  ModelData.swift
//  GetARock
//
//  Created by Jisu Jang on 2023/02/13.
//

struct ModelData {
    static var bandCreationData: BandInformationDTO = BandInformationDTO(
        name: "",
        address: Address(city: "",
                         street: "",
                         detail: "",
                         longitude: 0.0,
                         latitude: 0.0),

        songList: nil,

        memberList: [],
        introduction: nil,

        snsList: nil
    )
}

