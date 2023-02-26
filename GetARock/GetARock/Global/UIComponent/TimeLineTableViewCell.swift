//
//  TimeLineTableViewCell.swift
//  GetARock
//
//  Created by Yu ahyeon on 2023/02/26.
//

import UIKit

class TimeLineTableViewCell: UITableViewCell {
    
    // MARK: - Property
    
    private let iconInageView = IconImageView(iconType: .eventIcon)
    
    private let eventTitleLabel = BasicLabel(
        contentText: "이벤트제목입니둥",
        fontStyle: .headline02,
        textColorInfo: .white
    )
    
    private let bandNameLabel = BasicLabel(
        contentText: "날짜입니당",
        fontStyle: .headline01,
        textColorInfo: .gray02
    )
    
    

    
        
    
    // MARK: - View
    
    
    // MARK: - Init
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}
