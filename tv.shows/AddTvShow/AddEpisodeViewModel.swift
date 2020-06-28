//
//  AddEpisode.swift
//  tv.shows
//
//  Created by Alina Nicorescu on 24/06/2020.
//  Copyright © 2020 Alina Nicorescu. All rights reserved.
//

import UIKit

import Foundation

protocol  AddEpisodeViewModelProtocol {
    func setShowId(showId: String?)
    func setImage(image: UIImage?)
    func setTitle(title: String?)
    func setDescription(description: String?)
    func setEpisodeNumber(epNumber: String?)
    func setSeason(season: String?)
    func addShowEpisode()
}

class AddEpisodeViewModel: AddEpisodeViewModelProtocol {
    
    private var addEpisode: AddEpisode = AddEpisode()
    private var completion: (Error?) -> Void
    
    init(showId: String?, completion: @escaping (Error?) -> Void) {
        addEpisode.showId = showId
        self.completion = completion
    }
    
    func addShowEpisode() {
        let addEpisodeParam = AddEpisodeDetails()
        addEpisodeParam.data = addEpisode
        APIService.shared.addShowEpisode(addEpisode: addEpisodeParam, completion: self.episodeAdded(error:))
    }
    
    private func episodeAdded(error: Error?) {
        completion(error)
    }
    
    func setShowId(showId: String?) {
        self.addEpisode.showId = showId
    }
    
    func setImage(image: UIImage?) {
        if let imageData = image?.pngData() {
            addEpisode.mediaId = imageData.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
        }
    }
    
    func setTitle(title: String?) {
        self.addEpisode.title = title
    }
    
    func setDescription(description: String?) {
        self.addEpisode.description = description
    }
    
    func setEpisodeNumber(epNumber: String?) {
        self.addEpisode.episodeNumber = epNumber
    }
    
    func setSeason(season: String?) {
        self.addEpisode.season = season
    }
}
