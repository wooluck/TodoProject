//
//  ViewController.swift
//  WooTodo
//
//  Created by luck woo on 2022/04/18.
//

import UIKit
import SnapKit



class MainViewController: UIViewController{
    
    var todoList = [Todo]() { // 프로퍼티 옵저버
        didSet {
            self.saveTodoList()
        }
    }

    
    private lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.text = "할일"
        
        return label
    }()
    
    private lazy var gearButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 25)
        
        button.setPreferredSymbolConfiguration(config, forImageIn: .normal) // 심볼 이미지버튼을 크게하는 코드 !!
        button.setImage(UIImage(systemName: "gear"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(intoSettingViewController), for: .touchUpInside)
        
        return button
    }()
    
    
    private lazy var newButton: UIButton = {
        var button = UIButton()
        button.setTitle("+ 새로운 일을 등록할까요?", for: .normal)
        button.setTitleColor(UIColor.gray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        button.backgroundColor = .systemGray5
        button.layer.cornerRadius = 10
        
        button.addTarget(self, action: #selector(intoWriteViewController), for: .touchUpInside)
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.rowHeight = 90
        
        tableView.register(MainTableViewCell.self, forCellReuseIdentifier: "MainTableViewCell")
        tableView.register(EmptyCell.self, forCellReuseIdentifier: "EmptyCell")
        
        
        tableView.reloadData()
        return tableView
    }()
    
    private var imageView : UIImageView = {
        var imageView = UIImageView()
        let image = UIImage(named: "can")
        imageView.image = image

        return imageView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
        print("todoList전전 : \(todoList)")
        tableView.reloadData()
        
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        loadTodoList()
        NotificationCenter.default.addObserver(self, selector: #selector(editTodoNotification), name: NSNotification.Name("editTodo"), object: nil)
        self.navigationController?.navigationBar.topItem?.title = "뒤로"
        
        
        
        
    }
    
    @objc func editTodoNotification(_ notification: Notification) {
        guard let todo = notification.object as? Todo else { return }
        guard let row = notification.userInfo?["indexPath.row"] as? Int else { return }
        self.todoList[row] = todo
        self.todoList = self.todoList.sorted(by: {
            $0.dateLabel.compare($1.dateLabel) == .orderedDescending
        })
        
    }
    
    @objc private func intoSettingViewController() {
        
        self.navigationController?.pushViewController(SettingViewController(), animated: true)
    }
    
    @objc private func intoWriteViewController() {
          let writeVC = WriteViewController()
          writeVC.delegate = self
    
          self.navigationController?.pushViewController(writeVC, animated: true)
    }
    
    private func saveTodoList() {
        let mainCell = MainTableViewCell()
        let data = self.todoList.map {
            [
                "uuidString": $0.uuidString,
                "contents": $0.contents,
                "dateLabel": $0.dateLabel,
                "isStarButton": $0.isStarButton
            ]
        }
        let userDefaults = UserDefaults.standard
        userDefaults.set(data, forKey: "todoList")
        print("saveTodoList11 - called : \(mainCell.checkButtonColor)")
    }

    private func loadTodoList() {
        let userDefaults = UserDefaults.standard
        guard let data = userDefaults.object(forKey: "todoList") as? [[String: Any]] else { return }
        self.todoList = data.compactMap {
            guard let uuidString = $0["uuidString"] as? String else { return nil}
            guard let contents = $0["contents"] as? String else { return nil}
            guard let dateLabel = $0["dateLabel"] as? String else { return nil}
            guard let isStarButton = $0["isStarButton"] as? Bool else { return nil}
            return Todo(
                uuidString: uuidString,
                contents: contents,
                dateLabel: dateLabel,
                isStarButton: isStarButton
            )
        }
        
        self.todoList = self.todoList.sorted(by: {
            $0.dateLabel.compare($1.dateLabel) == .orderedAscending
        })
        print("loadTodoList - called: \(todoList)")
    }
    
    
    private func setView() {
        
        [
            titleLabel, gearButton, newButton, tableView, imageView
        ].forEach { view.addSubview($0)}
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(60)
            $0.leading.equalToSuperview().inset(20)
        }
        
        gearButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(55)
            $0.trailing.equalToSuperview().inset(20)
        }
        
        newButton.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(25)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(50)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(newButton.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
//            $0.bottom.equalToSuperview().inset(20)
            $0.bottom.equalTo(imageView.snp.top).offset(10)
        }
        
        imageView.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(50)
        }
    }
    
    
    
}

extension MainViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = self.todoList.count
        if count == 0 {
            return 1
        } else {
            return count
        }
//            return self.todoList.count
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.todoList.isEmpty == false {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MainTableViewCell", for: indexPath) as? MainTableViewCell else { return UITableViewCell()}
            var todo = todoList[indexPath.row]
            cell.selectionStyle = .none
            cell.dateLabel.text = todo.dateLabel
            cell.contentLabel.text = todo.contents
            
            self.todoList = self.todoList.sorted(by: {
                $0.dateLabel.compare($1.dateLabel) == .orderedAscending
            })

            cell.setup()
            
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "EmptyCell", for: indexPath) as? EmptyCell else { return UITableViewCell()}

            cell.emptySetup()
            
            
            return cell
        }
        
        
    }
    
}
extension MainViewController : WriteViewDelegate {
    func didSelectReigster(todo: Todo) {
        self.todoList.append(todo)
        self.tableView.reloadData()
    }
}
extension MainViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let writeVC = WriteViewController()
        let realDeatilVC = RealDetailViewController()
        let todo = self.todoList[indexPath.row]
        realDeatilVC.todo = todo
        realDeatilVC.indexPath = indexPath
        realDeatilVC.editDelegate = self
        self.navigationController?.pushViewController(realDeatilVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            todoList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
            
            tableView.endUpdates()
            print("--> \(todoList)")

        }
    }
}

extension MainViewController : EditingDetailViewDelegate {
    func didSelectDelete(indexPath: IndexPath) {
        self.todoList.remove(at: indexPath.row)
        self.tableView.deleteRows(at: [indexPath], with: .none)
        
        print("-->b \(todoList)")
    }
    func didSelectStar(indexPath: IndexPath, isStar: Bool) {
        self.todoList[indexPath.row].isStarButton = isStar
    }
}

