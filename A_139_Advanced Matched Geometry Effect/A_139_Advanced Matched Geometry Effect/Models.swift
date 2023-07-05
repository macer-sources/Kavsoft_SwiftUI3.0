//
//  Models.swift
//  A_139_Advanced Matched Geometry Effect
//
//  Created by work on 7/5/23.
//

import SwiftUI

struct Profile: Identifiable, Hashable {
    var id = UUID().uuidString
    var name: String
    var icon: String
    var lastMsg: String
    var lastActive: String
}


var sample_datas:[Profile] = [
    .init(name: "iJustine", icon: "avator_1", lastMsg: "Hi Kavsoft |||", lastActive: "10:25 PM"),
    .init(name: "Emily", icon: "avator_2", lastMsg: "What's Up ", lastActive: "11:25 AM")
]
