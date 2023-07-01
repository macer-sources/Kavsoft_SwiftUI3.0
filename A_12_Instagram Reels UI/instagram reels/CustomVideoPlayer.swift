//
//  CustomVideoPlayer.swift
//  instagram reels
//
//  Created by Kan Tao on 2023/6/15.
//

import SwiftUI
import AVKit

struct CustomVideoPlayer: UIViewControllerRepresentable {
    
    var player: AVPlayer
    
    func makeUIViewController(context: Context) -> some AVPlayerViewController {
        let controller = AVPlayerViewController()
        controller.player = player
        controller.showsPlaybackControls = false
        controller.videoGravity = .resizeAspectFill
        player.actionAtItemEnd = .none
        NotificationCenter.default.addObserver(context.coordinator, selector: #selector(context.coordinator.restartPlayback), name: .AVPlayerItemDidPlayToEndTime, object: player.currentItem)
        return controller
    }
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    class Coordinator: NSObject {
        var parent: CustomVideoPlayer
        init(parent: CustomVideoPlayer) {
            self.parent = parent
        }
        
        
        @objc func restartPlayback() {
            parent.player.seek(to: .zero)
            
        }
    }
    
}
