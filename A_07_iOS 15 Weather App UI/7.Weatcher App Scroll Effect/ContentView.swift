//
//  ContentView.swift
//  7.Weatcher App Scroll Effect
//
//  Created by Kan Tao on 2023/4/24.
//

import SwiftUI
import SpriteKit

struct ContentView: View {
    
    
    @State private var offset:CGFloat = 0
    var topEdge: CGFloat
    
    var body: some View {
        ZStack {
            GeometryReader { proxy in
                Image("sky")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: proxy.size.width, height: proxy.size.height)
            }
            .ignoresSafeArea()
            .overlay(.ultraThinMaterial)
            
            // Rain Fall View
            GeometryReader { proxy in
                SpriteView.init(scene: RainFall(), options: [.allowsTransparency])
            }.ignoresSafeArea()
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    VStack(alignment: .center, spacing: 5) {
                        Text("San Jose")
                            .font(.system(size: 35))
                            .foregroundColor(.white)
                            .shadow(radius: 5)
                            .opacity(getTitleOpactiy())
                        
                        Text(" 98°")
                            .font(.system(size: 45))
                            .foregroundColor(.white)
                            .shadow(radius: 5)
                            .opacity(getTitleOpactiy())
                        
                        Text("Cloudy")
                            .foregroundStyle(.secondary)
                            .foregroundStyle(.white)
                            .shadow(radius: 5)
                            .opacity(getTitleOpactiy())
                        
                        // shift + option + 8
                        Text("H:103° L:105°")
                            .foregroundStyle(.primary)
                            .foregroundColor(.white)
                            .shadow(radius: 5)
                            .opacity(getTitleOpactiy())
                        
                    }
                    .offset(y: -offset)  // TODO: 这句会导致title 无法滚动， 没搞清楚原因
                    // For Bottom Drag Effect 实现往下拖拽title 的拉伸弹簧效果
                    .offset(y: offset > 0 ? (offset / UIScreen.main.bounds.width) * 100 :  0)
                    .offset(y: getTitleOffset())
                    
                    VStack(spacing: 8) {
                        CustomStackView {
                            Label.init {
                                Text("Hourly Forecast")
                            } icon: {
                                Image(systemName: "clock")
                            }

                        } content: {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 15) {
                                    ForecastView(time: "12 PM", celcius: 94, image: "sun.min")
                                    ForecastView(time: "1 PM", celcius: 94, image: "sun.haze")
                                    ForecastView(time: "2 PM", celcius: 89, image: "sun.min")
                                    ForecastView(time: "3 PM", celcius: 91, image: "cloud.sun")
                                    ForecastView(time: "4 PM", celcius: 90, image: "sun.haze")
                                }
                            }
                        }
                        
                        
                        WeatherDataView()
                    }
                    .background {
                        GeometryReader { proxy in
                            SpriteView.init(scene: RainFallLanding(), options: [.allowsTransparency]).offset(y:-10)
                        }
                    }
                }
                .padding(.top, 25)
                .padding(.top, topEdge)
                .padding([.horizontal, .bottom])
                // gettting offset
                .overlay {
                    // Using Geometry reader
                    GeometryReader { proxy -> Color in
                        let minY = proxy.frame(in: .global).minY
                        DispatchQueue.main.async {
                            debugPrint("\(minY)")
                            self.offset = minY
                        }
                        return .clear
                    }
                }
                
            }
        }
    }
    
    
    func getTitleOpactiy() -> CGFloat {
        let titleOffset = -getTitleOffset()
        let progress = titleOffset / 20
        let opactiy = 1 - progress
        return opactiy
    }
    
    func getTitleOffset() -> CGFloat {
        if offset > 0 {
            return 0
        }
        
        let progress = -offset / 120
        let newOfsset = (progress <= 1.0 ? progress : 1) * 20
        
        return -newOfsset
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(topEdge: 0)
    }
}


