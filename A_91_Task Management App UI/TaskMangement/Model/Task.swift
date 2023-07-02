//
//  Task.swift
//  KavsoftDemo
//
//  Created by tao on 2023/2/24.
//

import Foundation


struct Task:Identifiable {
    var id = UUID().uuidString
    var title: String
    var description: String
    var date: Date
}



