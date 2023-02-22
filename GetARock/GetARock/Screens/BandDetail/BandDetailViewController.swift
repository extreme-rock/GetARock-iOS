//
//  BandDetailViewController.swift
//  GetARock
//
//  Created by Yu ahyeon on 2023/02/13.
//

import UIKit

// MARK: - CommentListUpdateDelegate

protocol CommentListUpdateDelegate: AnyObject {
    func refreshCommentList(data: [CommentList]?)
}

// MARK: - Get BandData

final class BandDetailViewController: BaseViewController {
    
    // MARK: - Property
    
    weak var delegate: CommentListUpdateDelegate?
    
    //TODO: 사용자가 선택한 밴드 아이디를 지도로부터 받아와야함
    private var bandID = "1"
    private var bandData = BandInformationVO(
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
    ){
        didSet{
            print("정보 바뀜")
            print("didSet 작동 중")
            // 델리게이트 작동안함 왜 안하냐고 ㅠㅜㅠㅜㅠㅜㅠㅜㅠㅜ;;;;;
            self.delegate?.refreshCommentList(data: bandData.commentList)
        }
    }
    
    // MARK: - View
    
    lazy var bandTopInfoView = BandTopInfoView()
    lazy var bandDetailContentView: DetailContentView? = nil
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: 비동기 테스크가 만들어짐 -> 비동기함수가 아닌거에 비동기함수를 넣어야할때
        Task {
            await getBandData()
            print("가져오기 성공")
            print(bandData)
            
            bandDetailContentView = DetailContentView(type: .band, bandData: bandData)
            
            //MARK: 데이터를 넣어준다음에 뷰를 그리는 순서를 잡아주기 위해 레이아웃 코드를 여기 넣어야함.(Task 안에 코드는 순서대로 진행됨)
            view.addSubview(bandTopInfoView)
            bandTopInfoView.constraint(
                top: self.view.topAnchor,
                leading: self.view.leadingAnchor,
                trailing: self.view.trailingAnchor,
                padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            )
            
            view.addSubview(bandDetailContentView ?? UIView(frame: .zero))
            bandDetailContentView?.constraint(
                top: bandTopInfoView.bottomAnchor,
                leading: self.view.leadingAnchor,
                bottom: self.view.bottomAnchor,
                trailing: self.view.trailingAnchor,
                padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            )
        }
    }
}

// MARK: - Get BandData

extension BandDetailViewController {
    
    func getBandData() async {
        var queryURLComponent = URLComponents(string: "http://43.201.55.66:8080/band")
        let idQuery = URLQueryItem(name: "id", value: bandID)
        queryURLComponent?.queryItems = [idQuery]
        guard let url = queryURLComponent?.url else { return }
        
        do {
            //MARK: 데이터 받아오기
            let (data, response) = try await URLSession.shared.data(from: url)
            
            //MARK: 데이터 디코딩
            let decodedData = try JSONDecoder().decode(BandInformationVO.self, from: data)
            print("Response data raw: \(data)")
            print("fetch Data")
            print("\(response)")
            self.bandData = decodedData
        } catch {
            print("bad news! decoding error occuerd")
        }
    }
    
}
