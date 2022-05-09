//
//  SettingTableViewCell.swift
//  WooTodo
//
//  Created by luck woo on 2022/04/19.
//

import UIKit
import SnapKit

class SettingTableViewCell : UITableViewCell {
    
    var unChangeLabel: UILabel = {
        var label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    var changeLabel : UILabel = {
        var label = UILabel()
        label.text = "Click"
        label.textColor = .gray
        return label
    }()
    
    private var separatorView = SeparatorView(frame: .zero)
    
    func setupLayout() {
        [
            unChangeLabel, changeLabel, separatorView
        ].forEach { addSubview($0)}
        
        unChangeLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.leading.equalToSuperview().inset(20)
        }
        
        changeLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.trailing.equalToSuperview().inset(20)
        }
        
        separatorView.snp.makeConstraints {
            $0.top.equalTo(unChangeLabel.snp.bottom).offset(20)
//            $0.bottom.equalToSuperview().inset(10)
            $0.leading.equalToSuperview().inset(20)
        }
    }
}
