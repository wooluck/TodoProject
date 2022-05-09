//
//  DetailViewController.swift
//  WooTodo
//
//  Created by luck woo on 2022/04/19.
//

import UIKit
import SnapKit

enum TodoEditorMode {
    case new
    case edit(IndexPath, Todo)
}

protocol WriteViewDelegate: AnyObject {
    func didSelectReigster(todo: Todo)
}


class WriteViewController : UIViewController {
    
    weak var delegate : WriteViewDelegate?
    var todo: Todo?
    var indexPath: IndexPath?
    var todoEditorMode : TodoEditorMode = .new
    var saveBarButton: UIBarButtonItem?

    
//    private lazy var closeButton : UIButton = {
//       var button = UIButton()
//        button.setTitle("닫기", for: .normal)
//        button.setTitleColor(UIColor.label, for: .normal)
//        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
//
//        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
//
//        return button
//    }()
    
//    private lazy var saveButton : UIButton = {
//        var button = UIButton()
//        button.setTitle("저장", for: .normal)
//        button.setTitleColor(UIColor.label, for: .normal)
//        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
//
//        button.addTarget(self, action: #selector(dataSend), for: .touchUpInside)
//
//        return button
//    }()
    
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
    
    private var imageView : UIImageView = {
        var imageView = UIImageView()
        let image = UIImage(named: "Thinking")
        imageView.image = image

        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        setupLayout()
        editingView()
        configureEditMode()
        configureInputField()
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        self.navigationController?.navigationBar.tintColor = .gray

        
        self.saveBarButton = UIBarButtonItem(title: "저장", style: .plain, target: nil, action: #selector(dataSend))
        self.saveBarButton?.tintColor = .label
        self.navigationItem.rightBarButtonItem = saveBarButton
        self.saveBarButton?.isEnabled = false
        
        self.dateTextField.setInputViewDatePicker(target: self, selector: #selector(toolbarTapDone))
        
//        var RealDeatilVC = RealDetailViewController()
//        RealDeatilVC.starPassDelegate = self 
        
    }
    
    
    @objc func dataSend(_ sender: Any) {
        // 저장Button 누르면 발생하는 함수
        guard let content = self.todoTextField.text else { return }
        guard let dateLabel = self.dateTextField.text else { return }
        
//        let mainCell = MainTableViewCell()
//        let checkButtonColor = mainCell.checkButtonColor
        
        let todo = Todo(
            uuidString: UUID().uuidString,
            contents: content,
            dateLabel: dateLabel,
            isStarButton: false
        )
        
        switch self.todoEditorMode {
        case .new:
            self.delegate?.didSelectReigster(todo: todo)
        case let .edit(indexPath, _):
            NotificationCenter.default.post(name: NSNotification.Name("editTodo"), object: todo, userInfo: ["indexPath.row" : indexPath.row])
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @objc func toolbarTapDone() {
          if let datePicker = self.dateTextField.inputView as? UIDatePicker {
              let dateformatter = DateFormatter()
              dateformatter.dateFormat = "yyyy년 MM월 dd일 (E)"
//              dateformatter.dateStyle = .medium
              self.dateTextField.text = dateformatter.string(from: datePicker.date)
          }
          self.dateTextField.resignFirstResponder()
      }
      
    
    @objc func tapStarButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func todoTextFieldDidChange(_ textField: UITextField) {
        self.valiateInputField()
    }
    
    func configureEditMode() {
        switch self.todoEditorMode {
        case let .edit(_, todo):
            self.todoTextField.text = todo.contents
            self.dateTextField.text = todo.dateLabel
        default:
            break
        }
    }
    
    func editingView(){
        guard let todo = self.todo else { return }
        self.todoTextField.text = todo.contents
        self.dateTextField.text = todo.dateLabel
    }
    
    func setupLayout() {

        [
              todoLabel, todoTextField, separatorView, dateLabel, dateTextField, separatorViewTwo, imageView, separatorViewThree
        ].forEach { view.addSubview($0)}
        
        todoLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(130)
//            $0.top.equalTo(closeButton.snp.bottom).offset(30)
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
        
        imageView.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(250)
            $0.leading.trailing.equalToSuperview().inset(70)
        }
        
        separatorViewThree.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).inset(5.5)
            $0.leading.trailing.equalToSuperview().inset(20)
        }


    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    private func configureInputField() {
        self.todoTextField.delegate = self
        self.todoTextField.addTarget(self, action: #selector(todoTextFieldDidChange), for: .editingChanged)
    }
    
    private func valiateInputField() {
        self.saveBarButton?.isEnabled = !(self.todoTextField.text?.isEmpty ?? true)
    }

}

extension WriteViewController : UITextFieldDelegate {
    func textViewDidChange(_ textView: UITextView) {
        valiateInputField()
    }
}
