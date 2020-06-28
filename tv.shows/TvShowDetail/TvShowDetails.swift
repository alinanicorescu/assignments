//
//  TvShowDetail.swift
//  tv.shows
//
//  Created by Alina Nicorescu on 23/06/2020.
//  Copyright © 2020 Alina Nicorescu. All rights reserved.
//

import Foundation
import  UIKit

class TvShowDetail: Decodable {
    var type: String
    var id: String
    var title: String
    var imageUrl: String
    var likesCount: Int
    var description: String
    
    private enum CodingKeys : String, CodingKey {
        case id = "_id", title, imageUrl, likesCount, description, type
    }
  
}

class TvShowDetails: Decodable {
    var data: TvShowDetail?
    init() {
        data = nil
    }
}
