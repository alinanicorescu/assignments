//
//  EpisodeDetailss.swift
//  tv.shows
//
//  Created by Alina Nicorescu on 24/06/2020.
//  Copyright © 2020 Alina Nicorescu. All rights reserved.
//

import Foundation


class EpisodeDetail: Decodable {
    var id: String
    var title: String
    var imageUrl: String
    var episodeNumber: String
    var season: String
    var description: String
    var showId: String
    var type: String
       
    private enum CodingKeys : String, CodingKey {
        case id = "_id", title, imageUrl, episodeNumber, season, description, showId, type
    }
}

class  EpisodeDetailsData: Decodable {
    var data: EpisodeDetail?
}
