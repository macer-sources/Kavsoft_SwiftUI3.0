//
//  HomeView.swift
//  DesignCode_Mock
//
//  Created by work on 1/10/23.
//

import SwiftUI

struct HomeView: View {
    
    @State private var menu = false
    @State private var user = false
    @State private var notification  = false
    
    
    var body: some View {
        ZStack.init(alignment: .top) {
            ScrollView(showsIndicators: false) {
                VStack.init {
                    CourseRowView()
                    Spacer()
                    CertificateRowView()
                }
            }.padding(.top, 0)
            
            MenuRowView(menu: $menu, user: $user, notification: $notification)
            
            if menu {
                EffectView(style: .extraLight)
                SettingView.init(showing: $menu)
            }
        }.sheet(isPresented: $notification) {
            NotificationDetailView()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}




