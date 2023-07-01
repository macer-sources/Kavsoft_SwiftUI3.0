//
//  ContentView.swift
//  10.CarouselSlider-CustomAnimation's
//
//  Created by Kan Tao on 2023/4/24.
//

import SwiftUI

struct ContentView: View {
    
    @State var currentTab = "1"
    var body: some View {
        ZStack {
            GeometryReader { proxy in
                let size = proxy.size
                Image("image\(currentTab)")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size.width, height: size.height)
            }
            .ignoresSafeArea()
            .overlay(.ultraThinMaterial)
            .colorScheme(.dark)
            
            TabView(selection: $currentTab) {
                ForEach(1...6, id: \.self) { index in
                    CarouselBodyView(index: index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct CarouselBodyView: View {
    var index: Int
    @State var offset: CGFloat = 0
    
    
    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            ZStack {
                Image("image\(index)")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size.width - 8, height: size.height / 1.2)
                    .cornerRadius(12)
                
                VStack {
                    VStack(alignment: .leading,spacing: 10) {
                        Text("Human Integration Supervisor")
                            .font(.title2.bold())
                            .kerning(1.5)
                        Text("The world, largest collection of animal facts, pictures and more!")
                            .foregroundStyle(.secondary)
                            .kerning(1.2)
                    }
                    .foregroundStyle(.white)
                    .padding(.top)
                    
                    Spacer(minLength: 0)
                    
                    VStack(alignment: .leading,spacing: 30) {
                        HStack(spacing: 15) {
                            Image("sky")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 55, height: 55)
                                .clipShape(Circle())
                            
                            VStack(alignment: .leading, spacing: 6) {
                                Text("iJustine")
                                    .font(.title2.bold())
                                Text("App Sheep")
                                    .foregroundStyle(.secondary)
                            }
                            .foregroundStyle(.black)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .padding(20)
                    .padding(.horizontal, 10)
                    .background(.white)
                }
                .padding(20)
            }
            .frame(width: size.width - 8, height: size.height / 1.2)
            .frame(width: size.width, height: size.height)
        }
        .tag(index)
        
        // custom 3D Rotation....
        // since we need from 0 so we re getting leading offset..
        // clipping anchor based on offset
        .rotation3DEffect(.init(degrees: getProgress() * 90), axis: (x: 0 , y: 1, z: 0), anchor: offset > 0 ? .leading : .trailing , anchorZ: 0, perspective: 0.6)
        .modifier(ScrollViewOffsetModifier(anchorPoint: .leading, offset: $offset))
        
    }
    
    
    
    func getProgress() -> CGFloat {
        let progress = -offset / UIScreen.main.bounds.width
        return progress
    }
    
}


struct ScrollViewOffsetModifier: ViewModifier {
    var anchorPoint: Anchor = .top
    
    @Binding var offset: CGFloat
    func body(content: Content) -> some View {
        content
            .overlay {
                GeometryReader { proxy -> Color in
                    let frame = proxy.frame(in: .global)
                    
                    DispatchQueue.main.async {
                        switch anchorPoint {
                        case .top:
                            offset = frame.minY
                        case .bottom:
                            offset = frame.maxY
                        case .leading:
                            offset = frame.minX
                        case .trailing:
                            offset = frame.maxX
                        }
                    }
                    
                    return .clear
                }
            }
    }
}


enum Anchor {
    case top
    case bottom
    case leading
    case trailing
}

