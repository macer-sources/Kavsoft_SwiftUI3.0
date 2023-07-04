//
//  CanvasViewModel.swift
//  A_131_Canvas Editor With Advanced Gestures
//
//  Created by work on 7/4/23.
//

import SwiftUI

class CanvasViewModel:NSObject, ObservableObject {
  
    // MARK: Canvas Stack
    @Published var stacks:[StackItem] = []
    
    // MARK: Image pucker Properties
    @Published var showImagePicker: Bool = false
    @Published var imageData: Data = .init()
    
    
    // MARK: Error Properties
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""
}

extension CanvasViewModel {
    // MARK: Adding Image to stack
    func addImageToStack(image: UIImage) {
        // MARK: creating swiftui image view and appending into stack
        let imageView = Image(uiImage: image)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 150, height: 150)
        
        stacks.append(StackItem(view: imageView as! AnyView))
    }
}



extension CanvasViewModel {
    func saveCanvasImage<Content: View> (height: CGFloat, @ViewBuilder content: @escaping () -> Content) {
        let uiview = UIHostingController(rootView: content())
        let frame = CGRect.init(origin: .zero, size: CGSize.init(width: UIScreen.main.bounds.size.width, height: height))
        uiview.view.frame = frame
        
        //MARK: drawing image
        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0)
        uiview.view.drawHierarchy(in: frame, afterScreenUpdates: true)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if let newImage = newImage {
            writeToAlbum(image: newImage)
        }
    }
    
    func writeToAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(save(_: didFinishSavingWithError: contextInfo:)), nil)
    }
    @objc
    func save(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            self.errorMessage = error.localizedDescription
            self.showError.toggle()
        }else {
            self.errorMessage = "Saved Successed"
            self.showError.toggle()
        }
    }
}