extension ContentView {
    @ViewBuilder
    func ForecastView(time: String, celcius: Int, image: String) -> some View {
        VStack(spacing: 15) {
            Text(time)
                .font(.callout.bold())
                .foregroundColor(.white)
            
            Image(systemName: image)
                .font(.title2)
                .symbolVariant(.fill)
                .symbolRenderingMode(.palette)
                .foregroundStyle(.yellow, .white)
                .frame(height: 30)
            Text("\(celcius)°")
                .font(.callout.bold())
                .foregroundColor(.white)
        }
        .padding(.horizontal, 10)
    }
    
    
    @ViewBuilder
    func WeatherDataView() -> some View {
        VStack(spacing: 8) {
            CustomStackView {
                Label.init {
                    Text("Air Quality")
                } icon: {
                    Image(systemName: "circle.hexagongrid.fill")
                }
            } content: {
                VStack(alignment: .leading,spacing: 10) {
                    Text("143 - Moderately Polluted")
                        .font(.title3.bold())
                    Text("May cause breathing discomfort for people with lung disease such as asthma and discomfort for people with heart disease, children and older adults.")
                        .fontWeight(.semibold)
                }
                .foregroundStyle(.white)
            }
        }
    }
    
    
}


struct CustomStackView<Title: View, Content: View> : View {
    var titleView: Title
    var content: Content
    
    @State var topOffset: CGFloat = 0
    @State var bottomOfsset: CGFloat = 0
    
    init(@ViewBuilder titleView: @escaping () -> Title,@ViewBuilder content:() -> Content) {
        self.titleView = titleView()
        self.content = content()
    }
    
    var body: some View {
        VStack(spacing: 0) {
            titleView
                .font(.callout)
                .lineLimit(1)
                .frame(height: 38)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading)
                .background(.ultraThinMaterial, in: CustomCorner(corners: bottomOfsset < 38 ? .allCorners : [.topLeft, .topRight], redius: 12))
                .zIndex(1)
            VStack {
                
                Divider.init()
                
                content
                    .padding()
            }
            .background(.ultraThinMaterial, in: CustomCorner(corners: [.bottomLeft, .bottomRight], redius: 12))
            .offset(y : topOffset >= 120 ? 0 : -(-topOffset + 120))
            .zIndex(0)
            // Clipping to avoid background overlay
            .clipped()
            .opacity(getOpacity())
        }
        .colorScheme(.dark)
        .cornerRadius(12)
        .opacity(getOpacity())
        .offset(y : topOffset >= 120 ? 0 : -topOffset + 120)
        .background {
            GeometryReader { proxy -> Color in
                let minY = proxy.frame(in: .global).minY
                let maxY = proxy.frame(in: .global).maxY
                
                DispatchQueue.main.async {
                    self.topOffset = minY
                    // reducint 120 (title = 38 / content: 120)
                    self.bottomOfsset = maxY - 120
                }

                return Color.clear
            }
        }
        .modifier(CornerModifier(bottomOfsset: $bottomOfsset))
    }
    
    
    func getOpacity() -> CGFloat {
        if bottomOfsset < 28 {
            let progress = bottomOfsset / 28
            return progress
        }else {
            return 1
        }
    }
    
    
    
    
}

struct CustomCorner: Shape {
    var corners: UIRectCorner
    var redius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath.init(roundedRect: rect, byRoundingCorners: corners, cornerRadii: .init(width: redius, height: redius))
        return Path.init(path.cgPath)
    }
}


struct CornerModifier: ViewModifier {
    @Binding var bottomOfsset: CGFloat
    func body(content: Content) -> some View {
        if bottomOfsset < 38 {
            content
        }else {
            content.cornerRadius(12)
        }
    }
}




// going to create Rain/Snow Effect Like Weather App
// Sprite Kit Rain Scene
// TODO: 通过 Sprite kit 实现下雨下雪效果
class RainFall: SKScene {
    override func sceneDidLoad() {
        
        size = UIScreen.main.bounds.size
        scaleMode = .resizeFill
        
        anchorPoint = CGPoint.init(x: 0.5, y: 1)
        
        backgroundColor = .clear
        
        
        let node = SKEmitterNode(fileNamed: "RainFill.sks")!
        addChild(node)
        node.particlePositionRange.dx = UIScreen.main.bounds.size.width
        
    }
}
class RainFallLanding: SKScene {
    override func sceneDidLoad() {
        
        size = UIScreen.main.bounds.size
        scaleMode = .resizeFill
        
        let height = UIScreen.main.bounds.height
        
        anchorPoint = CGPoint.init(x: 0.5, y: (height - 5) / height)
        
        backgroundColor = .clear
        
        
        let node = SKEmitterNode(fileNamed: "RainFallLanding.sks")!
        addChild(node)
        node.particlePositionRange.dx = UIScreen.main.bounds.size.width - 30
        
    }
}
