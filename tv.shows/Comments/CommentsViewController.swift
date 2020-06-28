//
//  CommentsViewController.swift
//  tv.shows
//
//  Created by Alina Nicorescu on 26/06/2020.
//  Copyright © 2020 Alina Nicorescu. All rights reserved.
//

import Foundation
import UIKit

class CommentsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var commentsTextField: TextFieldInset!
    
    private var keyboardHeight: CGFloat = 0
    
    private var viewModel: CommentsViewModelProtocol?
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    var episodeId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureKeyboard()
        configureCommentsTextField()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        disableUnoccludedTextField()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        configureBackButton()
        if let episodeId = self.episodeId {
            viewModel = CommentsViewModel(episodeId: episodeId, completion: self.dataLoaded(error:))
        }
        enableUnoccludedTextField()
    }
    
    private func dataLoaded(error: Error?) {
        if error != nil {
            Common.presentErrorAlert("An error occurred while saving comment", fromVC: self)
        } else {
            tableView.reloadData()
        }
    }
    
    private func configureBackButton() {
        let image = UIImage(named:"ic-navigate-back")!.withRenderingMode(.alwaysOriginal)
        backButton.setBackgroundImage(image, for: .normal, barMetrics: .default)
    }
    
    private func configureTableView() {
        let cellId = CommentsCell.reuseIdentifier
        let homeNib = UINib(nibName: cellId, bundle: nil)
        tableView.register(homeNib, forCellReuseIdentifier: cellId)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    @IBAction func backPressed(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: false)

    }
    
    private func configureCommentsTextField() {
        let rightView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 150, height: 40))
        button.setTitle("Post", for: .normal)
        button.setTitleColor(UIColor(named: "Somon"), for: .normal)
        rightView.addSubview(button)
        button.addTarget(self, action: #selector(postComment), for: .touchUpInside)
        rightView.addSubview(button)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 30)
        commentsTextField.rightView = rightView
        commentsTextField.rightViewMode = .whileEditing
        commentsTextField.layer.borderWidth = 1
        commentsTextField.layer.borderColor = UIColor(named: "LightGray")?.cgColor
        commentsTextField.clipsToBounds = true
        commentsTextField.layer.cornerRadius = commentsTextField.frame.size.height/2
        commentsTextField.clipsToBounds = true
    }
    
}
    
extension CommentsViewController {
    
    func configureKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 0))
        doneToolbar.barStyle = .default
        doneToolbar.isTranslucent = true
        doneToolbar.barTintColor = UIColor.white
        doneToolbar.sizeToFit()
        self.commentsTextField.inputAccessoryView = doneToolbar
    }
        
    @objc func doneButtonAction() {
        self.resignFirstResponder()
    }
    
    @objc func postComment() {
        commentsTextField.resignFirstResponder()
        if let value = commentsTextField.text {
            viewModel?.addComment(value)
        }
        commentsTextField.text = ""
    }
}
   
extension CommentsViewController: UITableViewDelegate {
    
    
}

extension CommentsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.getNumberOfComments() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: CommentsCell.reuseIdentifier) as? CommentsCell {
            if let commentH = viewModel?.getComment(at: indexPath.item) {
                cell.configure(commentH)
            }
            return cell
        }
        return UITableViewCell()
        
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }

}

extension CommentsViewController : UITextFieldDelegate {
    
    func disableUnoccludedTextField() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    func enableUnoccludedTextField() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func keyboardWillChangeFrame(notification: Notification) {
        let keyboardFrame = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
        self.keyboardHeight = keyboardFrame.height
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        checkForOcculsion()
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        if self.view.frame.origin.y != 0.0 {
            self.view.frame.origin.y = 0.0
        }
        self.keyboardHeight = 0.0
    }
    
    func checkForOcculsion() {
        guard let activeTextField = self.commentsTextField else {
            return
        }
        let bottomOfTextField = self.view.convert(CGPoint(x: 0, y: activeTextField.frame.height), from: activeTextField).y
        let topOfKeyboard = self.view.frame.height - self.keyboardHeight
        
        if (bottomOfTextField > topOfKeyboard) {
            let offset = bottomOfTextField - topOfKeyboard
            self.view.frame.origin.y = -1 * offset
        } else {
            self.view.frame.origin.y = 0
        }
        
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
       checkForOcculsion()
    }
    
    
    public func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      textField.resignFirstResponder()
        return true
    }
}

