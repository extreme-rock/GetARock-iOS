//
//  BandSelectToggleView.swift
//  GetARock
//
//  Created by 최동권 on 2023/03/09.
//

import UIKit

final class BandSelectToggleTableView: UITableView {
    
    // MARK: - Property
    private let bandNames: [String]
    
    // MARK: - View
    
    // MARK: - Init
    
    init(bandNames: [String]) {
        self.bandNames = bandNames
        super.init(frame: .zero, style: .plain)
        self.setupLayout()
        self.attribute()
        delegate = self
        dataSource = self
        backgroundColor = .clear
        layer.cornerRadius = 10
        separatorInset = .init(top: 0, left: 15, bottom: 0, right: 15)
        separatorColor = .dark04
        isScrollEnabled = false
        register(BandSelectToggleTableViewCell.self, forCellReuseIdentifier: BandSelectToggleTableViewCell.classIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Method
    
    private func attribute() {
        self.backgroundColor = .clear
    }
    
    private func setupLayout() {
        self.constraint(.widthAnchor, constant: 250)
    }
}

extension BandSelectToggleTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.bandNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.dequeueReusableCell(withIdentifier: BandSelectToggleTableViewCell.classIdentifier, for: indexPath) as? BandSelectToggleTableViewCell else { return UITableViewCell() }
        cell.configure(with: self.bandNames[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
}

extension BandSelectToggleTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     print(indexPath)
    }
}
