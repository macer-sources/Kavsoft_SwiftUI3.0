//
//  Meeting.swift
//  A_14_Meeting App UI
//
//  Created by work on 7/9/23.
//

import SwiftUI

struct Meeting: Identifiable, Hashable {
   
    var id = UUID().uuidString
    var title: String
    var timing: Date
    var cardColor: Color = .blue
    var turnedOn: Bool = false
    var memeberType: String = "Public"
    
    
    var members:[String] = []
}
