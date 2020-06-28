//
//  APIService.swift
//  tv.shows
//
//  Created by Alina Nicorescu on 23/06/2020.
//  Copyright © 2020 Alina Nicorescu. All rights reserved.
//

import Foundation
import Alamofire

/**
  Service interface used for retrieving the exchange data
*/
protocol APIServiceProtocol: class {
    /**
       Perform user authenticaion
       - Parameters:
          - userEmail: the user email address
          - password: login password
    */
    func loginUser(userEmail: String, password: String, completion: @escaping (Error?) -> Void) -> Void
    
    
    /**
     Get all tv shows
    */
    func getTvShows(completion: @escaping (TvShows, Error?) -> Void) -> Void
    
    /**
    Get show episodes
     - Parameters:
        - showId: the show id
    */
    func getShowEpisodes(showId: String, completion: @escaping (EpisodeDetails, Error?) -> Void) -> Void
    
    /**
    Add a show episode
     - Parameters:
        - addEpisode: episode details to be added
    */
    func addShowEpisode(addEpisode: AddEpisodeDetails, completion:  @escaping (Error?) -> Void)
    /**
      Get episode details
        - Parameters:
           - episodeId: episode id
       */
    func getEpisodeDetails(episodeId: String, completion:  @escaping (EpisodeDetailsData?, Error?) -> Void)
    /**
    Add comment
     - Parameters:
        - comment: comment to be added
    */
    func addComment(comment: Comment, completion:  @escaping (Error?) -> Void)
    
}

class APIService: APIServiceProtocol {
    
    public static let shared = APIService()

    private final let loginUrlString = "https://api.infinum.academy/api/users/sessions"
    
    private final let tvShowsString = "https://api.infinum.academy/api/shows"
    
    private final let episodesString = "episodes"
    
    private final let episodesURLString = "https://api.infinum.academy/api/episodes"
    
    private final let commentsURLString = "https://api.infinum.academy/api/comments"
        
    final let baseUrlSring = "https://api.infinum.academy"

    
    private init() {
    }

    func loginUser(userEmail: String, password: String,
                   completion: @escaping (Error?) -> Void) {
        
        guard let url = URL(string: loginUrlString) else {
            return
        }
        let parameters = ["email": userEmail, "password": password]
        
        AF.request(url, method: .post, parameters: parameters, encoder: JSONParameterEncoder.default).validate().response {response in
            switch response.result {
            case .success :
                completion(nil)
            case let .failure(error) :
                completion(error)
            }
        }
    }
    
    func getTvShows(completion: @escaping (TvShows, Error?) -> Void) -> Void {
        guard let url = URL(string: tvShowsString) else {
            return
        }
        AF.request(url).validate().responseDecodable(of: TvShows.self) {response in
          switch response.result {
          case .success(let tvShows) :
              completion(tvShows, nil)
          case .failure(let error) :
              completion(TvShows(), error)
          }
        }
    }
    
    func getShowDetails(showId: String, completion: @escaping (TvShowDetails, Error?) -> Void) -> Void {
        guard var url = URL(string: tvShowsString) else {
            return
        }
        url.appendPathComponent(showId)
        AF.request(url).validate().responseDecodable(of: TvShowDetails.self) {response in
            switch response.result {
            case .success(let tvShowsDetails) :
                if let showUrl = tvShowsDetails.data?.imageUrl {
                    tvShowsDetails.data?.imageUrl = APIService.shared.baseUrlSring + showUrl
                }
                completion(tvShowsDetails, nil)
            case .failure(let error) :
                print(error)
                completion(TvShowDetails(), error)
            }
        }
    }
    
    func getShowEpisodes(showId: String, completion: @escaping (EpisodeDetails, Error?) -> Void) -> Void {
        guard var url = URL(string: tvShowsString) else {
            return
        }
        url = url.appendingPathComponent(showId).appendingPathComponent(episodesString)
        AF.request(url).validate().responseDecodable(of: EpisodeDetails.self) {response in
            switch response.result {
            case .success(let episodes) :
                completion(episodes, nil)
            case .failure(let error) :
                print(error)
                completion(EpisodeDetails(), error)
            }
        }
    }
    
    func addShowEpisode(addEpisode: AddEpisodeDetails, completion:  @escaping (Error?) -> Void) {
        AF.request(episodesURLString,
                   method: .post,
                   parameters: addEpisode,
                   encoder: JSONParameterEncoder.default).response { response in
        switch response.result {
            case .success( _) :
                completion(nil)
            case .failure(let error) :
                completion(error)
        }
        }
    }
        
    func addComment(comment: Comment, completion:  @escaping (Error?) -> Void) {
        AF.request(commentsURLString,
                   method: .post,
                   parameters: comment,
                   encoder: JSONParameterEncoder.default).response { response in
                    switch response.result {
                    case .success( _) :
                        completion(nil)
                    case .failure(let error) :
                        completion(error)
                    }
        }
    }
    
    
    func getEpisodeDetails(episodeId: String, completion: @escaping (EpisodeDetailsData?, Error?) -> Void) {
        guard var url = URL(string: episodesURLString) else {
            return
        }
        url = url.appendingPathComponent(episodeId)
        AF.request(url).validate().responseDecodable(of: EpisodeDetailsData.self) {response in
            //print(response.request?.url?.absoluteString)
            switch response.result {
                case .success(let epDetailss) :
                    //print(epDetailss.data?.imageUrl)
                    completion(epDetailss, nil)
                case .failure(let error) :
                    //print(error)
                   // print(response.data)
                    completion(nil, error)
                }
        }
    }
    
}
