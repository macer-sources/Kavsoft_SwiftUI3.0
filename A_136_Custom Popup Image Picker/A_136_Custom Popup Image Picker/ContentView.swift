//
//  ContentView.swift
//  A_136_Custom Popup Image Picker
//
//  Created by work on 7/9/23.
//

import SwiftUI
import PhotosUI

struct ContentView: View {
    @State var showPicker: Bool = false
    @State var pickerImages:[UIImage] = []
    var body: some View {
        NavigationStack {
            TabView {
                ForEach(pickerImages, id: \.self) { image in
                    GeometryReader { proxy in
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: proxy.size.width, height: proxy.size.height)
                            .cornerRadius(15)
                    }
                    .padding()
                }
            }
            .frame(height: 450)
            .navigationTitle("Popup image Picker")
            .tabViewStyle(.page(indexDisplayMode: .never))
            .toolbar {
                Button {
                    showPicker.toggle()
                } label: {
                    Image(systemName: "plus")
                }

            }
        }
        .popupImagePicker(show: $showPicker) { assets in
            let manager = PHCachingImageManager.default()
            let opations = PHImageRequestOptions()
            opations.isSynchronous = true
            
            DispatchQueue.global(qos: .userInteractive).async {
                assets.forEach { a in
                    manager.requestImage(for: a, targetSize: .init(), contentMode: .default, options: opations) { image, _ in
                        guard let image = image else {return}
                        pickerImages.append(image)
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}




extension View {
    @ViewBuilder
    func popupImagePicker(show: Binding<Bool>,transition: AnyTransition = .move(edge: .bottom), onSelect: @escaping ([PHAsset]) -> Void) -> some View {
        self
            .overlay {
                ZStack {
                    Rectangle()
                        .fill(.ultraThinMaterial)
                        .opacity(show.wrappedValue ? 1 : 0)
                        .ignoresSafeArea()
                        .onTapGesture {
                            show.wrappedValue = false
                        }
                    if show.wrappedValue {
                        PopupImagePickerView {
                            show.wrappedValue = false
                        } onSelect: { assets in
                            onSelect(assets)
                            show.wrappedValue = false
                        }
                        .transition(transition)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .animation(.easeInOut, value: show.wrappedValue)
            }
    }
}

