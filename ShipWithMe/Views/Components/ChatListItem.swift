//
//  ChatListItem.swift
//  ShipWithMe
//
//  Created by Ludvig Westerdahl on 2021-05-29.
//

import SwiftUI

struct ChatListItem: View {
    
    @State private var pressing: Bool = false
    
    let model: ChatPostModel
    
    let pressed: () -> Void
    
    var body: some View {
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
                
                if let lastMessage = model.chat.messages.last {
                    HStack {
                        Text("last_message-FC-K")
                            .font(.system(size: 12))
                        
                        Text(lastMessage.createdAt.readableLocalized())
                            .font(.system(size: 12, weight: .bold))
                        
                        if model.canReview && model.chat.closed {
                            Spacer()
                            Text("leave_a_review-FC-E")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(Color("ButtonBackground"))
                        }
                    }
                } else {
                    Text("new-FC")
                        .font(.system(size: 12))
                }
            }
            
            Spacer()
            
            
        }
        .background(pressing ? Color("TextFieldBackground").opacity(0.7) : .clear)
        .onLongPressGesture(minimumDuration: 10, maximumDistance: 50, pressing: { pressing in
            if pressing && !self.pressing {
                withAnimation(.easeIn(duration: 0.15)) {
                    self.pressing = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                    self.pressing = false
                    pressed()
                }
            }
            
        }, perform: {
            
        })
    }
}

struct ChatListItem_Previews: PreviewProvider {
    static var previews: some View {
        ChatListItem(model: ChatPostModel(chat: ChatModel.dummyChat(),
                                          post: PostModel.dummyPost(),
                                          canReview: true)) {
            
        }
    }
}
