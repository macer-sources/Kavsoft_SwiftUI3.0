//
//  HomeViewModel.swift
//  A_14_Meeting App UI
//
//  Created by work on 7/9/23.
//

import SwiftUI

class HomeViewModel: ObservableObject {
    @Published var meetings:[Meeting] = [
        Meeting(title: "iJustine", timing: Date()),
        Meeting(title: "Kaviya", timing: Date())
    ]
    
    
    @Published var addNew: Bool = false
    
}
