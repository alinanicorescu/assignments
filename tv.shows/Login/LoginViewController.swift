//
//  LoginViewController.swift
//  tv.shows
//
//  Created by Alina Nicorescu on 22/06/2020.
//  Copyright © 2020 Alina Nicorescu. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: FloatingLabelTextField!
    @IBOutlet weak var passwordTextField: FloatingLabelTextField!
    @IBOutlet weak var rememberMeButton: UIButton!
    
    private var viewModel: LoginViewModel?
    
    private let rMActiveImage = UIImage(named: "ic-checkbox-filled")
    private let rMInactiveImage = UIImage(named: "ic-checkbox-empty")
    private let hidePassImage = UIImage(named: "ic-hide-password")
    
    private let ShowSegue = "showTvShows"
    private var rememberMe: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel = LoginViewModel(completion: self.loginDone(_:))
        configureUI()
    }
    
    private func configureUI() {
        self.navigationController?.navigationBar.isHidden = true
        configureEmailField()
        configurePasswordField()
        configureRememberMeButton()
    }
    
    private func configureEmailField() {
        emailTextField.delegate = self
        emailTextField.text = viewModel?.email
    }
    
    private func configurePasswordField() {
        passwordTextField.delegate = self
        passwordTextField.text = viewModel?.password
        let rightButton  = UIButton(type: .custom)
        rightButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        rightButton.setImage(hidePassImage, for: .normal)
        passwordTextField.rightViewMode = .always
        passwordTextField.rightView = rightButton
        rightButton.addTarget(self, action: #selector(showHidePass), for: .touchUpInside)
               rememberMeButton.setImage(rMActiveImage, for: .normal)
    }
    
    private func configureRememberMeButton() {
        rememberMeButton.setImage(rMActiveImage, for: .normal)
    }
    
    
    private func loginDone(_ errorMessage: String?) {
        if let message = errorMessage {
              Common.presentErrorAlert(message, fromVC: self)
              return
        }
        performSegue(withIdentifier: ShowSegue, sender: self)
    }
    
    @objc private func showHidePass() {
        let val = passwordTextField.isSecureTextEntry
        passwordTextField.isSecureTextEntry = !val
    }
    
    @IBAction func rememberMePressed(_ sender: UIButton) {
        rememberMe = !rememberMe
        let image = rememberMe ? rMActiveImage : rMInactiveImage
        rememberMeButton.setImage(image, for: .normal)
        
    }
    
    @IBAction func loginPressed(_ sender: UIButton) {
        viewModel?.email = emailTextField.text
        viewModel?.password = passwordTextField.text
        viewModel?.rememberMe = rememberMe
        viewModel?.login()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction public func cancel(_ unwindSegue: UIStoryboardSegue) {
        
    }
}
