//
//  ContentView.swift
//  SwiftUI Animated Carousel With Material Effect
//
//  Created by Kan Tao on 2023/6/16.
//

import SwiftUI

struct ContentView: View {
    @State var current: Int = 0
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        TabView(selection: $current) {
            GeometryReader(content: { proxy in
                let topEdge = proxy.safeAreaInsets.top
                
                ForYou(topEdge: topEdge)
                    .padding(.top, topEdge)
                    .ignoresSafeArea(.all, edges: .top)
            })
                .tag(0)
            Text("Search")
                .tag(1)
            Text("Following")
                .tag(2)
            Text("Downloads")
                .tag(3)
        }
        .overlay(
            // custom Tab bar
            CustomTabBar(current: $current)
            , alignment: .bottom)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
