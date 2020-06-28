//
//  Episode.swift
//  tv.shows
//
//  Created by Alina Nicorescu on 24/06/2020.
//  Copyright © 2020 Alina Nicorescu. All rights reserved.
//

import Foundation

class Episode: Decodable {
    var id: String
    var title: String
    var imageUrl: String
    var episodeNumber: String
    var season: String
       
    private enum CodingKeys : String, CodingKey {
        case id = "_id", title, imageUrl, episodeNumber, season
    }
}

class  EpisodeDetails: Decodable {
    var data: [Episode]
    init() {
        data = []
    }
}
