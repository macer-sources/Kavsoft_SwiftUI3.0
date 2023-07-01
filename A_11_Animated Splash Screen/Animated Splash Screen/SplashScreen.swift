//
//  SplashScreen.swift
//  Animated Splash Screen
//
//  Created by Kan Tao on 2023/6/15.
//

import SwiftUI

struct SplashScreen<Content: View, Title: View, Logo: View, NavButton: View>: View {
    
    var content: Content
    var titleView: Title
    var logoView: Logo
    var navButton: NavButton
    
    var imageSize: CGSize = .zero
    
    init(imageSize: CGSize, @ViewBuilder content:@escaping() -> Content ,@ViewBuilder titleView: @escaping() -> Title,@ViewBuilder logoView: @escaping () -> Logo, navButton: @escaping() -> NavButton) {
        self.content = content()
        self.titleView = titleView()
        self.logoView = logoView()
        self.navButton = navButton()
        self.imageSize = imageSize
    }
    
    
    @State var textAnimation = false
    @State var logoAnimation = false
    @State var endAnimation = false
    
    @State var showNavButton = false
    
    @Namespace var animation
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Color("Purple")
                    .background(Color("Purple"))
                    .overlay {
                        ZStack {
                            titleView
                                .scaleEffect(endAnimation ? 0.75 : 1)
                                .offset(y: textAnimation ? -5 : 110)
                            
                            if !endAnimation {
                                logoView
                                    .matchedGeometryEffect(id: "Logo", in: animation)
                                    .frame(width: imageSize.width, height: imageSize.height)
                            }
                            
                        }
                    }
                    .overlay {
                        // 移动到右侧作为 nav button
                        HStack {
                            navButton
                                .opacity(showNavButton ? 1: 0)
                            
                            Spacer()
                            if endAnimation {
                                logoView
                                    .matchedGeometryEffect(id: "Logo", in: animation)
                                    .frame(width: 30, height: 30)
                                    .offset(y: -5)
                            }
                            
                        }
                        .padding(.horizontal)
                        
                    }
            }
            .frame(height: endAnimation ? 60 : nil)
            .zIndex(1)
            
            content
                .frame(height: endAnimation ? nil : 0)
                .zIndex(0)
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .onAppear {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                withAnimation(.spring()) {
                    textAnimation.toggle()
                }
                withAnimation(.interactiveSpring(response: 0.6,dampingFraction: 1, blendDuration: 1)) {
                    endAnimation.toggle()
                }
                // showing affter some delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                    withAnimation {
                        showNavButton.toggle()
                    }
                }
            }
        }
        
        
    }
}

struct SplashScreen_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
