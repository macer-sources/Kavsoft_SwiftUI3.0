//
//  ContentView.swift
//  A_139_Advanced Matched Geometry Effect
//
//  Created by work on 7/5/23.
//

import SwiftUI

struct ContentView: View {
    
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
    }
}

extension ContentView {
    @ViewBuilder
    func RowView(item: Profile) -> some View {
        HStack(spacing: 12) {
            Image(item.icon)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 45, height: 45)
                .clipShape(Circle())
            
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
