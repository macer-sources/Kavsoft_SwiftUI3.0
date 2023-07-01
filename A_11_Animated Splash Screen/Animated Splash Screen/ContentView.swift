//
//  ContentView.swift
//  Animated Splash Screen
//
//  Created by Kan Tao on 2023/5/5.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        SplashScreen(imageSize: .init(width: 128, height: 128)) {
           Home()
            
        } titleView: {
            Text("Chatty")
                .font(.system(size: 35).bold())
                .foregroundColor(.white)
        } logoView: {
            Image("Logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
        }navButton: {
            Button {
                
            } label: {
                Image("avator_1")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 40)
                    .frame(width: 40)
                    .clipShape(Circle())
                
            }

        }

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
