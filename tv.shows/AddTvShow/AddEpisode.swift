//
//  AddEpisode.swift
//  tv.shows
//
//  Created by Alina Nicorescu on 24/06/2020.
//  Copyright © 2020 Alina Nicorescu. All rights reserved.
//

import Foundation

class AddEpisode : Encodable {
    
    var showId: String?
    var mediaId: String?
    var title: String?
    var description: String?
    var episodeNumber: String?
    var season: String?
    
    init() {
    }
}

class AddEpisodeDetails: Encodable {
    var data: AddEpisode?
}
