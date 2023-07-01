//
//  ContentView.swift
//  5.WaveAnimation
//
//  Created by Kan Tao on 2023/4/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            WaveForm(color: .purple.opacity(0.8), amplify: 200, isReversed: false)
            WaveForm(color: .cyan.opacity(0.6), amplify: 180, isReversed: true)
        }.ignoresSafeArea(.all, edges: .bottom)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



struct WaveForm: View {
    
    var color: Color
    var amplify: CGFloat
    var isReversed: Bool = false
    
    var body: some View {
        // using time line view for peroidc update
        TimelineView(.animation) { timeLine  in
          
            // Cavas View for drawing Wave
            
            Canvas { context, size in
                // getting current time
                let timeNow = timeLine.date.timeIntervalSinceReferenceDate
                
                let angle = timeNow.remainder(dividingBy: 2)
                let offset = angle * size.width
                
                
                context.translateBy(x: isReversed ? -offset : offset, y: 0)
                context.fill(path(size: size), with: .color(color))
                
                // drawing curve front and back
                // so that tranlation will be look like wave animation
                context.translateBy(x: -size.width, y: 0)
                context.fill(path(size: size), with: .color(color))
                
                context.translateBy(x: size.width * 2, y: 0)
                context.fill(path(size: size), with: .color(color))
                
                
            }
        }
    }
    
    
    
    func path(size: CGSize) -> Path {
        return Path { path in
            // moveing the wave to center leading...
            let midHeight = size.height / 2
            let width = size.width
            path.move(to: .init(x: 0, y: midHeight))
            path.addCurve(to: .init(x: width, y: midHeight), control1: .init(x: width * 0.5, y: midHeight + amplify), control2: .init(x: width * 0.5, y: midHeight - amplify))
            
            // 填充底部
            path.addLine(to: .init(x: width, y: size.height))
            path.addLine(to: .init(x: 0, y: size.height))
        }
    }
}
