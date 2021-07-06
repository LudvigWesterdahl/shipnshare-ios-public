//
//  ChatRequestListItem.swift
//  ShipWithMe
//
//  Created by Ludvig Westerdahl on 2021-05-30.
//

import SwiftUI

struct ChatRequestListItem: View {
    
    let model: ChatRequestPostModel
    
    let answered: (Bool) -> Void
    
    var body: some View {
        VStack {
            HStack {
                if let imageData = model.post.imageData {
                    let uiImage = UIImage(data: imageData)!
                    Image(uiImage: uiImage)
                        .interpolation(.none)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: min(uiImage.size.height * uiImage.scale, 50))
                } else {
                    let uiImage = UIImage(named: "Placeholder")!
                    Image(uiImage: uiImage)
                        .interpolation(.none)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: min(uiImage.size.height * uiImage.scale, 50))
                }
                
                VStack (alignment: .leading) {
                    Text(model.post.offerValueTitle)
                    Text(model.chatRequest.fromUserName)
                        .font(.system(size: 12, weight: .bold))
                }
                
                Spacer()
                
            }
            
            HStack {
                Button(action: {
                    answered(false)
                }, label: {
                    Text("decline-FC")
                        .fontWeight(.medium)
                        .foregroundColor(Color("ButtonBackground"))
                        .padding(.horizontal, 32)
                        .padding(.vertical, 8)
                })
                
                Spacer()
                
                Button(action: {
                    answered(true)
                }, label: {
                    Text("accept-FC")
                        .fontWeight(.medium)
                        .foregroundColor(Color("ButtonText"))
                        .padding(.horizontal, 32)
                        .padding(.vertical, 8)
                })
                .buttonStyle(FilledButtonStyle(cornerRadius: 40))
                .padding(.trailing, 16)
            }
            
        }
    }
}

struct ChatRequestListItem_Previews: PreviewProvider {
    static var previews: some View {
        ChatRequestListItem(model: ChatRequestPostModel(chatRequest: ChatRequestModel.dummyChatRequest(),
                                                        post: PostModel.dummyPost())) { accepted in
            
        }
    }
}
