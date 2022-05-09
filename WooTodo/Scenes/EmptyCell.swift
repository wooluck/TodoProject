//
//  EmptyCell.swift
//  WooTodo
//
//  Created by luck woo on 2022/04/28.
//

import UIKit

class EmptyCell : UITableViewCell {
    
    var emptyLabel : UILabel = {
        var label = UILabel()
        label.text = "글이 없습니다"
        
        return label
    }()
    
    func emptySetup() {
        
        addSubview(emptyLabel)
        
        emptyLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
        }
    }
}
