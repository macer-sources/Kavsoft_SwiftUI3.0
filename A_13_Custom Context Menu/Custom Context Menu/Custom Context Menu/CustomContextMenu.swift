//
//  CustomContextMenu.swift
//  Custom Context Menu
//
//  Created by work on 6/15/23.
//

import SwiftUI

// TODO: 需要长按才会展示

struct CustomContextMenu<Content: View, Preview: View>: View {
    
    var content: Content
    var preview: Preview
    
    var menu: UIMenu
    var onEnd: () -> Void = {}
    
    init(@ViewBuilder content: @escaping() ->Content, @ViewBuilder preview: @escaping() ->Preview, actions:@escaping() -> UIMenu, onEnd:@escaping () ->Void = {}) {
        self.content = content()
        self.preview = preview()
        self.menu = actions()
        self.onEnd = onEnd
    }
    
    var body: some View {
        ZStack {
            content
                .hidden()
                .overlay {
                    ContextMenuHelper(content: content, preview: preview, actions: menu, onEnd: onEnd)
                }
        }
    }
}

struct CustomContextMenu_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


// custom view for context menu
struct ContextMenuHelper<Content: View, Preview: View>: UIViewRepresentable {

    var content: Content
    var preview: Preview
    var actions: UIMenu
    var onEnd: () -> Void = {}
    
    init(content: Content, preview: Preview, actions: UIMenu, onEnd:@escaping () -> Void = {}) {
        self.content = content
        self.preview = preview
        self.actions = actions
        self.onEnd = onEnd
    }
    
    func makeUIView(context: Context) -> some UIView {
        let view = UIView()
        view.backgroundColor = .clear
        
        let hostView = UIHostingController(rootView: content)
        hostView.view.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            hostView.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostView.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostView.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostView.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            hostView.view.widthAnchor.constraint(equalTo: view.widthAnchor),
            hostView.view.heightAnchor.constraint(equalTo: view.heightAnchor),
        ]
        
        view.addSubview(hostView.view)
        view.addConstraints(constraints)
        
        
        let interaction = UIContextMenuInteraction(delegate: context.coordinator)
        view.addInteraction(interaction)
        
        return view
    }
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, UIContextMenuInteractionDelegate {
        var parent: ContextMenuHelper
        init(parent: ContextMenuHelper) {
            self.parent = parent
        }
        
        func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
            return UIContextMenuConfiguration(identifier: nil) {
                let previewcontroller = UIHostingController(rootView: self.parent.preview)
                previewcontroller.view.backgroundColor = .clear
                
                return previewcontroller
            }actionProvider: { items in
                return self.parent.actions
            }
        }
        
        
        func contextMenuInteraction(_ interaction: UIContextMenuInteraction, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {
            animator.addCompletion {
                debugPrint("Ended")
                self.parent.onEnd()
            }
        }
        
        
    }
}
