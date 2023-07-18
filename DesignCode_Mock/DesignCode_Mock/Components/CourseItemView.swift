//
//  CourseItemView.swift
//  DesignCode_Mock
//
//  Created by work on 1/10/23.
//

import SwiftUI

struct CourseItemView: View {
    
    let item: Course
    
    var body: some View {
        VStack.init(alignment: .leading) {
            Text(item.title)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(30)
                .lineLimit(4)
            
            Spacer()
            
            Image.init(item.image)
                .resizable()
                .renderingMode(.original)
                .aspectRatio(contentMode: .fit)
                .frame(width: 246, height: 150)
                .padding(.bottom,30)
            
        }.background(item.color)
            .cornerRadius(30)
            .frame(width: 246, height: 360)
            .shadow(color: item.shadowColor, radius: 20, x: 0, y: 20)
    }
}

struct CourseItemView_Previews: PreviewProvider {
    static  let item: Course = Course.init(title: "Build an app with SwiftUI", image: "Illustration1", color: Color("background3"), shadowColor: Color("backgroundShadow3"))
    static var previews: some View {
        CourseItemView(item: item)
    }
}


struct Course: Identifiable {
   var id = UUID()
   var title: String
   var image: String
   var color: Color
   var shadowColor: Color
}
