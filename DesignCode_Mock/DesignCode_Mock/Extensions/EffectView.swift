//
//  EffectView.swift
//  DesignCode_Mock
//
//  Created by work on 1/10/23.
//

import SwiftUI


struct EffectView: UIViewRepresentable {
    let style: UIBlurEffect.Style
    
    func makeUIView(context: Context) -> some UIView {
        let view = UIView.init(frame: .zero)
        view.backgroundColor = .clear
        
        let effect = UIBlurEffect.init(style: style)
        let blurView = UIVisualEffectView.init(effect: effect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(blurView, at: 0)
        NSLayoutConstraint.activate([
            blurView.heightAnchor.constraint(equalTo: view.heightAnchor),
            blurView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        return view
    }
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}


