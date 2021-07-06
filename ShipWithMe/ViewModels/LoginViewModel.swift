//
//  LoginViewModel.swift
//  ShipWithMe
//
//  Created by Ludvig Westerdahl on 2021-03-20.
//

import Foundation

class LoginViewModel: ObservableObject {
    
    @Published var loading: Bool = false
    
    @Published var alreadySignedIn: Bool = false
    
    @Published var email: String = ""
    
    @Published var password: String = ""
    
    @Published var newEmail: String = ""
    
    @Published var newUserName: String = ""
    
    @Published var newPassword: String = ""
    
    @Published var resetPasswordEmail: String = ""
    
    init() {
        self.email = StorageManager.email ?? ""
        
        if StorageManager.refreshToken != nil && StorageManager.token != nil {
            self.loading = true
            
            ApiManager.shared.tryAuthenticate { success in
                DispatchQueue.main.async {
                    self.alreadySignedIn = success
                    self.loading = false
                }
            }
        }
        
        // To force server to start again.
        ApiManager.shared.getTimezones { success in
            print("Received timezones: \(success)")
        }
    }
    
    func loadStoredEmail() -> Void {
        self.email = StorageManager.email ?? ""
    }
    
    func authenticate(completion: @escaping (Bool) -> Void) -> Void {
        
        self.loading = true
        
        ApiManager.shared.authenticate(self.email, self.password) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let result):
                    if result {
                        StorageManager.email = self.email
                        self.password = ""
                        completion(true)
                    } else {
                        completion(false)
                    }
                    
                case .failure:
                    completion(false)
                }
                self.loading = false
            }
        }
    }
    
    func register(completion: @escaping (Bool) -> Void) -> Void {
        self.loading = true
        
        ApiManager.shared.register(email: newEmail, userName: newUserName, password: newPassword) { success in
            DispatchQueue.main.async {
                self.loading = false
                completion(success)
            }
        }
    }
    
    func resetPassword(completion: @escaping (Bool) -> Void) -> Void {
        self.loading = true
        
        ApiManager.shared.resetPassword(email: resetPasswordEmail) { success in
            DispatchQueue.main.async {
                self.loading = false
                completion(success)
            }
        }
    }
}
