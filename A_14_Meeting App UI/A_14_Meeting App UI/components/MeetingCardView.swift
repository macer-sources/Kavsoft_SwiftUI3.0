//
//  MeetingCardView.swift
//  A_14_Meeting App UI
//
//  Created by work on 7/9/23.
//

import SwiftUI

struct MeetingCardView: View {
    @Binding var meeting: Meeting
    var body: some View {
        VStack(spacing: 20) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 12) {
                    Text(meeting.timing.formatted(date: .numeric, time: .omitted))
                        .font(.caption)
                    
                    Text(meeting.title)
                        .font(.title2.bold())
                    
                    Text("\(meeting.members.count) Members Joining")
                }
                
                Spacer(minLength: 0)
                
                //Custom Toggle
                ZStack(alignment: meeting.turnedOn ? .trailing : .leading) {
                    Capsule()
                        .fill(.secondary)
                        .foregroundColor(.white)
                        .frame(width: 35, height: 18)
                    
                    Capsule()
                        .fill(.white)
                        .frame(width: 18, height: 18)
                    
                }
                .shadow(radius: 1.2)
                .onTapGesture {
                    withAnimation() {
                        meeting.turnedOn.toggle()
                    }
                }
            }
            
            HStack(spacing: 0) {
                ForEach(1...3, id: \.self) { index in
                    Image(systemName: "👮‍♂️")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20)
                        .padding(4)
                        .background(.white, in: Circle())
                        .background {
                            Circle()
                                .stroke(.black, lineWidth: 1)
                        }
                }
                
                Spacer(minLength: 15)
                
                Button {
                    
                } label: {
                    Text("Join")
                        .foregroundColor(.black)
                        .padding(.horizontal, 10)
                    
                }
                .background(.white, in: Capsule())
                .buttonStyle(.bordered)
                .controlSize(.small)
                .tint(.white)
                .shadow(radius: 1.2)

            }
            .padding(.top, 20)
        }
        .padding()
        .background(meeting.cardColor, in: RoundedRectangle(cornerRadius: 12))
    }
}

struct MeetingCardView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
