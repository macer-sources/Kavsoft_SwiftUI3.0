//
//  NotificationDetailView.swift
//  DesignCode_Mock
//
//  Created by tao on 2023/1/11.
//

import SwiftUI

struct NotificationDetailView: View {
    @Environment(\.dismiss) var dismiss
    
    
    var body: some View {
        NavigationStack.init {
            List.init {
                ForEach.init(updateData) { item in
                    NavigationLink.init {
                        NotificationUpdateView(item: item)
                    } label: {
                        NotificationDetailItemView(item: item)
                    }
                }
            }
            .navigationTitle(Text("Updates"))
            .navigationBarTitleDisplayMode(.large)
                .toolbar {
                    ToolbarItem.init(placement: .navigationBarLeading) {
                        Button.init(action: {}) {
                            Text("Add Update")
                        }
                    }
                    ToolbarItem.init(placement: .navigationBarTrailing) {
                        Button.init(action: {}) {
                            Text("Edit")
                        }
                    }
                }
        }
    }
}



private struct NotificationDetailItemView: View {
    var item: Update
    var body: some View {
        HStack.init(spacing: 12) {
            Image.init(item.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80, height: 80)
                .background(Color("background"))
                .cornerRadius(20)
            VStack.init(alignment: .leading) {
                Text.init(item.title)
                    .font(.headline)
                Text.init(item.text)
                    .lineLimit(2)
                    .lineSpacing(4)
                    .font(.subheadline)
                    .frame(height: 50)
                
                Text.init(item.date)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.gray)
            }
        }
    }
}


private struct NotificationUpdateView: View {
    var item: Update
    var body: some View {
        VStack.init {
            Text(item.title)
                .font(.title)
                .fontWeight(.bold)
            Image.init(item.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 200)
            Text(item.text)
                .frame(minWidth: 0, maxWidth: .infinity,alignment: .leading)
            Spacer()
        }.padding()
    }
}


struct NotificationDetailView_Previews: PreviewProvider {
    static var previews: some View {
//        NotificationDetailItemView(item: updateData.first!)
//        NotificationDetailView()
        NotificationUpdateView(item: updateData.first!)
    }
}








struct Update: Identifiable {
   var id = UUID()
   var image: String
   var title: String
   var text: String
   var date: String
}

let updateData = [
   Update(image: "Illustration1", title: "SwiftUI", text: "Learn how to build custom views and controls in SwiftUI with advanced composition, layout, graphics, and animation. See a demo of a high performance, animatable control and watch it made step by step in code. Gain a deeper understanding of the layout system of SwiftUI.", date: "JUN 26"),
   Update(image: "Illustration2", title: "Framer X", text: "Learn how to build custom views and controls in SwiftUI with advanced composition, layout, graphics, and animation. See a demo of a high performance, animatable control and watch it made step by step in code. Gain a deeper understanding of the layout system of SwiftUI.", date: "JUN 11"),
   Update(image: "Illustration3", title: "CSS Layout", text: "Learn how to combine CSS Grid, Flexbox, animations and responsive design to create a beautiful prototype in CodePen.", date: "MAY 26"),
   Update(image: "Illustration4", title: "React Native Part 2", text: "Learn how to implement gestures, Lottie animations and Firebase login.", date: "MAY 15"),
   Update(image: "Certificate1", title: "Unity", text: "Unity course teaching basics, C#, assets, level design and gameplay", date: "MAR 19"),
   Update(image: "Certificate2", title: "React Native for Designers", text: "Build your own iOS and Android app with custom animations, Redux and API data.", date: "FEB 14"),
   Update(image: "Certificate3", title: "Vue.js", text: "Make a dashboard web-app with a complete login system, dark mode, and animated charts for your data.", date: "JAN 23")
]
