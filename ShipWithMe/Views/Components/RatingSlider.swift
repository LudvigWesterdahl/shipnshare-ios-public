//
//  StarsSlider.swift
//  ShipWithMe
//
//  Created by Ludvig Westerdahl on 2021-05-30.
//

import SwiftUI

struct RatingSlider: View {
    
    @Binding private var selectedRating: Int
    
    @Namespace private var name
    
    init(selectedRating: Binding<Int>) {
        self._selectedRating = selectedRating
    }
    
    // Not working properly right now, SwiftUI bug.
    private func createButton(title: LocalizedStringKey, rating: Int) -> some View {
        return Button(action: {
            withAnimation(.spring()) {
                selectedRating = rating
            }
        }, label: {
            VStack {
                Text(title)
                    .font(.system(size: 14))
                    .fontWeight(.bold)
                    .foregroundColor(selectedRating == rating ? .black : .gray)
                
                ZStack {
                    Rectangle()
                        .opacity(0)
                        .frame(height: 4)
                    
                    if selectedRating == rating  {
                        Rectangle()
                            .fill(Color("ButtonBackground"))
                            .frame(height: 4)
                            .matchedGeometryEffect(id: "Tab", in: name)
                    }
                }
            }
        })
    }
    
    var body: some View {
        HStack {
            
            
            Button(action: {
                withAnimation(.spring()) {
                    selectedRating = 0
                }
            }, label: {
                VStack {
                    Text("bad-FC")
                        .font(.system(size: 14))
                        .fontWeight(.bold)
                        .foregroundColor(selectedRating == 0 ? .black : .gray)
                    
                    ZStack {
                        Rectangle()
                            .opacity(0)
                            .frame(height: 4)
                        
                        if selectedRating == 0  {
                            Rectangle()
                                .fill(Color("ButtonBackground"))
                                .frame(height: 4)
                                .matchedGeometryEffect(id: "Tab", in: name)
                        }
                    }
                }
            })
            
            Button(action: {
                withAnimation(.spring()) {
                    selectedRating = 1
                }
            }, label: {
                VStack {
                    Text("bad_but-FC")
                        .font(.system(size: 14))
                        .fontWeight(.bold)
                        .foregroundColor(selectedRating == 1 ? .black : .gray)
                    
                    ZStack {
                        Rectangle()
                            .opacity(0)
                            .frame(height: 4)
                        
                        if selectedRating == 1  {
                            Rectangle()
                                .fill(Color("ButtonBackground"))
                                .frame(height: 4)
                                .matchedGeometryEffect(id: "Tab", in: name)
                        }
                    }
                }
            })
            
            Button(action: {
                withAnimation(.spring()) {
                    selectedRating = 2
                }
            }, label: {
                VStack {
                    Text("good_but-FC")
                        .font(.system(size: 14))
                        .fontWeight(.bold)
                        .foregroundColor(selectedRating == 2 ? .black : .gray)
                    
                    ZStack {
                        Rectangle()
                            .opacity(0)
                            .frame(height: 4)
                        
                        if selectedRating == 2  {
                            Rectangle()
                                .fill(Color("ButtonBackground"))
                                .frame(height: 4)
                                .matchedGeometryEffect(id: "Tab", in: name)
                        }
                    }
                }
            })
            
            Button(action: {
                withAnimation(.spring()) {
                    selectedRating = 3
                }
            }, label: {
                VStack {
                    Text("good-FC")
                        .font(.system(size: 14))
                        .fontWeight(.bold)
                        .foregroundColor(selectedRating == 3 ? .black : .gray)
                    
                    ZStack {
                        Rectangle()
                            .opacity(0)
                            .frame(height: 4)
                        
                        if selectedRating == 3  {
                            Rectangle()
                                .fill(Color("ButtonBackground"))
                                .frame(height: 4)
                                .matchedGeometryEffect(id: "Tab", in: name)
                        }
                    }
                }
            })
        }
    }
}

struct RatingSliderPreview: View {
    
    @State private var selectedRating: Int = 1
    
    var body: some View {
        RatingSlider(selectedRating: $selectedRating)
    }
}


struct RatingSlider_Previews: PreviewProvider {
    
    
    static var previews: some View {
        RatingSliderPreview()
    }
}
