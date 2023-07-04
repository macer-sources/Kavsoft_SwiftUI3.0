//
//  ContentView.swift
//  A_131_Canvas Editor With Advanced Gestures
//
//  Created by work on 7/4/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel: CanvasViewModel = CanvasViewModel()
    
    var body: some View {
        ZStack {
            
            Color.black.ignoresSafeArea()
            
            // MARK: Canvas View
            CanvasView()
                .environmentObject(viewModel)
            
            
            // MARK: convas actions
            HStack(spacing: 15) {
                Button {
                    
                } label: {
                    Image(systemName: "xmark")
                        .font(.title3)
                }
                
                Spacer()
                
                Button {
                    viewModel.showImagePicker.toggle()
                } label: {
                    Image(systemName: "photo.on.rectangle")
                }
            }
            .foregroundColor(.white)
            .padding()
            .frame(maxHeight: .infinity, alignment: .top)
            
            // MARK: Save Button
            Button {
                
            } label: {
                Image(systemName: "arrow.right.circle.fill")
                    .font(.largeTitle)
                    .foregroundColor(.white)
            }
            .padding()
            .frame(maxWidth: .infinity,maxHeight: .infinity, alignment: .bottomTrailing)

        }
        .alert(viewModel.errorMessage, isPresented: $viewModel.showError, actions: {
            
        })
        .sheet(isPresented: $viewModel.showImagePicker) {
            ImagePicker(showPicker: $viewModel.showImagePicker, imageData: $viewModel.imageData)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
