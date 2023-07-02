//
//  VerticalCarouselList.swift
//  SwiftUI Animated Carousel With Material Effect
//
//  Created by Kan Tao on 2023/6/16.
//

import SwiftUI

struct VerticalCarouselList<Content: View>: UIViewRepresentable {
    var content: Content
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    func makeUIView(context: Context) -> some UIView {
        let scrollView = UIScrollView()
        setUp(scrollView)
        return scrollView
    }
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
    
    private func setUp(_ scrollView:UIScrollView) {
        let hostView = UIHostingController(rootView: content)
        hostView.view.backgroundColor = .clear
        
        hostView.view.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            hostView.view.topAnchor.constraint(equalTo: scrollView.topAnchor),
            hostView.view.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            hostView.view.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            hostView.view.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            
            hostView.view.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ]
        scrollView.addSubview(hostView.view)
        scrollView.addConstraints(constraints)
        
    }
    
    
}

struct VerticalCarouselList_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
