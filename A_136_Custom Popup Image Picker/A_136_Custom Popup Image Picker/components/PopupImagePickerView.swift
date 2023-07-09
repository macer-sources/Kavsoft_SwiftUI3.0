//
//  PopupImagePickerView.swift
//  A_136_Custom Popup Image Picker
//
//  Created by work on 7/9/23.
//

import SwiftUI
import PhotosUI

struct PopupImagePickerView: View {
    
    // MARK: Conntecting view Model
    @StateObject var viewModel = ImagePickerViewModel()
    
    var onEnd:() -> Void = {}
    var onSelect:([PHAsset]) -> Void
    
    @Environment(\.self) var env
    var body: some View {
        
        let deviceSize = UIScreen.main.bounds.size
        VStack(spacing: 0) {
            HStack {
                Text("Select Images")
                    .font(.callout.bold())
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Button {
                    onEnd()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title3)
                        .foregroundColor(.primary)
                    
                }

            }
            .padding([.horizontal, .top])
            .padding(.bottom, 10)
            
            
            ScrollView(.vertical, showsIndicators: false) {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 4), spacing: 12) {
                    
                    ForEach($viewModel.fetchedImages) { $imageAsset in
                        // MARK: Grid Item View
                        GridItemView(imageAsset: imageAsset)
                            .onAppear {
                                if imageAsset.thumbnail == nil {
//                                    // MARK: Fetching Thumbnail image
                                    PHCachingImageManager.default()
                                    .requestImage(for: imageAsset.asset, targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFill, options: nil) { image, _ in
                                        imageAsset.thumbnail = image
                                    }
                                }
                            }
                    }
                    
                }
                .padding()
            }
            .safeAreaInset(edge: .bottom) {
                // MARK: Add Button
                Button {
                    let phassets = viewModel.selectedImages.compactMap { imageAsset -> PHAsset in
                        return imageAsset.asset
                    }
                    onSelect(phassets)
                } label: {
                    Text("Add \(viewModel.selectedImages.isEmpty ? "" : "\(viewModel.selectedImages.count)")")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 30)
                        .padding(.vertical, 10)
                        .background {
                            Capsule()
                                .fill(.blue)
                        }
                }
                .padding(.vertical)
                .disabled(viewModel.selectedImages.isEmpty)
                .opacity(viewModel.selectedImages.isEmpty ? 0.6 : 1)

            }
        }
        .frame(height: deviceSize.height / 1.8)
        .frame(maxWidth: (deviceSize.width - 40) > 350 ? 350 : (deviceSize.width - 40))
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(env.colorScheme == .dark ? .black : .white)
        }
        // MARK: Since its an overlay view
        // Making it to take full screen space
        .frame(width: deviceSize.width, height: deviceSize.height, alignment: .center)
    }
}

extension PopupImagePickerView {
    @ViewBuilder
    func GridItemView(imageAsset: ImageAsset) -> some View {
        GeometryReader { proxy in
            let size = proxy.size
            
            ZStack {
                if let thumail = imageAsset.thumbnail {
                    Image(uiImage: thumail)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: size.width, height: size.height)
                        clipShape(RoundedRectangle(cornerRadius: 8))
                    
                }else {
                    ProgressView()
                        .frame(width: size.width, height: size.height, alignment: .center)
                }
                
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.black.opacity(0.1))
                    Circle()
                        .fill(.white.opacity(0.25))
                    Circle()
                        .stroke(.white,lineWidth: 1)
                    
                    if let index = viewModel.selectedImages.firstIndex(where: {$0.id == imageAsset.id}) {
                        Circle()
                            .fill(.blue)
                        
                        Text("\(viewModel.selectedImages[index].assetIndex + 1)")
                            .font(.caption2.bold())
                            .foregroundColor(.white)
                    }
                }
                .frame(width: 20, height: 20)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                .padding(5)
            }
            .onTapGesture {
                // MARK: Add/Remove selected Image
                withAnimation {
                    if viewModel.selectedImages.contains(where: {$0.id == imageAsset.id}) {
                        viewModel.selectedImages.removeAll(where: {$0.id == imageAsset.id})
                        viewModel.selectedImages.enumerated().forEach { item in
                            viewModel.selectedImages[item.offset].assetIndex = item.offset
                        }
                    }else {
                        var newAsset = imageAsset
                        newAsset.assetIndex = viewModel.selectedImages.count
                        viewModel.selectedImages.append(newAsset)
                    }
                }
            }
        }
        .frame(height: 70)
    }
}




struct PopupImagePickerView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
