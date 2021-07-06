import SwiftUI
import CoreLocation

struct CreatePostView: View {
    
    @StateObject var vm: CreatePostViewModel = CreatePostViewModel()
    
    @State var showAction: Bool = false
    @State var showImagePicker: Bool = false
    
    @State var showTitleHelp: Bool = false
    @State var showDescriptionHelp: Bool = false
    @State var showShippingAddressHelp: Bool = false
    @State var showShippingCostHelp: Bool = false
    @State var showCurrencyHelp: Bool = false
    
    @State var clickedDescription: Bool = false
    
    init() {
        UITextView.appearance().backgroundColor = .clear
    }
    
    var sheet: ActionSheet {
        ActionSheet(
            title: Text("change_or_remove_image-FC"),
            message: Text("\(vm.image!.imageOrientation.rawValue)"),
            buttons: [
                .default(Text("change-FC"), action: {
                    self.showAction = false
                    self.showImagePicker = true
                }),
                .cancel(Text("close-FC"), action: {
                    self.showAction = false
                }),
                .destructive(Text("remove-FC"), action: {
                    self.showAction = false
                    self.vm.image = nil
                })
            ])
        
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("select_an_optional_screenshot_image-FC")
                    .padding(.vertical, 8)
                VStack {
                    if (vm.image == nil) {
                        Button(action: {
                            self.showImagePicker = true
                        }, label: {
                            Image(systemName: "camera.on.rectangle")
                                .accentColor(Color("Subtitle"))
                        })
                        .frame(width: 100, height: 100)
                        .background(Color("TextFieldBackground"))
                        .cornerRadius(6)
                        
                    } else {
                        Image(uiImage: vm.image!)
                            .resizable()
                            .frame(width: 100, height: 100)
                            .cornerRadius(6)
                            .onTapGesture {
                                self.showAction = true
                            }
                    }
                    
                }
                .frame(width: 100, height: 100)
                .shadow(radius: 2)
                .sheet(isPresented: $showImagePicker, onDismiss: {
                    self.showImagePicker = false
                }, content: {
                    ImagePicker(isShown: $showImagePicker, uiImage: $vm.image)
                })
                .actionSheet(isPresented: $showAction) {
                    sheet
                }
                
                LineDivider()
                
                VStack (alignment: .leading) {
                    Group {
                        HStack {
                            Text("title_or_website-FC")
                            
                            Spacer()
                            
                            Button(action: {
                                showTitleHelp = true
                            }, label: {
                                Image(systemName: "info.circle")
                                    .foregroundColor(Color("Subtitle"))
                            })
                            .alert(isPresented: $showTitleHelp, content: {
                                Alert(title: Text("title_or_website-FC"),
                                      message: Text("title_or_website-DESC"),
                                      dismissButton: .default(Text("Ok")))
                            })
                        }
                        
                        
                        TextField("", text: $vm.title, onEditingChanged: { editing in
                            
                        })
                        .disableAutocorrection(true)
                        .padding(.leading, 8)
                        .frame(height: 40)
                        .background(Color("TextFieldBackground"))
                        .cornerRadius(10)
                        .shadow(radius: 2)
                        
                        HStack {
                            Spacer()
                            Text("\(vm.title.count)/60")
                                .font(.system(size: 12, weight: Font.Weight.medium))
                                .foregroundColor(vm.title.count > 60 ? Color("InvalidRed") : .black)
                        }
                        
                        LineDivider()
                    }
                    
                    Group {
                        HStack {
                            Text("description-FC")
                            
                            Spacer()
                            
                            Button(action: {
                                showDescriptionHelp = true
                            }, label: {
                                Image(systemName: "info.circle")
                                    .foregroundColor(Color("Subtitle"))
                            })
                            .alert(isPresented: $showDescriptionHelp, content: {
                                Alert(title: Text("description-FC"),
                                      message: Text("description-DESC"),
                                      dismissButton: .default(Text("Ok")))
                            })
                        }
                        
                        TextEditor(text: $vm.description)
                            .padding(.leading, 2)
                            .frame(height: 100)
                            .background(Color("TextFieldBackground"))
                            .cornerRadius(10)
                            .shadow(radius: 2)
                            .disableAutocorrection(false)
                        
                        LineDivider()
                    }
                    
                    Group {
                        HStack {
                            Text("shipping_address-FC")
                            
                            Spacer()
                            
                            Button(action: {
                                showShippingAddressHelp = true
                            }, label: {
                                Image(systemName: "info.circle")
                                    .foregroundColor(Color("Subtitle"))
                            })
                            .alert(isPresented: $showShippingAddressHelp, content: {
                                Alert(title: Text("shipping_address-FC"),
                                      message: Text("shipping_address-DESC"),
                                      dismissButton: .default(Text("Ok")))
                            })
                        }
                        
                        AddressSearchBar(searchResultString: $vm.shippingAddress, onAddress: vm.onAddress)
                        
                        LineDivider()
                    }
                    
                    Group {
                        HStack {
                            Text("shipping_cost-FC")
                            
                            Spacer()
                            
                            Button(action: {
                                showShippingCostHelp = true
                            }, label: {
                                Image(systemName: "info.circle")
                                    .foregroundColor(Color("Subtitle"))
                            })
                            .alert(isPresented: $showShippingCostHelp, content: {
                                Alert(title: Text("shipping_cost-FC"),
                                      message: Text("shipping_cost-DESC"),
                                      dismissButton: .default(Text("Ok")))
                            })
                        }
                        
                        TextField("", text: $vm.shippingCost, onEditingChanged: { editing in
                            
                        })
                        .disableAutocorrection(true)
                        .keyboardType(.decimalPad)
                        .padding(.leading, 8)
                        .frame(height: 40)
                        .background(Color("TextFieldBackground"))
                        .cornerRadius(10)
                        .shadow(radius: 2)
                        
                        LineDivider()
                    }
                    
                    Group {
                        HStack {
                            Text("currency-FC")
                            
                            Spacer()
                            
                            Button(action: {
                                showCurrencyHelp = true
                                //self.presentationMode.wrappedValue.dismiss()
                            }, label: {
                                Image(systemName: "info.circle")
                                    .foregroundColor(Color("Subtitle"))
                            })
                            .alert(isPresented: $showCurrencyHelp, content: {
                                Alert(title: Text("currency-FC"),
                                      message: Text("currency-DESC"),
                                      dismissButton: .default(Text("Ok")))
                            })
                        }
                        
                        Picker(selection: $vm.currency, label: Text("currency-FC")) {
                            ForEach(vm.currencies, id: \.self) { code in
                                Text(code)
                                    .tag(code)
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .background(Color("TextFieldBackground"))
                        .cornerRadius(10)
                        .shadow(radius: 2)
                        
                        LineDivider()
                    }
                }
                
                HStack {
                    
                    Button(action: {
                        vm.reset()
                    }, label: {
                        Text("Reset")
                            .fontWeight(.medium)
                            .foregroundColor(Color("ButtonBackground"))
                    })
                    .padding(.trailing, 32)
                    
                    Button(action: {
                        vm.createPost()
                    }, label: {
                        ZStack (alignment: Alignment(horizontal: .center, vertical: .center)) {
                            if vm.isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: Color("ButtonText")))
                            } else {
                                Text("Post")
                                    .fontWeight(.medium)
                                    .foregroundColor(Color("ButtonText"))
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    })
                    .disabled(!vm.isValid || vm.isLoading)
                    .shadow(radius: 2)
                    .buttonStyle(FilledButtonStyle(cornerRadius: 40,
                                                   fillColor: vm.isValid ? Color("ButtonBackground") : Color("ButtonDisabledBackground"),
                                                   pressedFillColor: vm.isValid ? Color("ButtonPressedBackground") : Color("ButtonDisabledBackground")))
                    .frame(height: 55)
                    .alert(isPresented: $vm.wasPostUploaded, content: {
                        Alert(title: Text(vm.postUploadSuccess! ? "Success" : "Failure"),
                              message: Text(vm.postUploadSuccess! ? "Post was uploaded" : "Something went wrong"),
                              dismissButton: .default(Text("Ok")) {
                                if vm.postUploadSuccess! {
                                    vm.reset()
                                }
                              })
                    })
                }
            }
            .padding(.all, 16)
        }
        .padding(.top, 1)
        .background(Color.white)
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
    }
}

struct CreatePostView_Previews: PreviewProvider {
    static var previews: some View {
        CreatePostView()
    }
}
