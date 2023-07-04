//
//  CanvasView.swift
//  A_131_Canvas Editor With Advanced Gestures
//
//  Created by work on 7/4/23.
//

import SwiftUI

struct CanvasView: View {
    var height:CGFloat = 250
    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            ZStack {
                
            }
            .frame(width: size.width, height: size.height)
        }
        .frame(height: height)
    }
}

struct CanvasView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
