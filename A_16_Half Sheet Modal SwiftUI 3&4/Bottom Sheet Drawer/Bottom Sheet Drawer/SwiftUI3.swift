//
//  SwiftUI3.swift
//  Bottom Sheet Drawer
//
//  Created by Kan Tao on 2023/6/16.
//

import SwiftUI


// custom Half Sheet Modifier
extension View {
    
    func halfSheet<SheetView: View>(showSheet:Binding<Bool>, @ViewBuilder content:@escaping () -> SheetView, onEnd:@escaping () -> Void = {}) -> some View {
        
        // overlay 和 background会自动使用swifui frame
        return self.background(
            HalfSheetHelper(showSheet: showSheet, content: content(), onEnd: onEnd)
        )
    }
}



// UIKit Interation
struct HalfSheetHelper<SheetView: View>: UIViewControllerRepresentable {
    
    @Binding var showSheet: Bool
    var content: SheetView
    var onEnd:() ->Void = {}
    
    let controller = UIViewController()
    
    func makeUIViewController(context: Context) -> some UIViewController {
        controller.view.backgroundColor = .clear
        
        return controller
    }
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        if showSheet {
            let sheetController = CustomHostController(rootView: content)
            sheetController.presentationController?.delegate = context.coordinator
            controller.present(sheetController, animated: true)
            
        }else {
            uiViewController.dismiss(animated: true) {
                
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    // on dismiss
    class Coordinator: NSObject, UISheetPresentationControllerDelegate {
        var parent: HalfSheetHelper
        init(parent: HalfSheetHelper) {
            self.parent = parent
        }
        
        func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
            parent.showSheet = false
            parent.onEnd()
        }
    }
    
    
}


// custom uihostcontroller
class CustomHostController<Content: View> :UIHostingController<Content> {
    override func viewDidLoad() {
        
        view.backgroundColor = .clear
        
        if let presentationController = presentationController as? UISheetPresentationController {
            presentationController.detents = [
                .medium(),
                .large()
            ]
            
            presentationController.prefersGrabberVisible = true
        }
    }
}



