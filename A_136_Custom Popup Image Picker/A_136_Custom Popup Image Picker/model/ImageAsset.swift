//
//  ImageAsset.swift
//  A_136_Custom Popup Image Picker
//
//  Created by work on 7/9/23.
//

import SwiftUI
import PhotosUI



struct ImageAsset: Identifiable {
    var id = UUID().uuidString
    var asset: PHAsset
    var thumbnail: UIImage?
    var assetIndex: Int = -1
}
