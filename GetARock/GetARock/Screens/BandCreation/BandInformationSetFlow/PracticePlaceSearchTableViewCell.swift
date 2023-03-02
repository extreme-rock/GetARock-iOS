//
//  MapSearchResultTableViewCell.swift
//  GetARock
//
//  Created by 장지수 on 2023/02/26.
//

import UIKit
import MapKit

final class PracticePlaceSearchTableViewCell: UITableViewCell {

    //MARK: View
    
    private let titleLabel: BasicLabel = BasicLabel(contentText: "", fontStyle: .headline01, textColorInfo: .white)
    
    private let subTitleLabel: UILabel = {
        $0.numberOfLines = 2
        return $0
    }(BasicLabel(contentText: "", fontStyle: .content, textColorInfo: .white))

    private lazy var contentStackView: UIStackView = {
        $0.axis = .vertical
        $0.spacing = -7
        $0.isLayoutMarginsRelativeArrangement = true
        $0.layoutMargins = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        return $0
    }(UIStackView(arrangedSubviews: [titleLabel, subTitleLabel]))

    //MARK: init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        attribute()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: Methods
    
    //Cell 재사용 전 텍스트 정보 초기화
    override func prepareForReuse() {
        self.titleLabel.text = nil
        self.subTitleLabel.text = nil
    }
    
    private func attribute() {
        backgroundColor = .clear
    }
    
    private func setupLayout() {
        contentView.addSubview(contentStackView)
        contentStackView.constraint(to: contentView)

        subTitleLabel.constraint(.widthAnchor, constant: contentStackView.bounds.size.width)
    }
    
    func configure(mapSearchResult: MKLocalSearchCompletion){
        self.titleLabel.text = mapSearchResult.title
        self.subTitleLabel.text = mapSearchResult.subtitle
    }
}
