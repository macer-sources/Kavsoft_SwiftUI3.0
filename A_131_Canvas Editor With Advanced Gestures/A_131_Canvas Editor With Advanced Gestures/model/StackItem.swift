//
//  StackItem.swift
//  A_131_Canvas Editor With Advanced Gestures
//
//  Created by work on 7/4/23.
//

import SwiftUI

struct StackItem: Identifiable {
    var id = UUID().uuidString
    var view:AnyView
    
    
    // MARK: Gesture properties
    var offset: CGSize = .zero
    var lastOffset: CGSize = .zero
    var scale: CGFloat = 1
    var lastScale: CGFloat = 1
    var rotation: Angle = .zero
    var lastRotation: Angle = .zero
    
}
