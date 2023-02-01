//
//  String+Extension.swift
//  GetARock
//
//  Created by Jisu Jang on 2023/02/01.
//

import Foundation

//MARK: 특수문자 제한 정규표현식

extension String {
    func checkStringExpression() -> Bool{
           do {
               let regex = try NSRegularExpression(
                pattern: "^[a-zA-Z0-9가-힣ㄱ-ㅎㅏ-ㅣ]$",
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
}
