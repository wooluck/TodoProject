//
//  SettingViewController.swift
//  WooTodo
//
//  Created by luck woo on 2022/04/19.
//

import UIKit
import SnapKit

class SettingViewController : UIViewController {
    
    var dateOrder : Bool = false 
    
    var sectionHeader = ["설정", "정렬", "기타"]
    var cellContents = ["언어", "배경색상"] // 2,1,3
    var arrayCell = ["날짜 순서"]
    var elseCell = ["앱 버전", "리뷰" ,"취업 응원"]
    
    var arrayCellRight = ["오름차순", "내림차순"]
    var elseCellRight = ["신형 1.0", "취업시켜주세요 :)", "100원 후원 😏"]
    
    private lazy var tableView: UITableView = {
        var tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
//        tableView.separatorStyle = .none
//        tableView.rowHeight = 100
        tableView.register(SettingTableViewCell.self, forCellReuseIdentifier: "SettingTableViewCell")
        
        return tableView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
            
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension SettingViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        } else if section == 1 {
            return 1
        } else if section == 2 {
            return 3
        }
        
        return section
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SettingTableViewCell", for: indexPath) as? SettingTableViewCell else { return UITableViewCell()}
        
        cell.selectionStyle = .none
        cell.setupLayout()
        
        if indexPath.section == 0 {
            cell.unChangeLabel.text = "\(cellContents[indexPath.row])"
            
        } else if indexPath.section == 1 {
            cell.unChangeLabel.text = "\(arrayCell[indexPath.row])"
            cell.changeLabel.text = "\(arrayCellRight[indexPath.row])"
        } else if indexPath.section == 2 {
            cell.unChangeLabel.text = "\(elseCell[indexPath.row])"
            cell.changeLabel.text = "\(elseCellRight[indexPath.row])"
        } else {
            return UITableViewCell()
        }
        
        return cell
    }
}

extension SettingViewController : UITableViewDelegate {
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//        let settingTC = SettingTableViewCell()
//
//        if indexPath == [1, 0], self.dateOrder == false {
//            indexPath.row
////            if self.dateOrder == false {
////                settingTC.changeLabel.text = "내림차순"
////                self.dateOrder = true
////            } else if self.dateOrder == true {
////                settingTC.changeLabel.text = "오름차순"
////                self.dateOrder = false
////            }
//
//        }
//    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionHeader.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionHeader[section]
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
}
