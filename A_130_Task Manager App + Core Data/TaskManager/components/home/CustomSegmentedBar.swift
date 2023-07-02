//
//  CustomSegmentedBar.swift
//  TaskManager
//
//  Created by work on 7/2/23.
//

import SwiftUI
// MARK: Custom Segmented Bar

struct CustomSegmentedBar: View {
    
    @EnvironmentObject var viewModel: TaskManagerViewModel
    @Namespace var animation
    
    var body: some View {
        let tabs = ["Today", "Upcoming","Task Done"]
        HStack(spacing: 10) {
            ForEach(tabs, id: \.self) { item in
                Text(item)
                    .font(.callout)
                    .fontWeight(.semibold)
                    .foregroundColor(viewModel.currentTab == item ? .white : .black)
                    .padding(.vertical, 6)
                    .frame(maxWidth: .infinity)
                    .scaleEffect(0.9)
                    .background{
                        if viewModel.currentTab == item {
                            Capsule()
                                .fill(.black)
                                .matchedGeometryEffect(id: "Tab", in: animation)
                        }
                    }
                    .contentShape(Capsule())
                    .onTapGesture {
                        withAnimation {
                            viewModel.currentTab = item
                        }
                    }
            }
        }
    }
}

struct CustomSegmentedBar_Previews: PreviewProvider {
    static var previews: some View {
        TaskManagerPage()
    }
}
