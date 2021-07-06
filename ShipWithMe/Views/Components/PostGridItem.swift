//
//  PostGridItem.swift
//  ShipWithMe
//
//  Created by Ludvig Westerdahl on 2021-04-18.
//

import SwiftUI

struct PostGridItem: View {
    
    let post: PostModel
    
    let pressed: () -> Void
    
    @State private var pressing: Bool = false
    
    /*
    func distance() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 1
        let lengthFormatter = LengthFormatter()
        lengthFormatter.numberFormatter = numberFormatter
        return lengthFormatter.string(fromMeters: post.metersToPickupLocation)
    }
    
    func shipping() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 1
        numberFormatter.numberStyle = .currency
        numberFormatter.currencyCode = post.currency
        
        return numberFormatter.string(from: post.shippingCost as! NSDecimalNumber)!
    }
    
    
    func created() -> LocalizedStringKey {
        let dateFormatter = DateFormatter()
        
        let now = Date()
        let createdAt = post.createdAt
        let diff = createdAt.distance(to: now)
        
        if Calendar.current.isDateInToday(createdAt) {
            dateFormatter.dateStyle = .none
            dateFormatter.timeStyle = .short
            return "today_at_{1}-FC \(dateFormatter.string(from: createdAt))"
        }
        
        if Calendar.current.isDateInYesterday(post.createdAt) {
            dateFormatter.dateStyle = .none
            dateFormatter.timeStyle = .short
            return "yesterday_at_{1}-FC \(dateFormatter.string(from: createdAt))"
        }
        
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        dateFormatter.timeZone = TimeZone.current
        //dateFormatter.dateFormat = DateFormatter.defaultFormat
        return LocalizedStringKey(dateFormatter.string(from: createdAt))
    }
     */
    
    var body: some View {
        VStack {
            if let imageData = post.imageData {
                let uiImage = UIImage(data: imageData)!
                Image(uiImage: uiImage)
                    .interpolation(.none)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: min(uiImage.size.height * uiImage.scale, 100))
            } else {
                let uiImage = UIImage(named: "Placeholder")!
                Image(uiImage: uiImage)
                    .interpolation(.none)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: min(uiImage.size.height * uiImage.scale, 100))
            }
            
            Text(post.offerValueTitle)
                .foregroundColor(Color.black)
            HStack {
                Image(systemName: "mappin")
                    .font(.system(size: 12))
                    .foregroundColor(Color.black)
                Text(post.readableMetersToPickupLocation())
                    .font(.system(size: 14))
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .padding(.trailing, 4)
                    .foregroundColor(Color.black)
                Image(systemName: "seal")
                    .font(.system(size: 12))
                    .padding(.leading, 4)
                    .foregroundColor(Color.black)
                Text(post.readableShippingCost())
                    .font(.system(size: 14))
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .foregroundColor(Color.black)
            }
            
            HStack {
                Text(post.createdAt.readableLocalized())
                    .font(.system(size: 12))
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .foregroundColor(Color.black)
                Spacer()
                
                if post.ownerUserName == StorageManager.userName {
                    Text("your_post-NC")
                        .font(.system(size: 12))
                        .foregroundColor(Color("ButtonBackground"))
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                }
                
            }
            .padding(8)
        }
        .frame(maxHeight: 200)
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

struct PostGridItem_Previews: PreviewProvider {
    
    static var previews: some View {
        PostGridItem(post: PostModel.dummyPost()) {
            
        }
    }
}
