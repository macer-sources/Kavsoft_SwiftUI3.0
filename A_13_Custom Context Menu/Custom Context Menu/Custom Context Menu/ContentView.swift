//
//  ContentView.swift
//  Custom Context Menu
//
//  Created by work on 6/15/23.
//

import SwiftUI

struct ContentView: View {
    
    @State var onEnd = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                CustomContextMenu {
                    Label {
                        Text("Unlock Me")
                    }icon: {
                        Image(systemName: "lock.fill")
                    }
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 20)
                    .background(.purple)
                    .cornerRadius(8)
                } preview: {
                    
                    // Preview
                    Image("image2")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                    
                } actions: {
                    let like = UIAction.init(title: "Like Me", image: UIImage.init(systemName: "suit.heart.fill")) { _ in
                        print("like")
                    }
                    
                    let share = UIAction.init(title: "Share", image: UIImage.init(systemName: "square.and.arrow.up.fill")) { _ in
                        print("share")
                    }
                    
                    return UIMenu.init(title: "", children: [like, share])
                    
                    
                }onEnd: {
                    withAnimation {
                        onEnd.toggle()
                    }
                }
                
                
                if onEnd {
                    GeometryReader { proxy in
                        let size = proxy.size
                        
                        Image("image2")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: size.width, height: size.height)
                            .cornerRadius(1)
                    }
                    .ignoresSafeArea(.all, edges: .bottom)
                    // removing opacity animation
                    .transition(.identity)
                    .toolbar {
                        ToolbarItem.init(placement: .navigationBarTrailing) {
                            Button("Close") {
                                withAnimation {
                                    onEnd.toggle()
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle(onEnd ?  "Unlocked": "Custom Context menu")
            .navigationBarTitleDisplayMode(onEnd ? .inline : .large)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
