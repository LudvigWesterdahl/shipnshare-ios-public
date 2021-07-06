//
//  PostListItem.swift
//  ShipWithMe
//
//  Created by Ludvig Westerdahl on 2021-06-06.
//

import SwiftUI

struct PostListItem: View {
    
    let post: PostModel
    
    let onDelete: () -> Void

    var body: some View {
        HStack {
            if let imageData = post.imageData {
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
                Text(post.offerValueTitle)
                Text(post.createdAt.readableLocalized())
                    .font(.system(size: 12))
            }
            
            Spacer()
            
            Button(action: {
                onDelete()
            }, label: {
                Text("delete_post-FC")
                    .foregroundColor(Color("ButtonText"))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
            })
            .buttonStyle(FilledButtonStyle(cornerRadius: 40))
        }
    }
}

struct PostListItem_Previews: PreviewProvider {
    static var previews: some View {
        PostListItem(post: PostModel.dummyPost()) {
            
        }
    }
}
