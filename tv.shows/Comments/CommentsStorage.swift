//
//  CommentsStorage.swift
//  tv.shows
//
//  Created by Alina Nicorescu on 27/06/2020.
//  Copyright © 2020 Alina Nicorescu. All rights reserved.
//

import Foundation

final class CommentsStorage {
    
    public static let shared = CommentsStorage()
    private var commentsArr: [CommentHolder] = []
    
    public func getComment(at : Int) -> CommentHolder {
        return commentsArr[at]
    }
    
    public func addComment(_ comment: CommentHolder) {
        commentsArr.append(comment)
    }
    
    public func getCommentsCount() -> Int {
        return commentsArr.count
    }
}
