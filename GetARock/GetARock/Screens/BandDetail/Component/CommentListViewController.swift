//
//  CommentListViewController.swift
//  GetARock
//
//  Created by Yu ahyeon on 2023/03/26.
//

import UIKit
import MessageUI

class CommentListViewController: UIViewController {
    
    // MARK: - Property
    
    private var cellIndex: IndexPath = []
    private var commentID = 0
    private var selectedcommentID: CommentList? = nil
    private var commentData: [CommentList]?
    
    // MARK: - View
    
    private lazy var bandCommentList = CommentListView(data: commentData)
    
    // MARK: - init
    
    init(commentData: [CommentList]?) {
        self.commentData = commentData
        print(commentData)
        super.init(nibName: nil, bundle: nil)
        }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        setCommentListDelegate()
    }
    
    // MARK: - Method
    
    private func setLayout() {
        self.view.addSubview(bandCommentList)
        bandCommentList.constraint(
            top: self.view.topAnchor,
            leading: self.view.leadingAnchor,
            bottom: self.view.bottomAnchor,
            trailing: self.view.trailingAnchor
        )
    }
    
    private func setCommentListDelegate() {
        bandCommentList.delegate = self
        
    }
    
//    private func setCommentListLoadObserver() {
//        NotificationCenter.default.addObserver(
//            self,
//            selector: #selector(loadList),
//            name: NSNotification.Name.loadBandData,
//            object: nil
//        )
//    }
    
}

// MARK: - extension CheckCellIndexDelegate, Reportable

extension CommentListViewController: CheckCellIndexDelegate, Reportable {
    func checkCellIndex(indexPath: IndexPath, commentData: CommentList?) {
        cellIndex = indexPath
        self.selectedcommentID = commentData
        print("\(cellIndex)번 눌림")
        print("\(commentID)댓글아이디값")
        //TODO: 댓글의 멤버 ID와 로그인한 유저의 ID가 일치하면 삭제가능하도록 수정
        if selectedcommentID?.memberName == "노엘" {
            showActionSheet(isWriter: true)
        } else {
            showActionSheet(isWriter: false)
        }
    }
    
    
    
//    func checkCellIndex(indexPath: IndexPath, commentID: Int) {
//        cellIndex = indexPath
//        self.commentID = commentID
//        print("\(cellIndex)번 눌림")
//        print("\(commentID)댓글아이디값")
//        //TODO: 댓글의 멤버 ID와 로그인한 유저의 ID가 일치하면 삭제가능하게
//        showActionSheet(isWriter: false)
//    }
    

    // TODO: - 테이블뷰 리로드..
    func alertDeleteButtonPressed() {
        print("삭제 선택")
        print(commentID)
        deleteCommentID()
    }
    
    func alertReportButtonPressed() {
        sendReportMail()
    }
}


// MARK: - Delete CommentID

extension CommentListViewController {

    func deleteCommentID() {
        do {
            let headers = [
                "accept": "application/json",
                "content-type": "application/json"
            ]
            
            var queryURLComponent = URLComponents(string: "https://api.ryomyom.com/comment")
            
            let commentIdQuery = URLQueryItem(name: "id", value: String(selectedcommentID?.commentID ?? 0))
            
            queryURLComponent?.queryItems = [commentIdQuery]
            
            guard let url = queryURLComponent?.url else { return }
            print(url)
            var request = URLRequest(url: url,
                                     cachePolicy: .useProtocolCachePolicy,
                                     timeoutInterval: 10.0)
            request.httpMethod = "DELETE"
            request.allHTTPHeaderFields = headers
            Task {
                //TODO: fetch함수 손보기
                await BandDetailViewController(myBands: []).fetchBandData(with: 343)
            }
            
            let dataTask = URLSession.shared.dataTask(with: request,
                                                      completionHandler: { (data, response, error) -> Void in
                if (error != nil) {
                    print("통신 과정에서 에러가 났습니다.")
                    print(error?.localizedDescription ?? "error case occured")
                } else {
                    print("response는 다음과 같습니다")
                    print(response)
                }
            })
            dataTask.resume()
        }
    }
}

// MARK: - MFMailComposeViewControllerDelegate

extension CommentListViewController: MFMailComposeViewControllerDelegate {
    func sendReportMail() {
        if MFMailComposeViewController.canSendMail() {
            let composeVC = MFMailComposeViewController()
            let getarockEmail = "ryomyomyom@gmail.com"
            // TODO: 유저디폴트에서 닉네임 가져오기
            let messageBody = """

                              -----------------------------

                              - 문의하는 닉네임:
                              - 문의 메시지 제목 한줄 요약:
                              - 문의 날짜: \(Date())

                              ------------------------------

                              문의 내용을 작성해주세요.

                              """

            composeVC.mailComposeDelegate = self
            composeVC.setToRecipients([getarockEmail])
            composeVC.setSubject("[문의 사항]")
            composeVC.setMessageBody(messageBody, isHTML: false)

            self.present(composeVC, animated: true, completion: nil)
        }
        else {
            self.showSendMailErrorAlert()
        }
    }

    private func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertController(
            title: "메일 전송 실패",
            message: "아이폰 이메일 설정을 확인하고 다시 시도해주세요.",
            preferredStyle: .alert
        )
        let confirmAction = UIAlertAction(title: "확인", style: .default) {
            (action) in
            print("확인")
        }
        sendMailErrorAlert.addAction(confirmAction)
        self.present(sendMailErrorAlert, animated: true, completion: nil)
    }

    func mailComposeController(
        _ controller: MFMailComposeViewController,
        didFinishWith result: MFMailComposeResult,
        error: Error?
    ) {
        controller.dismiss(animated: true, completion: nil)
    }
}

