//
//  Home.swift
//  7.Weatcher App Scroll Effect
//
//  Created by Kan Tao on 2023/4/24.
//

import SwiftUI

struct Home: View {
    var body: some View {
        GeometryReader { proxy in
            let topEdge = proxy.safeAreaInsets.top
            ContentView(topEdge: topEdge).ignoresSafeArea(.all, edges: .top)
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
