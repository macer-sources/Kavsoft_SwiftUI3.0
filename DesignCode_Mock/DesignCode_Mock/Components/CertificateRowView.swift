//
//  CertificateRowView.swift
//  DesignCode_Mock
//
//  Created by work on 1/10/23.
//

import SwiftUI

struct CertificateRowView: View {
    var body: some View {
        VStack.init(alignment: .leading) {
            Text("Certificates")
                .font(.system(size: 20))
                .fontWeight(.heavy)
                .padding(.leading, 30)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack.init(spacing: 20) {
                    ForEach.init(certificateData) { item in
                        CertificateItemView(item: item)
                    }
                }
                .padding(20)
                .padding(.leading, 10)
            }
        }
            
    }
}

struct CertificateRowView_Previews: PreviewProvider {
    static var previews: some View {
        CertificateRowView()
    }
}


let certificateData = [
   Certificate(title: "UI Design", image: "Certificate1", width: 230, height: 150),
   Certificate(title: "SwiftUI", image: "Certificate2", width: 230, height: 150),
   Certificate(title: "Sketch", image: "Certificate3", width: 230, height: 150),
   Certificate(title: "Framer", image: "Certificate4", width: 230, height: 150)
]
