//
//  LoginViewModel.swift
//  tv.shows
//
//  Created by Alina Nicorescu on 23/06/2020.
//  Copyright © 2020 Alina Nicorescu. All rights reserved.
//

import Foundation

class LoginViewModel {
    
    var email: String?
    var password: String?
    var rememberMe: Bool
    private var completion: (String?) -> Void
    
    init(completion: @escaping (String?) -> Void) {
        self.completion = completion
        self.email = UserDefaults.standard.string(forKey: Common.UserEmailKey)
        self.password =  UserDefaults.standard.string(forKey: Common.UserPasswordKey)
        self.rememberMe =  UserDefaults.standard.bool(forKey: Common.RememberMeKey)
    }
   
    public func login() {
        guard let userEmail = email, userEmail.isEmail else {
            completion("Please enter a non empty valid email")
            return
        }
        guard let password = password else {
            completion("Please enter a non empty password")
            return
        }
        if self.rememberMe {
            saveToUserDefaults()
        } else {
            resetUserDefaults()
        }
        APIService.shared.loginUser(userEmail: userEmail, password: password) {[weak self] error in
            if let error = error  {
                debugPrint("Error on login \(error.localizedDescription)")
                self?.completion("An error occurred while login")
            } else{
                self?.completion(nil)
            }
        }
    }
    
    private func saveToUserDefaults() {
        UserDefaults.standard.set(rememberMe, forKey: Common.RememberMeKey)
        UserDefaults.standard.set(email, forKey: Common.UserEmailKey)
        UserDefaults.standard.set(password, forKey: Common.UserPasswordKey)
    }
    
    private func resetUserDefaults() {
        UserDefaults.standard.set(false, forKey: Common.RememberMeKey)
        UserDefaults.standard.removeObject(forKey: Common.UserEmailKey)
        UserDefaults.standard.removeObject(forKey: Common.UserPasswordKey)
    }
}
