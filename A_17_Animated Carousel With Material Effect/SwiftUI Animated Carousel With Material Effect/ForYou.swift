//
//  ForYou.swift
//  SwiftUI Animated Carousel With Material Effect
//
//  Created by Kan Tao on 2023/6/16.
//

import SwiftUI

struct ForYou: View {
    var body: some View {
        VStack {
            
            HStack {
                
                Text("Today For You")
                    .font(.title.bold())
                
                Spacer(minLength: 20)
                
                
                Button {
                    
                } label: {
                    Image(systemName: "person.circle")
                        .font(.title)
                        .foregroundColor(.gray)
                        .overlay(
                            Circle()
                                .fill(.red)
                                .frame(width: 13, height: 13)
                                .offset(x: -1, y: -1),
                            alignment: .topTrailing)
                }

            }
            .padding(.horizontal)
            .padding(.vertical)
            
            // TODO: 使用这个也相当于 Spacer 用， 部分情况下
            GeometryReader { proxy in
                VerticalCarouselList {
                    // TODO: Card View
                    
                    
                }
            }
            
        }
        
        
    }
}

struct ForYou_Previews: PreviewProvider {
    static var previews: some View {
        ForYou()
    }
}



struct CardView: View {
    var body: some View {
        EmptyView()
    }
}
