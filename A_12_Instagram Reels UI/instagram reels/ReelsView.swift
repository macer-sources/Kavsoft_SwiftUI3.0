//
//  ReelsView.swift
//  instagram reels
//
//  Created by Kan Tao on 2023/6/15.
//

import SwiftUI
import AVKit
/**
 为什么这里使用 TabView 去实现呢？
    TabView 的 page 模式，只夹在当前页面的内容，有效控制内存占用
 
 */
struct ReelsView: View {
    @State var currentReel = ""
    @State var reels = MediaFileJSON.map { item -> Reel in
        let url = Bundle.main.path(forResource: item.url, ofType: "MP4") ?? ""
        let player = AVPlayer.init(url: URL.init(filePath: url))
        return Reel(player: player, mediaFile: item)
    }
    
    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            TabView(selection: $currentReel) {
                ForEach($reels, id: \.id) { reel in
                    ReelsPlayer(reel: reel, currentReel: $currentReel)
                    .frame(width: size.width) // TODO: 必须设置，不然 maxwidth 就会不正确
                    .rotationEffect(.init(degrees: -90))
                    .ignoresSafeArea(.all, edges: .top)
                    .tag(reel.id)
                }
            }
            // TODO: 默认 tab view 是横向滚动， 此处旋转 90 度，变为垂直方向滚动
            .rotationEffect(.init(degrees: 90))
            .frame(width: size.height)
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(width: size.width)
        }
        .ignoresSafeArea(.all, edges: .top)
        .background(Color.black.ignoresSafeArea())
        .onAppear{
            currentReel = reels.first?.id ?? ""
        }
    }
}

struct ReelsView_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}


// TODO: 播放
struct ReelsPlayer: View {
    @Binding var reel: Reel
    @State var showMore = false
    
    @State var isMuted = false
    @State var volumeAnimation = false
    
    @Binding var currentReel: String
    
    var body: some View {
        ZStack {
            if let player = reel.player {
                
                CustomVideoPlayer(player: player)
                
                
                // playing video base on offset.... 根据偏移量进行播放
                GeometryReader { proxy -> Color in
                    let minY = proxy.frame(in: .global).minY
                    let size = proxy.size
                    
                    DispatchQueue.main.async {
                        if -minY < (size.height / 2) && minY < (size.height / 2) && currentReel == reel.id {
                            player.play()
                        }else {
                            player.pause()
                        }
                    }
                    return Color.clear
                }
                
                Color.black
                    .opacity(0.01)
                    .frame(width: 150, height: 150)
                    .onTapGesture {
                        if volumeAnimation {
                            return
                        }
                        isMuted.toggle()
                        player.isMuted = isMuted
                        withAnimation{volumeAnimation.toggle()}
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                            withAnimation{volumeAnimation.toggle()}
                        }
                    }
                
                
                
                // 在显示更多内容时调暗背景, 点击背景隐藏更多
                Color.black.opacity(showMore ? 0.35 : 0)
                    .onTapGesture {
                        withAnimation{showMore.toggle()}
                    }
                
                VStack {
                    HStack(alignment: .bottom) {
                        VStack(alignment: .leading,spacing: 10) {
                            
                            HStack(spacing: 15) {
                                Image("profile")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 35, height: 35)
                                    .clipShape(Circle())
                                
                                Text("iJustine")
                                    .font(.callout.bold())
                                
                                Button {
                                    
                                } label: {
                                    Text("Follow")
                                        .font(.caption.bold())
                                    
                                }

                            }
                            
                            // Title Custom View ...
                            ZStack {
                                if showMore {
                                    ScrollView(.vertical, showsIndicators: false) {
                                        Text(reel.mediaFile.title + sampleText)
                                            .font(.callout)
                                            .fontWeight(.semibold)
                                    }
                                    .frame(height: 120)
                                    .onTapGesture {
                                        // 点击内容，隐藏更多
                                        withAnimation{showMore.toggle()}
                                    }
                                    
                                }else {
                                    Button {
                                        withAnimation{showMore.toggle()}
                                    } label: {
                                        HStack {
                                            Text(reel.mediaFile.title)
                                                .font(.callout)
                                                .fontWeight(.semibold)
                                                .lineLimit(1)
                                            
                                            Text("more")
                                                .font(.callout.bold())
                                                .foregroundColor(.gray)
                                            
                                        }
                                    }
                                    .padding(.top, 5)
                                    .frame(maxWidth: .infinity, alignment: .leading)

                                }
                            }
                        }
                        
                        Spacer(minLength: 20)
                        
                        // list of button
                        ActionButton(reel: reel)
                    }
                    
                    //Music View
                    HStack {
                        Text("A Sky full of Stars")
                            .font(.caption)
                            .fontWeight(.semibold)
                        
                        Spacer(minLength: 20)
                        
                        Image("album")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 30, height: 30)
                            .cornerRadius(6)
                            .background {
                                RoundedRectangle(cornerRadius: 6)
                                    .stroke(Color.white, lineWidth: 3)
                            }
                            .offset(x: -5)
                        
                    }
                    .padding(.top, 10)
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
                .foregroundColor(.white)
                .frame(maxHeight: .infinity, alignment: .bottom)
                
                Image(systemName:isMuted ? "speaker.slash.fill" : "speaker.wave.2.fill")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding()
                    .background(.secondary)
                    .clipShape(Circle())
                    .foregroundColor(.black)
                    .opacity(volumeAnimation ? 1 : 0)
                
                
            }
            
        }
    }
}


struct ActionButton: View {
    var reel: Reel
    var body: some View {
        VStack(spacing: 25) {
            Button {
                
            } label: {
                VStack(spacing: 10) {
                    Image(systemName: "suit.heart")
                        .font(.title)
                    
                    Text("233K")
                        .font(.caption.bold())
                }
            }

            Button {
                
            } label: {
                VStack(spacing: 10) {
                    Image(systemName: "bubble.right")
                        .font(.title)
                    
                    Text("120")
                        .font(.caption.bold())
                }
            }
            
            Button {
                
            } label: {
                VStack(spacing: 10) {
                    Image(systemName: "paperplane")
                        .font(.title)
                }
            }
            
            Button {
                
            } label: {
                Image(systemName: "ellipsis")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                    
            }

        }
    }
}


let sampleText = "In this Video I'm going to show how to clone Instagram Reels App UI Using SwiftUI 3.0 - Instagram Reels Vertical Carousel Slider/Player - Tiktok Vertical Video Player - SwiftUI Complex UI - SwiftUI Vertical Carousel Slider - SwiftUI Vertical Page Tab View - SwiftUI Vertical Carousel List - SwiftUI Instagram Clone - SwiftUI Custom Video Player - WWDC 2021 -  Xcode 13 beta 2 SwiftUI."
