//
//  Reportable+protocol.swift
//  GetARock
//
//  Created by Yu ahyeon on 2023/03/26.
//

import MessageUI
import UIKit

protocol Reportable: UIViewController, AlertSheet {
    
}

extension Reportable {
    
    func showActionSheet(isCreator: Bool) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        let delete = UIAlertAction(title: "삭제하기", style: .destructive) { [weak self] _ in
            self?.showAlertSheet(type: .delete, alertTitle: "삭제하기", message: "댓글을 삭제하시겠습니까?")
        }
        let report = UIAlertAction(title: "신고하기", style: .default) { [weak self] _ in
            self?.showAlertSheet(type: .report, alertTitle: "신고하기", message: "댓글을 신고하시겠습니까?")
        }
        actionSheet.addAction(report)
        if isCreator == true {
            actionSheet.addAction(delete)
        }
        actionSheet.addAction(cancel)
        present(actionSheet, animated: true)
    }
}

enum AlertType{
    case delete
    case report
}

protocol AlertSheet: UIViewController {
    func alertDeleteButtonPressed()
    func alertReportButtonPressed()
}

extension AlertSheet {
    func showAlertSheet(type: AlertType, alertTitle: String, message: String) {
        let alertSheet = UIAlertController(title: alertTitle, message: message, preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "취소", style: .default)
        let action = UIAlertAction(title: alertTitle, style: .destructive) { _ in
            if type == .delete{
                self.alertDeleteButtonPressed()
            } else {
                self.alertReportButtonPressed()
            }
        }
        
        alertSheet.addAction(cancel)
        alertSheet.addAction(action)
        
        present(alertSheet, animated: true)
        
    }
}

