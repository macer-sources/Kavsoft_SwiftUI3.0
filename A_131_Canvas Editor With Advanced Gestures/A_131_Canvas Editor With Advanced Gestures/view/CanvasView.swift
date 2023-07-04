//
//  CanvasView.swift
//  A_131_Canvas Editor With Advanced Gestures
//
//  Created by work on 7/4/23.
//

import SwiftUI

struct CanvasView: View {
    @EnvironmentObject var viewModel: CanvasViewModel
    var height:CGFloat = 250
    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            ZStack {
                Color.white
                ForEach($viewModel.stacks) { $item in
                    CanvasSubView(stackItem: $item) {
                        item.view
                    } moveFront: {
                        moveViewToFront(stackitem: item)
                    }
                }
            }
            .frame(width: size.width, height: size.height)
        }
        .frame(height: height)
        .clipped()
    }
    
    
    func moveViewToFront(stackitem: StackItem) {
        // Finding Index And Moving to last
        // since in zstack last item will show on first
        let currentIndex = getIndex(item: stackitem)
        let lastIndex = viewModel.stacks.count - 1
        
        viewModel.stacks.insert(viewModel.stacks[currentIndex], at: lastIndex)
    }
    func getIndex(item: StackItem) -> Int {
        return viewModel.stacks.firstIndex { i in
            return item.id == i.id
        } ?? 0
    }
}

struct CanvasView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



struct CanvasSubView<Content: View> : View {
    
    @Binding var stackItem: StackItem
    var content: Content
    
    var moveFront: () -> Void
    
    init(stackItem: Binding<StackItem>, @ViewBuilder content:@escaping() -> Content, moveFront: @escaping () -> Void) {
        self._stackItem = stackItem
        self.content = content()
        self.moveFront = moveFront
    }
    
    
    // MARK: Haptic animation
    @State var hapticScale: CGFloat = 1
    
    
    var body: some View {
        content
            // TODO: 长按给一点触觉反馈(缩放动画)
            .onLongPressGesture(minimumDuration: 0.3,perform: {
                // 在将视图移动到前方时提供触觉反馈和少量缩放动画
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                withAnimation {
                    hapticScale = 1.2
                }
                withAnimation(.easeInOut.delay(0.1)) {
                    hapticScale = 1
                }
                
                moveFront()
            })
            .scaleEffect(hapticScale)
            // TODO: 位移
            .offset(stackItem.offset)
            .gesture(
                DragGesture()
                    .onChanged({ value in
                        stackItem.offset = CGSize(width: stackItem.lastOffset.width + value.translation.width,
                                                  height: stackItem.lastOffset.height + value.translation.height)
                    }).onEnded({ value in
                        stackItem.lastOffset = stackItem.offset
                    })
            
            )
            // TODO: 缩放
            .scaleEffect(stackItem.scale < 0.4 ? 0.4 : stackItem.scale)
            .gesture(
                MagnificationGesture()
                    .onChanged({ value in
                        // MARK:
                        stackItem.scale = stackItem.lastScale + (value - 1)
                    }).onEnded({ value in
                        stackItem.lastScale = stackItem.scale
                    })
            )
            // TODO: 同时进行旋转
            .rotationEffect(stackItem.rotation)
            .simultaneousGesture(
                RotationGesture()
                    .onChanged({ value in
                        stackItem.rotation = stackItem.lastRotation + value
                    })
                    .onEnded({ value in
                        stackItem.lastRotation = stackItem.rotation
                    })
            )
    }
}
