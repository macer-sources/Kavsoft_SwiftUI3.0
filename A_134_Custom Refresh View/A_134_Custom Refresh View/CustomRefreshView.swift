//
//  CustomRefreshView.swift
//  A_134_Custom Refresh View
//
//  Created by work on 7/4/23.
//

import SwiftUI

struct CustomRefreshView<Content: View>: View {
    var content: Content
    var onRefresh: () async -> Void
    
    @StateObject private var viewModel = ScrollViewModel.init()
    init(@ViewBuilder content:@escaping() -> Content,onRefresh:@escaping () async -> Void) {
        self.content = content()
        self.onRefresh = onRefresh
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 0) {
                // TODO: 自定义 refresh view
                Rectangle()
                    .fill(.black)
                    .scaleEffect(viewModel.isEligible ? 1 : 0.001)
                    .animation(.easeInOut(duration: 0.25), value: viewModel.isEligible)
                    .overlay(content: {
                        // MARK: Arrow and text
                        VStack(spacing: 12) {
                            Image(systemName: "arrow.down")
                                .font(.caption.bold())
                                .foregroundColor(.white)
                                .rotationEffect(.init(degrees: viewModel.progress * 180))
                                .padding(8)
                                .background(.primary, in: Circle())
                            
                            Text("Pull To Refresh")
                                .font(.caption.bold())
                                .foregroundColor(.primary)
                            
                        }
                        .opacity(viewModel.isEligible ? 0 : 1)
                        .animation(.easeInOut(duration: 0.25), value: viewModel.isEligible)
                    })
                    .frame(height: 150 * viewModel.progress)
                    .opacity(viewModel.progress)
                    .offset(y: viewModel.isEligible ?
                            -(viewModel.contentOffset < 0 ? 0 : viewModel.contentOffset) :
                                -(viewModel.scrollOffset < 0 ? 0 : viewModel.scrollOffset))
                content
            }
            .offset(coordinateSpace: "SCROLL") { offset in
                // MARK: Storing content offset
                viewModel.contentOffset = offset
                
                
                // MARK: Stopping the progress when its elgible for refresh
                if !viewModel.isEligible {
                    var progress = offset / 150
                    progress = progress < 0 ? 0 : progress
                    progress = progress > 1 ? 1 : progress
                    viewModel.scrollOffset = offset
                    viewModel.progress = progress
                }
                
                if viewModel.isEligible && !viewModel.isRefreshing {
                    viewModel.isRefreshing = true
                    // MARK: Haptic feedback
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                }
            }
        }
        .coordinateSpace(name: "SCROLL")
        .onAppear {
            viewModel.addGesture()
        }
        .onDisappear {
            viewModel.removeGesture()
        }
        .onChange(of: viewModel.isRefreshing) { newValue in
            if newValue {
                Task {
                    await onRefresh()
                    // MARK: After refrsh done resetting properties
                    withAnimation {
                        viewModel.progress = 0
                        viewModel.isEligible = false
                        viewModel.isRefreshing = false
                        viewModel.scrollOffset = 0
                    }
                }
            }
        }
    }
}

struct CustomRefreshView_Previews: PreviewProvider {
    static var previews: some View {
        CustomRefreshView {
            Rectangle()
                .fill(.red)
                .frame(height: 200)
        } onRefresh: {
            try? await Task.sleep(nanoseconds: 3_000_000_000)
        }
    }
}

class ScrollViewModel: NSObject, ObservableObject, UIGestureRecognizerDelegate {
    // MARK: Properties
    @Published var isEligible: Bool = false
    @Published var isRefreshing: Bool = false
    
    // MARK: Offset and progress
    @Published var scrollOffset: CGFloat = 0
    @Published var progress: CGFloat = 0
    @Published var contentOffset: CGFloat = 0
    
    
    
    // TODO: 具有同步手势显示 因此，它不会干扰SwiftUI滚动和手势
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func addGesture() {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(pan(_:)))
        pan.delegate = self
        rootController().view.addGestureRecognizer(pan)
    }
    func removeGesture() {
        rootController().view.gestureRecognizers?.removeAll()
    }
    
    @objc private func pan(_ gesture: UIPanGestureRecognizer) {
        if gesture.state == .cancelled || gesture.state == .ended {
            // MARK: Your max duration goes here
            if !isRefreshing {
                if scrollOffset > 150 {
                    isEligible = true
                }else {
                    isEligible = false
                }
            }

        }
        
    }
    
    //
    private func rootController() -> UIViewController {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .init()
        }
        guard let root = screen.windows.first?.rootViewController else {
            return .init()
        }
        return root
    }

}




// MARK: Offset Modifier
extension View {
    @ViewBuilder
    func offset(coordinateSpace: String, offset:@escaping (CGFloat) -> Void) -> some View {
        self.overlay {
            GeometryReader { proxy in
                let minY = proxy.frame(in: .named(coordinateSpace)).minY
                Color.clear
                    .preference(key: OffsetKey.self, value: minY)
                    .onPreferenceChange(OffsetKey.self) { value in
                        offset(value)
                    }
            }
        }
    }
}

struct OffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value = nextValue()
    }
}
