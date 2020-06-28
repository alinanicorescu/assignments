//
//  TvShowDetailsViewModel.swift
//  tv.shows
//
//  Created by Alina Nicorescu on 23/06/2020.
//  Copyright © 2020 Alina Nicorescu. All rights reserved.
//

import Foundation
import UIKit

protocol TvShowDetailViewModelProtocol {
   
    func  getNumberOfEpisodes() -> Int
    func getNumberOfSections() -> Int
    func getSectionHeight(index: Int) -> CGFloat
    func getRowHeight(sIndex: Int) -> CGFloat
    func getNumberOfRowsInSection(sIndex: Int) -> Int
    func getEpisodeCellText(_ indexPath: IndexPath) -> (leftText: String, rightText: String)
    func getSectionEpisodesText() -> (leftText: String, rightText: Int)
    func getSectionShowText() -> String
    func fetchShowDetails() -> Void
    func fetchEpisodes() -> Void
   
}

class TvShowDetailViewModel: TvShowDetailViewModelProtocol {
   
    var showDetail: TvShowDetail?
    var episodes: [Episode] = []
    
    private var completion: (Error?) -> Void
    private var episodesCompletion: (Error?) -> Void
    private var showId: String
    
    init(showId: String, completion: @escaping  (Error?) -> Void, episodesCompletion: @escaping  (Error?) -> Void) {
        self.showId = showId
        self.completion = completion
        self.episodesCompletion = episodesCompletion
    }
    
    func getNumberOfRowsInSection(sIndex: Int) -> Int {
        switch sIndex {
        case 0:
            return 1
        default:
            return getNumberOfEpisodes()
        }
    }
       
    func getSectionHeight(index: Int) -> CGFloat {
        return 50
    }
       
    func getRowHeight(sIndex: Int) -> CGFloat {
        sIndex == 0 ? 90 : 50
    }
       
    func getNumberOfSections() -> Int {
        return 2
    }
    
    func getSectionEpisodesText() -> (leftText: String, rightText: Int) {
         return (leftText: "Episodes", rightText: getNumberOfEpisodes())
    }
    
    func getSectionShowText() -> String {
        return showDetail?.title ?? ""
    }
       
    public func fetchEpisodes() {
        APIService.shared.getShowEpisodes(showId: showId) {[weak self] epDetail, error in
            if error != nil {
                self?.episodes = epDetail.data
                self?.episodesCompletion(error)
                return
            }
            self?.episodes = epDetail.data
            self?.episodesCompletion(nil)
        }
    }
    public func fetchShowDetails() -> Void {
        APIService.shared.getShowDetails (showId: showId) {[weak self] showDetails, error in
            if error != nil {
                self?.showDetail = nil
                self?.completion(error)
                return
            }
            self?.showDetail = showDetails.data
            self?.completion(nil)
        }
    }
    
    public func getShowDetail() -> TvShowDetail? {
        return showDetail
    }
    
    func getNumberOfEpisodes() -> Int {
        return episodes.count
    }
    
    func getEpisode(at: Int) -> Episode {
        return episodes[at]
    }
    
    func getEpisodeCellText(_ indexPath: IndexPath) -> (leftText: String, rightText: String) {
        return (episodes[indexPath.item].season, episodes[indexPath.item].episodeNumber)
    }
}
