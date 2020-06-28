//
//  TvShowsViewModel.swift
//  tv.shows
//
//  Created by Alina Nicorescu on 23/06/2020.
//  Copyright © 2020 Alina Nicorescu. All rights reserved.
//

import Foundation

protocol TvShowsViewModelProtocol {
    func loadTvShows() -> Void
    func getNumberOfTvShows() -> Int
    func getTvShow(at: Int) -> TvShow
}

class TvShowsViewModel: TvShowsViewModelProtocol {

    private var tvShows: [TvShow] = []
    
    private var completion: (Error?) -> Void
    
    init(completion: @escaping  (Error?) -> Void) {
        self.completion = completion
    }
    
    func loadTvShows() -> Void {
        APIService.shared.getTvShows {[weak self] tvShows, error in
            if let error = error {
                self?.completion(error)
                return
            }
            self?.tvShows = tvShows.data
            self?.tvShows.forEach {tvShow in
                tvShow.imageUrl = APIService.shared.baseUrlSring + tvShow.imageUrl
            }
            self?.completion(nil)
        }
    }
    
    func getNumberOfTvShows() -> Int {
        return tvShows.count
    }
    
    func getTvShow(at: Int) -> TvShow {
        return tvShows[at]
    }
}
