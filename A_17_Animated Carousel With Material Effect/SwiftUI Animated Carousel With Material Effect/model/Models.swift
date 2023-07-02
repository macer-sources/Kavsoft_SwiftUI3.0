//
//  Models.swift
//  SwiftUI Animated Carousel With Material Effect
//
//  Created by work on 7/2/23.
//

import Foundation


struct Movie: Identifiable {
    var id = UUID().uuidString
    var name: String
    var artwork: String
}


var sample_datas = [
    Movie.init(name: "Bloack Widwo", artwork: "image1"),
    Movie.init(name: "Loki", artwork: "image2"),
    Movie.init(name: "Wanda Vision", artwork: "image3"),
    Movie.init(name: "The Falcon and the Winter Soldier", artwork: "image4"),
    Movie.init(name: "Mulan", artwork: "image5"),
    Movie.init(name: "Endgame", artwork: "image6"),
]

