//
//  String+Extension.swift
//  GetARock
//
//  Created by Jisu Jang on 2023/02/01.
//

import Foundation

extension String {
    
    // MARK: 특수문자 제한 정규표현식
    func checkStringExpression() -> Bool{
        do {
            let regex = try NSRegularExpression(
                pattern: "^[a-zA-Z0-9가-힣ㄱ-ㅎㅏ-ㅣ\\s]$",
                options: .caseInsensitive)
            
            if let _ = regex.firstMatch(
                in: self,
                options: NSRegularExpression.MatchingOptions.reportCompletion,
                range: NSMakeRange(0, self.count)){
                return true
            }
        } catch {
            print(error)
            return false
        }
        return false
    }
    
    // MARK: String -> Date로 변환
    func toDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.timeZone = TimeZone(identifier: "KST")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let date = dateFormatter.date(from: self) {
            return date
        } else {
            return nil
        }
    }
}
