//
//  CertificateItemView.swift
//  DesignCode_Mock
//
//  Created by work on 1/10/23.
//

import SwiftUI


struct Certificate: Identifiable {
    let id = UUID.init()
    var title: String
    var image: String
    var width: Int
    var height: Int
}



struct CertificateItemView: View {
    var item = Certificate(title: "UI Design", image: "Certificate1", width: 340, height: 220)
    
    
    var body: some View {
        VStack.init {
            HStack.init {
                VStack.init(alignment: .leading) {
                    Text(item.title)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(Color("accent"))
                        .padding(.top)
                    Text("Certificate")
                        .font(.headline)
                        .foregroundColor(.white)
                }
                Spacer()
                Image.init("Logo")
                    .resizable()
                    .frame(width: 30, height: 30)
                
            }.padding(.horizontal)
            Spacer()
            
            Image.init(item.image)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                .offset(y: 50)
        }
        .background(.black)
        .frame(width: CGFloat(item.width), height: CGFloat(item.height))
        .cornerRadius(10)
        .shadow(radius: 5)
        
    }
}

struct CertificateItemView_Previews: PreviewProvider {
    static var previews: some View {
        CertificateItemView()
    }
}



