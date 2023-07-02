//
//  CustomTabBar.swift
//  SwiftUI Animated Carousel With Material Effect
//
//  Created by Kan Tao on 2023/6/16.
//

import SwiftUI

struct CustomTabBar: View {
    
    
    @Binding var current: Int
    
    var body: some View {
        HStack {
            TabBarButton(title: "For You", icon: "rectangle.portrait", tag: 0, current: $current)
            TabBarButton(title: "Search", icon: "magnifyingglass", tag: 1, current: $current)
            TabBarButton(title: "Following", icon: "bookmark", tag: 2, current: $current)
            TabBarButton(title: "Downloads", icon: "square.and.arrow.down", tag: 3, current: $current)
        }
        .frame(height: 60) // TODO: 通过设置 frame 可以实现内部的padding， 默认 HStack alignment 是剧中的
        .background(.ultraThinMaterial)
    }
}

struct CustomTabBar_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


struct TabBarButton: View {
    var title: String
    var icon: String
    var tag: Int
    
    @Binding var current: Int
    var body: some View {
        Button {
            withAnimation {
                current = tag
            }
        } label: {
            VStack(spacing: 5) {
                Image(systemName: icon)
                    .font(.title2)
                
                Text(title)
                    .font(.caption)
                    .fontWeight(.semibold)
            }
        }.tag(tag)
            .foregroundColor(tag == current ? .primary : .gray)
            .frame(maxWidth: .infinity)

    }
}
