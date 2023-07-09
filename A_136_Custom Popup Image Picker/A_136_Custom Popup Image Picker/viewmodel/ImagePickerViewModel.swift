//
//  ImagePickerViewModel.swift
//  A_136_Custom Popup Image Picker
//
//  Created by work on 7/9/23.
//

import SwiftUI
import PhotosUI

class ImagePickerViewModel: ObservableObject {
    // MARK: Properties
    @Published var fetchedImages:[ImageAsset] = []
    @Published var selectedImages:[ImageAsset] = []
    
    
    init() {
        fetchImage()
    }
    
    
    // MARK: Fetching Images
    func fetchImage() {
        let opations = PHFetchOptions()
        opations.includeHiddenAssets = false
        opations.includeAssetSourceTypes = [.typeUserLibrary]
        opations.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        PHAsset.fetchAssets(with: .image, options: opations).enumerateObjects { asset, _, _ in
            let imageAsset = ImageAsset(asset: asset)
            self.fetchedImages.append(imageAsset)
        }
    }
}
