//
//  MainTableViewCell.swift
//  WooTodo
//
//  Created by luck woo on 2022/04/19.
//

import UIKit

class MainTableViewCell : UITableViewCell {
    
    var checkButtonColor : Bool = false
    var todo: Todo?
    
    var dateLabel : UILabel = {
        var label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .bold)
//        label.text = "2022년 4월 19일 (수)"
        
        return label
    }()
    
    var contentLabel : UILabel = {
       var label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .light)
//        label.text = "임시로 작성한 글입니다."
        
        return label
    }()
    
//    var checkButton : UIButton = {
//        var button = UIButton()
//        button.setImage(UIImage(systemName: "checkmark.seal"), for: .normal)
//
//        let config = UIImage.SymbolConfiguration(pointSize: 25)
//        button.setPreferredSymbolConfiguration(config, forImageIn: .normal) // 심볼 이미지버튼을 크게하는 코드 !!
//        button.tintColor = .gray
//        button.addTarget(self, action: #selector(changeCheckButton), for: .touchUpInside)
//
//        return button
//    }()
    
    private var separatorView = SeparatorView(frame: .zero)
    

    
    func setup() {
        setupLayout()
        
    }
    
    func setupLayout() {
        [
            dateLabel, contentLabel,  separatorView,
        ].forEach { addSubview($0)}
        
        dateLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.leading.trailing.equalToSuperview()
        }
        
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview()
        }
        
//        checkButton.snp.makeConstraints {
//            $0.top.equalToSuperview().inset(15)
//            $0.trailing.equalToSuperview().inset(5)😁😄😆1️⃣2️⃣3️⃣
//            $0.width.equalTo(50)
//            $0.height.equalTo(65)
//        }
        
        separatorView.snp.makeConstraints {
            $0.top.equalTo(contentLabel.snp.bottom).offset(25)
            $0.leading.trailing.equalToSuperview()
//            $0.bottom.equalToSuperview().offset(30)
        }
    }
    
//    override func prepareForReuse() {
//        super.prepareForReuse()
//
//        self.accessoryType = .none
//    }
}


