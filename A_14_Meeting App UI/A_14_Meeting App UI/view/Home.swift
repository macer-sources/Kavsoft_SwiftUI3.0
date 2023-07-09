//
//  Home.swift
//  A_14_Meeting App UI
//
//  Created by work on 7/9/23.
//

import SwiftUI




struct Home: View {
    @Namespace var animation
    @State var current: Tab = .upciming
    
    @StateObject var viewModel = HomeViewModel()
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 15) {
                Text("Hi, jJustine!")
                    .font(.title3)
                    .kerning(1.1)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack(alignment: .bottom) {
                    Text("Check you\n**Meeting Details**")
                        .font(.title)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Button {
                        withAnimation {
                            viewModel.addNew.toggle()
                        }
                    } label: {
                        Text("ADD")
                            .foregroundColor(.black)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 20)
                            .background {
                                Capsule()
                                    .stroke(.black.opacity(0.5), lineWidth: 1)
                            }
                    }
                }
                .padding(.top, 10)
                
                CustomSegmentControl()
                
                MeetingView()
                
            }
            .padding()
        }
        .background {
            Color("bg")
                .ignoresSafeArea()
        }
        .fullScreenCover(isPresented: $viewModel.addNew) {
            
        } content: {
            AddNewMeeting().environmentObject(viewModel)
        }

    }
    
    
    @ViewBuilder
    func CustomSegmentControl() -> some View {
        HStack(spacing: 0) {
            ForEach([Tab.upciming, .onHold, .post, .cancelled], id:\.self) { tab in
                TabButton(current: $current, title: tab.rawValue.capitalized, animation: animation)
                    .onTapGesture {
                        withAnimation {
                            current = tab
                        }
                    }
            }
        }
        .padding(.top, 25)
    }
    
    
    @ViewBuilder
    func MeetingView() -> some View {
        VStack(spacing: 15) {
            ForEach($viewModel.meetings, id: \.self) { $meeting in
                MeetingCardView(meeting: $meeting)
            }
        }
        .padding(.top, 20)
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

struct TabButton: View {
    @Binding var current: Tab
    var title: String
    var animation: Namespace.ID
    
    var body: some View {
        VStack {
            Text(title)
                .fontWeight(.semibold)
                .foregroundColor(current.rawValue == title ? .black :.gray)
            if current.rawValue == title {
                Rectangle()
                    .fill(.black)
                    .frame(width: 50, height: 1)
                    .matchedGeometryEffect(id: "TAB", in: animation)
            }else {
                Rectangle()
                    .fill(.clear)
                    .frame(width: 50, height: 1)
            }
        }
        .frame(maxWidth: .infinity)

    }
}

