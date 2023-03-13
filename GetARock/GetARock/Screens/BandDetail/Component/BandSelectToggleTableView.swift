//
//  BandSelectToggleView.swift
//  GetARock
//
//  Created by 최동권 on 2023/03/09.
//

import UIKit

protocol BandSelectToggleTableViewDelegate: AnyObject {
    func fetchSelectedBandInfo(indexPath: IndexPath)
}

final class BandSelectToggleTableView: UITableView {
    
    // MARK: - Property
    weak var selectDelegate: BandSelectToggleTableViewDelegate?
    private let bandNames: [String]
    
    // MARK: - View
    
    // MARK: - Init
    
    init(bandNames: [String]) {
        self.bandNames = bandNames
        super.init(frame: .zero, style: .plain)
        self.setupLayout()
        self.attribute()
        self.configureTableView()
        self.selectFirstBand()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Method
    
    private func attribute() {
        backgroundColor = .clear
        layer.cornerRadius = 10
        separatorInset = .init(top: 0, left: 15, bottom: 0, right: 15)
        separatorColor = .dark04
        isScrollEnabled = false
    }
    
    private func configureTableView() {
        delegate = self
        dataSource = self
        register(BandSelectToggleTableViewCell.self, forCellReuseIdentifier: BandSelectToggleTableViewCell.classIdentifier)
    }
    
    private func setupLayout() {
//        self.constraint(.widthAnchor, constant: 250)
    }
    
    private func selectFirstBand() {
        let firstIndexPath = IndexPath(row: 0, section: 0)
        self.selectRow(at: firstIndexPath, animated: true, scrollPosition: .none)
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
    
        selectDelegate?.fetchSelectedBandInfo(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if tableView.indexPathForSelectedRow == indexPath {
            return nil
        }
        return indexPath
    }
}
