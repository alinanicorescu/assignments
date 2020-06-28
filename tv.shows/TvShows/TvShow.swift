//
//  TvShow.swift
//  tv.shows
//
//  Created by Alina Nicorescu on 23/06/2020.
//  Copyright © 2020 Alina Nicorescu. All rights reserved.
//

import Foundation

class TvShow: Decodable {
    var id: String
    var title: String
    var imageUrl: String
    var likesCount: Int
    
    private enum CodingKeys : String, CodingKey {
        case id = "_id", title, imageUrl, likesCount
    }
}

class TvShows: Decodable {
    var data: [TvShow]
    init() {
        data = []
    }
}
