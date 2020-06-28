//
//  CommentsViewModel.swift
//  tv.shows
//
//  Created by Alina Nicorescu on 27/06/2020.
//  Copyright © 2020 Alina Nicorescu. All rights reserved.
//

import Foundation
import UIKit

class CommentHolder {
    
     let text: String
     let timestamp: Date
    let name: String = "Andrei"
    
    init(text: String) {
        self.text = text
        self.timestamp = Date()
    }
    
    public func getImage() -> UIImage? {
        return UIImage(named: "img-placeholder-user2") ?? nil
    }
}

protocol  CommentsViewModelProtocol {
    func addComment(_ text: String)
    func getComment(at: Int) -> CommentHolder
    func getNumberOfComments() -> Int
}

class CommentsViewModel: CommentsViewModelProtocol {
    
    var episodeId: String
    private var completion: (Error?) -> Void
    
    init(episodeId: String, completion:  @escaping (Error?) -> Void) {
        self.episodeId = episodeId
        self.completion = completion
    }
    
    public func addComment(_ text: String) {
        APIService.shared.addComment(comment: Comment(episodeId: episodeId, text: text)) {[weak self] error in
            if error != nil {
                self?.completion(error)
            } else {
                CommentsStorage.shared.addComment(CommentHolder(text: text))
                self?.completion(nil)
            }
        }
    }
    
    public func getComment(at: Int) -> CommentHolder {
        return CommentsStorage.shared.getComment(at: at)
    }
    
    public func getNumberOfComments() -> Int {
        return CommentsStorage.shared.getCommentsCount()
    }
}
