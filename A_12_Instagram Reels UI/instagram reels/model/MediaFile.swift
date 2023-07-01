//
//  MediaFile.swift
//  instagram reels
//
//  Created by Kan Tao on 2023/6/15.
//

import Foundation
import AVKit

struct MediaFile: Identifiable {
    var id = UUID().uuidString
    var url: String
    var title: String
    var isExpanded: Bool = false
}


var MediaFileJSON = [
    MediaFile(url: "video1", title: "Apple AirTag...."),
    MediaFile(url: "video2", title: "omg... Animal crossing"),
    MediaFile(url: "video3", title: "So hyped for Halo..."),
    MediaFile(url: "video4", title: "SponsorShip...."),
    MediaFile(url: "video5", title: "i been creating more vertical 30 second content"),
    MediaFile(url: "video6", title: "the brand new apple tower theater opens"),
]



struct Reel: Identifiable {
    var id = UUID().uuidString
    var player: AVPlayer?
    var mediaFile: MediaFile
}
