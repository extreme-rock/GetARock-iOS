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
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        if let date = dateFormatter.date(from: self) {
            return date
        } else {
            return nil
        }
    }
    
    // MARK: String으로 된 날짜(년월일 시분초)에서 년월일만 추출해 Date 타입으로 변환
    func extractDay() -> Date? {
        let startIndex = self.index(self.startIndex, offsetBy: 7)
        let endIndex = self.index(self.startIndex, offsetBy: 10)
        let range = ...endIndex
        let eventDate = self[range]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        if let date = dateFormatter.date(from: String(eventDate)) {
            return date
        } else {
            return nil
        }
    }
}
