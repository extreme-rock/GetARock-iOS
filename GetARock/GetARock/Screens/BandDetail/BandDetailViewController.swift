//
//  BandDetailViewController.swift
//  GetARock
//
//  Created by Yu ahyeon on 2023/02/13.
//

import UIKit

final class BandDetailViewController: BaseViewController {
    
    // MARK: - Property
    
    //서버에서 Get하는 데이터 양식
    private var getbandData = BandInformationVO(
        bandID: 0,
        name: "",
        introduction: "",
        age: "",
        address: Address(city: "",
                         street: "",
                         detail: "",
                         longitude: 0.0,
                         latitude: 0.0),
        memberList: [],
        songList: [],
        snsList: [],
        eventList: [],
        commentList: [CommentList.init(commentID: 01,
                                       memberName: "블랙로즈",
                                       comment: "댓글내용입니당",
                                       createdDate: "2022.11.19 13:20"),
                      CommentList.init(commentID: 02,
                                       memberName: "오아시스",
                                       comment: "오 효자동 근처 밴드네요! 반갑습니당 >///< 저희도 근처에 있는데 꼭 공연보러갈게요!",
                                       createdDate: "2022.11.19 13:20"),
                      CommentList.init(commentID: 03,
                                       memberName: "3번쨰 밴드",
                                       comment: "오 효자동 근처 밴드네요! 반갑습니당 >///< 저희도 근처에 있는데 꼭 공연보러갈게요!",
                                       createdDate: "2022.11.19 13:20")]
    )
    
    // MARK: - View
    
    lazy var bandTopInfoView = BandTopInfoView()
    lazy var bandDetailContentView = DetailContentView(type: .band, bandData: getbandData)
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //비동기 테스크가 만들어짐 -> 비동기함수가 아닌거에 비동기함수를 넣어야할때
        Task{
            
        }
        
        view.addSubview(bandTopInfoView)
        bandTopInfoView.constraint(
            top: self.view.topAnchor,
            leading: self.view.leadingAnchor,
            trailing: self.view.trailingAnchor,
            padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        )
        
        view.addSubview(bandDetailContentView)
        bandDetailContentView.constraint(
            top: bandTopInfoView.bottomAnchor,
            leading: self.view.leadingAnchor,
            bottom: self.view.bottomAnchor,
            trailing: self.view.trailingAnchor,
            padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        )
        
        
    }
}
