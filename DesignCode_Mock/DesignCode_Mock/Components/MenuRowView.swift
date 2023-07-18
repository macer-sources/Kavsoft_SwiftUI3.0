//
//  MenuRowView.swift
//  DesignCode_Mock
//
//  Created by work on 1/10/23.
//

import SwiftUI

struct MenuRowView: View {
    @Binding private var menu:Bool
    @Binding private var user:Bool
    @Binding private var notification:Bool
    
    
    init(menu:Binding<Bool>, user:Binding<Bool>, notification:Binding<Bool>) {
        self._menu = menu
        self._user = user
        self._notification = notification
    }
    
    var body: some View {
        HStack {
            Button.init {
                menu.toggle()
            } label: {
                Image.init(systemName: "list.dash")
                    .foregroundColor(.primary)
                    .padding(.leading, 30)
            }
            .frame(width: 90, height: 60)
            .background(Color("button"))
            .cornerRadius(30)
            .clipShape(Capsule())
            .shadow(color: Color("buttonShadow"), radius: 20, x: 0, y: 20)
            .padding(.leading, -50)

            Spacer()
            
                Button.init {
                    user.toggle()
                } label: {
                    Image.init(systemName: "bell").foregroundColor(.primary)
                }.buttonStyle(RightButtonStyle())

                Button.init {
                    notification.toggle()
                } label: {
                    Image.init(systemName: "person.crop.circle").foregroundColor(.primary)
                }.buttonStyle(RightButtonStyle())

        }
        .padding()
    }
}

struct MenuRowView_Previews: PreviewProvider {
    @State static var menu = false
    static var previews: some View {
        MenuRowView(menu: $menu, user: $menu, notification: $menu)
    }
}



struct RightButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label.padding(10)
            .background(.white)
            .clipShape(Circle())
            .shadow(color: Color("buttonShadow"), radius: 20, x: 0, y: 20)
    }
}
