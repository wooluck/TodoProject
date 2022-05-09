//
//  RealDetailViewController.swift
//  WooTodo
//
//  Created by luck woo on 2022/04/25.
//

import UIKit
import SnapKit

protocol EditingDetailViewDelegate : AnyObject {
    func didSelectDelete(indexPath : IndexPath )
    func didSelectStar(indexPath: IndexPath, isStar: Bool)
}

//protocol IsStarPassValue: AnyObject {
//    func passIsStar(isStar: Bool)
//}

class RealDetailViewController : UIViewController {
    
    weak var editDelegate : EditingDetailViewDelegate?
//    weak var starPassDelegate : IsStarPassValue?
    
    var todo: Todo?
    var indexPath: IndexPath?
    var starButton: UIBarButtonItem?
        
    private lazy var todoLabel : UILabel = {
        var label = UILabel()
        label.text = "할일"
        label.font = .systemFont(ofSize: 15, weight: .bold)
        
        
        return label
    }()
    
    private lazy var todoTextField : UITextField = {
        var textfield = UITextField()
        textfield.placeholder = "할일을 입력해줄꺼죠?"
        return textfield
    }()
    
    private var separatorView = SeparatorView(frame: .zero)
    
    private lazy var dateLabel : UILabel = {
        var label = UILabel()
        label.text = "날짜"
        label.font = .systemFont(ofSize: 15, weight: .bold)
        
        return label
    }()
    
    private lazy var dateTextField : UITextField = {
        var textfield = UITextField()
        
        let dateformatter = DateFormatter() // 2-2
        dateformatter.dateFormat = "yyyy년 MM월 dd일 (E)"

        textfield.text = dateformatter.string(from: Date()) //2-4
        return textfield
    }()
    
    private var separatorViewTwo = SeparatorView(frame: .zero)
    private var separatorViewThree = SeparatorView(frame: .zero)
    
    private lazy var updateButton : UIButton = {
        var button = UIButton()
        button.setTitle("수정", for: .normal)
        button.setTitleColor(UIColor.blue, for: .normal)
//        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .white
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10
        button.layer.borderColor = UIColor.blue.cgColor

        
        button.addTarget(self, action: #selector(tapEditButton), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var deleteButton : UIButton = {
        var button = UIButton()
        button.setTitle("삭제", for: .normal)
        button.setTitleColor(UIColor.red, for: .normal)
        button.backgroundColor = .white
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10
        button.layer.borderColor = UIColor.red.cgColor
        
        button.addTarget(self, action: #selector(tapDeleteButton), for: .touchUpInside)
        return button
    }()
    
    private var imageView : UIImageView = {
        var imageView = UIImageView()
        let image = UIImage(named: "th")
        imageView.image = image

        return imageView
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        setupLayout()
        editingView()
        navigationController?.setNavigationBarHidden(false, animated: true)
        print("todo : \(todo)  index : \(indexPath)")
    }
    
    @objc func tapEditButton() {
        let writeVC = WriteViewController()
        guard let indexPath = self.indexPath else { return }
        guard let todo = self.todo else { return }
        writeVC.todoEditorMode = .edit(indexPath, todo)
        
        NotificationCenter.default.addObserver(self, selector: #selector(editTodoNotification), name: NSNotification.Name("editTodo"), object: nil)
        self.navigationController?.pushViewController(writeVC, animated: true)
    }
    
    @objc func editTodoNotification(_ notification: Notification) {
        guard let todo = notification.object as? Todo else { return }
        guard let row = notification.userInfo?["indexPath.row"] as? Int else { return }
        
        self.todo = todo
        self.editingView()
    }
    
    @objc func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }

    @objc func tapDeleteButton(){
        guard let indexPath = self.indexPath else { return }
        self.editDelegate?.didSelectDelete(indexPath: indexPath)
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func tapStarButton(){
        guard let isStar = self.todo?.isStarButton else { return }
        guard let indexPath = self.indexPath else { return }
        if isStar {
            self.starButton?.image = UIImage(systemName: "star")
        } else {
            self.starButton?.image = UIImage(systemName: "star.fill")
        }
        self.todo?.isStarButton = !isStar
        self.editDelegate?.didSelectStar(indexPath: indexPath, isStar: self.todo?.isStarButton ?? false )
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func editingView(){
        guard let todo = self.todo else { return }
        self.todoTextField.text = todo.contents
        self.dateTextField.text = todo.dateLabel
        self.starButton = UIBarButtonItem(image: nil, style: .plain, target: self, action: #selector(tapStarButton))
        self.starButton?.image = todo.isStarButton ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
        self.starButton?.tintColor = .orange
        self.navigationController?.navigationBar.tintColor = .gray
        self.navigationItem.rightBarButtonItem = starButton
    }
    
    func setupLayout() {

        [
             updateButton, todoLabel, todoTextField, separatorView, dateLabel, dateTextField, separatorViewTwo, deleteButton, imageView, separatorViewThree
        ].forEach { view.addSubview($0)}
        
        
        todoLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(120)
            $0.leading.equalToSuperview().inset(20)
        }

        todoTextField.snp.makeConstraints {
            $0.top.equalTo(todoLabel.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        separatorView.snp.makeConstraints {
            $0.top.equalTo(todoTextField.snp.bottom).offset(5)
            $0.leading.trailing.equalToSuperview().inset(20)
        }

        dateLabel.snp.makeConstraints {
            $0.top.equalTo(todoTextField.snp.bottom).offset(50)
            $0.leading.equalToSuperview().inset(20)
        }

        dateTextField.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        separatorViewTwo.snp.makeConstraints {
            $0.top.equalTo(dateTextField.snp.bottom).offset(5)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        updateButton.snp.makeConstraints {
            $0.top.equalTo(dateTextField.snp.bottom).offset(60)
            $0.leading.equalToSuperview().inset(80)
            $0.width.equalTo(100)
            $0.height.equalTo(40)
        }

        deleteButton.snp.makeConstraints {
            $0.top.equalTo(dateTextField.snp.bottom).offset(60)
            $0.trailing.equalToSuperview().inset(80)
            $0.width.equalTo(100)
            $0.height.equalTo(40)
        }
        
        imageView.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(200)
            $0.leading.trailing.equalToSuperview().inset(70)
        }
        
        separatorViewThree.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).inset(5.5)
            $0.leading.trailing.equalToSuperview().inset(20)
        }

    }
}
