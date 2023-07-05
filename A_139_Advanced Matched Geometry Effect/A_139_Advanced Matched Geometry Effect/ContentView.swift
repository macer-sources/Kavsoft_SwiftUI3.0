//
//  ContentView.swift
//  A_139_Advanced Matched Geometry Effect
//
//  Created by work on 7/5/23.
//

import SwiftUI

struct ContentView: View {
    
    @Namespace var animation
    @State var isExpanded: Bool = false
    @State var expandedItem: Profile?
    @State var loadExpandedContent: Bool = false
    
    @State var offset: CGSize = .zero
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 20) {
                    ForEach(sample_datas, id: \.self) { item in
                        RowView(item: item)
                    }
                }
                .padding()
            }
            .navigationTitle("WhatsApp")
        }
        .frame(maxWidth: .infinity,maxHeight: .infinity, alignment: .center)
        .overlay {
            Rectangle()
                .fill(.black)
                .opacity(loadExpandedContent ? 1 : 0)
                .opacity(offsetProgress())
                .ignoresSafeArea()
        }
        .overlay {
            if let expandedItem = expandedItem, isExpanded {
                ExpandedView(item: expandedItem)
            }
        }
    }
    
    
    // MARK: Expanded View
    @ViewBuilder
    func ExpandedView(item: Profile) -> some View {
        VStack{
            GeometryReader { proxy in
                let size = proxy.size
                
                Image(item.icon)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size.width, height: size.height)
                    .cornerRadius(loadExpandedContent ? 0 : size.height)
                    .offset(y: loadExpandedContent ? offset.height : .zero)
                    .gesture(
                        DragGesture()
                            .onChanged({ value in
                                offset = value.translation
                            })
                            .onEnded({ value in
                                let height = value.translation.height
                                if height > 0 && height > 100 {
                                    withAnimation(.easeInOut(duration: 0.4)) {
                                        loadExpandedContent = false
                                    }
                                    withAnimation(.easeInOut(duration: 0.4).delay(0.05)) {
                                        isExpanded = false
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                        offset = .zero
                                    }
                                }else {
                                    withAnimation(.easeInOut(duration: 0.4)) {
                                        offset = .zero
                                    }
                                }
                            })
                    )
            }
            .matchedGeometryEffect(id: item.id, in: animation)
            .frame(height: 300)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay(alignment: .top,content: {
            HStack(spacing: 10) {
                Button {
                    withAnimation(.easeInOut(duration: 4)) {
                        loadExpandedContent = false
                    }
                    withAnimation(.easeInOut(duration: 4).delay(0.05)) {
                        isExpanded = false
                    }
                } label: {
                    Image(systemName: "arrow.left")
                        .font(.title3)
                        .foregroundColor(.white)
                }
                
                Text(item.name)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                
                Spacer(minLength: 10)
            }
            .padding()
            .opacity(loadExpandedContent ? 1 : 0)
            .opacity(offsetProgress())
        })
        .transition(.offset(x: 0, y: 1))
        .onAppear {
            withAnimation(.easeInOut(duration: 4)) {
                loadExpandedContent = true
            }
        }
    }
    
    
    
    func offsetProgress() -> CGFloat {
        let progress = offset.height / 100
        if offset.height < 0 {
            return 1
        }else {
            return 1 - (progress < 1 ? progress : 1)
        }
    }
    
    
}

extension ContentView {
    @ViewBuilder
    func RowView(item: Profile) -> some View {
        HStack(spacing: 12) {
            VStack {
                if expandedItem?.id == item.id, isExpanded {
                    Image(item.icon)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 45, height: 45)
                        .cornerRadius(0)
                        .opacity(0)
                }else {
                    Image(item.icon)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 45, height: 45)
                        .matchedGeometryEffect(id: item.id, in: animation)
                        .cornerRadius(25)
                }
            }
            .onTapGesture {
                withAnimation(.easeInOut(duration: 4)) {
                    isExpanded = true
                    expandedItem = item
                }
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text(item.name)
                    .font(.callout)
                    .fontWeight(.semibold)
                
                Text(item.lastMsg)
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(item.lastActive)
                .font(.caption2)
                .foregroundColor(.gray)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
