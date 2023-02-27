//
//  MapSearchResultTableViewCell.swift
//  GetARock
//
//  Created by 장지수 on 2023/02/26.
//

import UIKit
import MapKit

final class PracticePlaceSearchTableViewCell: UITableViewCell {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.setFont(.headline01)
        label.textColor = .white
        
        return label
    }()
    
    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.setFont(.content)
        label.textColor = .gray02
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        attribute()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Cell 재사용 전 값 초기화
    override func prepareForReuse() {
        self.titleLabel.text = nil
        self.subTitleLabel.text = nil
    }
    
    private func attribute() {
        backgroundColor = .clear
    }
    
    private func setupLayout() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(subTitleLabel)
        
        titleLabel.constraint(top: contentView.topAnchor,
                              leading: contentView.leadingAnchor,
                              padding: UIEdgeInsets(top: 10, left: 20, bottom: 0, right: 20))
        
        subTitleLabel.constraint(top: titleLabel.bottomAnchor,
                                 leading: titleLabel.leadingAnchor,
                                 padding: UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 20))
    }
    
    //TODO: 불필요한 코드 체크 필요
    func configure(mapSearchResult: MKLocalSearchCompletion){
        // titleAttribute
        let titleString = mapSearchResult.title
        let attributedTitleString = NSMutableAttributedString(string: titleString)
        attributedTitleString.addAttribute(.foregroundColor, value: UIColor.gray, range: (titleString as NSString).range(of: titleString))
        
        // subTitleAttribute
        let subTitleString = mapSearchResult.subtitle
        let attribtuedSubTitleString = NSMutableAttributedString(string: subTitleString)
        attribtuedSubTitleString.addAttribute(.foregroundColor, value: UIColor.gray, range: (subTitleString as NSString).range(of: subTitleString))
        //
        let titleRange = mapSearchResult.titleHighlightRanges
        titleRange.forEach{
            attributedTitleString.addAttribute(.foregroundColor, value: UIColor.black, range: $0.rangeValue)
        }
        
        let subTitleRange = mapSearchResult.subtitleHighlightRanges
        subTitleRange.forEach{
            attribtuedSubTitleString.addAttribute(.foregroundColor, value: UIColor.black, range: $0.rangeValue)
        }
        
        self.titleLabel.text = mapSearchResult.title
        self.subTitleLabel.text = mapSearchResult.subtitle
    }
}
