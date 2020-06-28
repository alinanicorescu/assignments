//
//  EpisodeDetailsViewModel.swift
//  tv.shows
//
//  Created by Alina Nicorescu on 24/06/2020.
//  Copyright © 2020 Alina Nicorescu. All rights reserved.
//

import Foundation

protocol EpisodeDetailsViewModelProtocol {
    func getImageUrl() -> URL?
    func getTitleText() -> String?
    func getDescriptionText() -> String?
    func getEpisodeText() -> String?
    func fetchEpisodeDetails()
}

class EpisodeDetailsViewModel: EpisodeDetailsViewModelProtocol {
    
    private var episodeDetails: EpisodeDetailsData?
    private var completion: (Error?) -> Void
    private var episodeId: String?
    
    init(episodeId: String?, completion: @escaping (Error?) -> Void) {
        self.completion = completion
        self.episodeId = episodeId
    }
    
    func fetchEpisodeDetails() {
        guard let episodeId = episodeId else {
            self.completion(nil)
            return
        }
        APIService.shared.getEpisodeDetails(episodeId: episodeId) {[weak self] details, error in
            if error != nil {
                self?.completion(error)
            } else {
                self?.episodeDetails = details
                self?.completion(nil)
            }
        }
    }
    
    func getImageUrl() -> URL? {
        guard let urlString = episodeDetails?.data?.imageUrl else {
            return nil
        }
        return URL(string: urlString)
    }
       
    func getTitleText() -> String? {
        return episodeDetails?.data?.title
    }
       
    func getDescriptionText() -> String? {
        return episodeDetails?.data?.description
    }
    
    func getEpisodeText() -> String? {
        return episodeDetails?.data?.episodeNumber
    }
}
