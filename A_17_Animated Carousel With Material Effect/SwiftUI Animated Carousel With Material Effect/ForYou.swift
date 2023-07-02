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
            
            HeaderView()
            
            // TODO: 使用这个也相当于 Spacer 用， 部分情况下
            GeometryReader { proxy in
                let size = proxy.size
                
                VerticalCarouselList {
                    // TODO: Card View
                    VStack(spacing: 0) {
                        ForEach(sample_datas) { movie in
                            CardView(movie: movie)
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
        ForYou()
    }
}



struct CardView: View {
    var movie: Movie
    var body: some View {
        // to get size for image
        // using geometry readering
        GeometryReader { proxy in
            let size = proxy.size
            ZStack {
                Image(movie.artwork)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size.width - 30, height: size.height - 80)
                    .cornerRadius(15)
            }
            .padding(.horizontal, 15)
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
        .padding(.vertical)
    }
}
