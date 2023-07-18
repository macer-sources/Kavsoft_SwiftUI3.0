//
//  CourseRowView.swift
//  DesignCode_Mock
//
//  Created by work on 1/10/23.
//

import SwiftUI

struct CourseRowView: View {
    
    @State var showContent = false
    
    
    var body: some View {
        VStack.init(alignment: .leading) {
            HStack.init {
                VStack.init(alignment: .leading) {
                    Text("Courses")
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                    
                    Text("22 Courses")
                        .foregroundColor(.gray)
                    
                }
                Spacer()
            }.padding(.leading, 60)
            
            ScrollView.init(.horizontal,showsIndicators: false) {
                HStack.init(spacing: 30) {
                    ForEach.init(coursesData) { item in
                        CourseItemView(item: item)
                            .rotation3DEffect(Angle(degrees:
                                                        5.0), axis: (x: 0, y: 10.0, z: 0))
                            .onTapGesture {
                                showContent.toggle()
                            }.sheet(isPresented: $showContent) {
                                CoursesDetailView()
                            }

                    }
                }.padding(.leading, 30)
                    .padding(.top, 30)
                    .padding(.bottom, 70)
            }
            
        }

        
    }
}

struct CourseRowView_Previews: PreviewProvider {
    static var previews: some View {
        CourseRowView()
    }
}


let coursesData = [
   Course(title: "Build an app with SwiftUI",
          image: "Illustration1",
          color: Color("background3"),
          shadowColor: Color("backgroundShadow3")),
   Course(title: "Design and animate your UI",
          image: "Illustration2",
          color: Color("background4"),
          shadowColor: Color("backgroundShadow4")),
   Course(title: "Swift UI Advanced",
          image: "Illustration3",
          color: Color("background7"),
          shadowColor: Color(hue: 0.677, saturation: 0.701, brightness: 0.788, opacity: 0.5)),
   Course(title: "Framer Playground",
          image: "Illustration4",
          color: Color("background8"),
          shadowColor: Color(hue: 0.677, saturation: 0.701, brightness: 0.788, opacity: 0.5)),
   Course(title: "Flutter for Designers",
          image: "Illustration5",
          color: Color("background9"),
          shadowColor: Color(hue: 0.677, saturation: 0.701, brightness: 0.788, opacity: 0.5)),
]
