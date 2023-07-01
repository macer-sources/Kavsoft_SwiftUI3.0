//
//  Home.swift
//  instagram reels
//
//  Created by Kan Tao on 2023/6/15.
//

import SwiftUI

struct Home: View {
    
    init() {
        UITabBar.appearance().isHidden  = true
    }
    
    @State var currentTab = "video.badge.plus"
    
    
    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $currentTab) {
                Text("Home")
                    .tag("house.fill")
                Text("Search")
                    .tag("magnifyingglass")
                ReelsView()
                    .tag("video.badge.plus")
                Text("Liked")
                    .tag("suit.heart")
                Text("Profile")
                    .tag("person.circle")
            }
            
            // 自定义的 TabBar
            HStack(spacing: 0) {
                ForEach(["house.fill","magnifyingglass","video.badge.plus", "suit.heart", "person.circle"], id: \.self) { image in
                    TabBarButton(image: image, isSystemImage: true, currentTab: $currentTab)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
            .overlay(Divider(), alignment: .top)
            .background(currentTab == "video.badge.plus" ? .black : .clear)
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}



// Tab Bar Button
struct TabBarButton: View {
    var image: String
    var isSystemImage: Bool
    @Binding var currentTab: String
    
    
    var body: some View {
        Button {
            withAnimation {
                currentTab = image
            }
        } label: {
            ZStack {
                if isSystemImage {
                    Image(systemName: image)
                        .font(.title2)
                }else {
                    Image(image)
                        .resizable()
                        .renderingMode(.template)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 25, height: 25)
                }
            }
            .foregroundColor(currentTab == image ? currentTab == "video.badge.plus" ? .white : .primary : .gray)
            .frame(maxWidth: .infinity)
        }

    }
}
