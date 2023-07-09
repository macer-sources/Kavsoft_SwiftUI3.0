//
//  AddNewMeeting.swift
//  A_14_Meeting App UI
//
//  Created by work on 7/9/23.
//

import SwiftUI

struct AddNewMeeting: View {
    @EnvironmentObject var viewModel: HomeViewModel
    @Environment(\.self) var env
    var body: some View {
        VStack {
            HStack {
                Button {
                    env.dismiss()
                } label: {
                    Image(systemName: "arrow.left")
                        .font(.title2)
                        .foregroundColor(.black)
                }
                
                Spacer()
                
                Image("avator_1")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
            }
            .overlay(alignment: .center) {
                Text("New Meeting")
                    .font(.system(size: 18))
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color("bg"))
    }
}

struct AddNewMeeting_Previews: PreviewProvider {
    static var previews: some View {
        AddNewMeeting()
    }
}
