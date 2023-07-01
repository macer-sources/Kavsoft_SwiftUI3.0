//
//  ContentView.swift
//  Bottom Sheet Drawer
//
//  Created by Kan Tao on 2023/6/16.
//

import SwiftUI

struct ContentView: View {
    
    @State private var showSheetSwift3: Bool = false
    @State private var showSheetSwift4: Bool = false
    var body: some View {
        NavigationStack {
            VStack(spacing: 40) {
                Button {
                    showSheetSwift3.toggle()
                } label: {
                    Text("Present Sheet SwifUI 3")
                }
                
                Button.init {
                    showSheetSwift4.toggle()
                } label: {
                    Text("Present Sheet SwifUI 4")
                }

            }

            .navigationTitle("Half Model Sheet")
            .halfSheet(showSheet: $showSheetSwift3) {
                ZStack {
                    Color.red
                    Text("Hello Swift UI 3")
                        .font(.title.bold())
                        .foregroundColor(.white)
                }
                .ignoresSafeArea()
            } onEnd: {
              debugPrint("On Dismiss")
            }
            .sheet(isPresented: $showSheetSwift4, content: {
                ZStack {
                    Color.red
                    Text("Hello Swift UI 4")
                        .font(.title.bold())
                        .foregroundColor(.white)
                }
                .ignoresSafeArea()
                .presentationDetents([.medium, .large])
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
