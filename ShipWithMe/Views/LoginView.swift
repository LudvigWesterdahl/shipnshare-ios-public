//
//  LoginView.swift
//  ShipWithMe
//
//  Created by Ludvig Westerdahl on 2021-03-13.
//

import SwiftUI

struct LoginView: View {
    
    @State private var loggedIn: Bool = false
    
    @StateObject private var vm: LoginViewModel = LoginViewModel()
    
    @State private var showConfirmEmailAlert: Bool = false
    
    @State private var showUserNameEmailAlreadyInUseAlert: Bool = false
    
    @State private var showInvalidEmailOrPasswordAlert: Bool = false
    
    init() {
        
    }
    
    var body: some View {
        VStack {
            Spacer()
            
            ImageTextField(systemName: "envelope", hint: "email-FC", text: $vm.email)
                .keyboardType(.emailAddress)
                .disableAutocorrection(true)
                .autocapitalization(.none)
            
            PasswordField("password-FC", text: $vm.password)
            
            VStack {
                SheetButton(title: "forgot_password-AC",
                            label: Text("forgot_password-FC-Q")
                                .fontWeight(.medium)
                                .foregroundColor(Color("ButtonBackground")),
                            content: {
                                VStack {
                                    Spacer()
                                    
                                    ImageTextField(systemName: "envelope", hint: "email-FC", text: $vm.resetPasswordEmail)
                                        .keyboardType(.emailAddress)
                                        .disableAutocorrection(true)
                                    
                                    Button(action: {
                                        vm.resetPassword { success in
                                            if success {
                                                StorageManager.email = vm.resetPasswordEmail
                                                vm.loadStoredEmail()
                                                showConfirmEmailAlert = true
                                            }
                                        }
                                    }, label: {
                                        Text("send-FC")
                                            .fontWeight(.medium)
                                            .foregroundColor(Color("ButtonText"))
                                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    })
                                    .disabled(vm.loading)
                                    .buttonStyle(FilledButtonStyle(cornerRadius: 40))
                                    .frame(height: 55)
                                    .padding(.horizontal, 32)
                                    .padding(.vertical, 16)
                                    .alert(isPresented: $showConfirmEmailAlert, content: {
                                        Alert(title: Text("check_your_email_for_confirmation-FC-E"),
                                              dismissButton: .default(Text("close-FC"), action: {
                                                
                                              }))
                                    })
                                    Spacer()
                                }
                                .background(Color.white)
                                .onTapGesture {
                                    UIApplication.shared.endEditing()
                                }
                            })
                Button(action: {
                    vm.authenticate { success in
                        self.loggedIn = success
                        
                        if !success {
                            showInvalidEmailOrPasswordAlert = true
                        }
                    }
                    
                }, label: {
                    
                    if vm.loading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: Color("ButtonText")))
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        Text("sign_in-FC")
                            .fontWeight(.medium)
                            .foregroundColor(Color("ButtonText"))
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                })
                .buttonStyle(FilledButtonStyle(cornerRadius: 40))
                .frame(height: 55)
                .padding(.top, 8)
                .alert(isPresented: $showInvalidEmailOrPasswordAlert, content: {
                    Alert(title: Text("invalid_email_or_password-FC"),
                          dismissButton: .default(Text("close-FC"), action: {
                            
                          }))
                })
            }
            .padding([.top, .bottom], 8)
            .padding([.leading, .trailing], 16)
            
            NavigationLink("", destination: ContentView(), isActive: $vm.alreadySignedIn)
                .labelsHidden()
                .fixedSize()
            
            NavigationLink("", destination: ContentView(), isActive: $loggedIn)
                .labelsHidden()
                .fixedSize()
            
            HStack {
                Text("Don't have an account?")
                
                SheetButton(title: "sign_up-AC",
                            label: Text("sign_up-FC")
                                .fontWeight(.medium)
                                .foregroundColor(Color("ButtonBackground")),
                            content: {
                                VStack {
                                    Spacer()
                                    
                                    ImageTextField(systemName: "person", hint: "username-FC", text: $vm.newUserName)
                                        .keyboardType(.alphabet)
                                        .disableAutocorrection(true)
                                        .autocapitalization(.none)
                                    
                                    ImageTextField(systemName: "envelope", hint: "email-FC", text: $vm.newEmail)
                                        .disableAutocorrection(true)
                                        .keyboardType(.emailAddress)
                                        .autocapitalization(.none)
                                    
                                    PasswordField("password-FC", text: $vm.newPassword)
                                        .alert(isPresented: $showConfirmEmailAlert, content: {
                                            Alert(title: Text("check_your_email_for_confirmation-FC-E"),
                                                  dismissButton: .default(Text("close-FC"), action: {
                                                    
                                                  }))
                                        })
                                    
                                    Button(action: {
                                        vm.register { success in
                                            if success {
                                                StorageManager.email = vm.newEmail
                                                vm.loadStoredEmail()
                                                showConfirmEmailAlert = true
                                            } else {
                                                showUserNameEmailAlreadyInUseAlert = true
                                            }
                                        }
                                    }, label: {
                                        Text("send-FC")
                                            .fontWeight(.medium)
                                            .foregroundColor(Color("ButtonText"))
                                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    })
                                    .disabled(vm.loading)
                                    .buttonStyle(FilledButtonStyle(cornerRadius: 40))
                                    .frame(height: 55)
                                    .padding(.horizontal, 32)
                                    .padding(.vertical, 16)
                                    .alert(isPresented: $showUserNameEmailAlreadyInUseAlert, content: {
                                        Alert(title: Text("email_or_username_is_already_in_use-FC-S"),
                                              dismissButton: .default(Text("close-FC"), action: {
                                                
                                              }))
                                    })
                                    
                                    Spacer()
                                }
                                .background(Color.white)
                                .onTapGesture {
                                    UIApplication.shared.endEditing()
                                }
                            })
            }
            .padding(16)
            
            Spacer()
            
            if !InfoHelper.isRelease {
                HStack {
                    Text(InfoHelper.buildType)
                        .fontWeight(.bold)
                    Text("-")
                    Text("version_{1}-NC \(InfoHelper.appVersion)")
                }
                .font(.system(size: 14, weight: .bold, design: .default))
                .padding(.bottom, 8)
            }
        }
        .navigationBarTitle("Ship n Share")
        .background(Color.white)
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
        .onAppear {
            vm.loadStoredEmail()
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
