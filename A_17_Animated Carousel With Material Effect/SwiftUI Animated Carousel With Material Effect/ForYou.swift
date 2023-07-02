//
//  ForYou.swift
//  SwiftUI Animated Carousel With Material Effect
//
//  Created by Kan Tao on 2023/6/16.
//

import SwiftUI

struct ForYou: View {
    var topEdge: CGFloat
    
    var body: some View {
        VStack(spacing: 15) {
            
            HeaderView()
            
            // TODO: 使用这个也相当于 Spacer 用， 部分情况下
            GeometryReader { proxy in
                let size = proxy.size
                
                VerticalCarouselList {
                    // TODO: Card View
                    VStack(spacing: 0) {
                        ForEach(sample_datas) { movie in
                            // 70 = title View
                            // 15 = spacing
                            CardView(movie: movie, topOffset: 70 + 15 + topEdge)
                                .frame(height: size.height)
                        }
                    }
                    
                }
            }
            
        }
        
        
    }
}

struct ForYou_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



struct CardView: View {
    var movie: Movie
    var topOffset: CGFloat
    var body: some View {
        // to get size for image
        // using geometry readering
        GeometryReader { proxy in
            let size = proxy.size
            
            // Scaling and opactiy effect...
            let minY = proxy.frame(in: .global).minY - topOffset
            
            let progress = -minY / size.height
            
            // increasing scale by 3
            let scale = 1 - (progress / 3)
            
            // why this is happening..
            // bcz we need to eleminate top offset
            // to get started from 0....
            
            let opactiy = 1 - progress
            
            ZStack {
                Image(movie.artwork)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size.width - 30, height: size.height - 80)
                    .cornerRadius(15)
            }
            .padding(.horizontal, 15)
            .scaleEffect(minY < 0 ?  scale :  1)
            .opacity(minY < 0 ? opactiy :  1)
            // stopping view when y value goes < 0
            .offset(y: minY < 0 ? -minY : 0)
        }
       
        
    }
}

struct HeaderView: View {
    var body: some View {
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
        // Setting maxheight for offset calculation...
        .frame(height: 70)
    }
}
