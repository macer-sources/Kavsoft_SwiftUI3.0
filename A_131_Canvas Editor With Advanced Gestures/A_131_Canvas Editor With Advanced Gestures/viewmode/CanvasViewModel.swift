//
//  CanvasViewModel.swift
//  A_131_Canvas Editor With Advanced Gestures
//
//  Created by work on 7/4/23.
//

import SwiftUI

class CanvasViewModel: ObservableObject {
  
    // MARK: Canvas Stack
    @Published var stacks:[StackItem] = []
    
    // MARK: Image pucker Properties
    @Published var showImagePicker: Bool = false
    @Published var imageData: Data = .init()
    
    
    // MARK: Error Properties
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""
}

