//
//  CommentsCell.swift
//  tv.shows
//
//  Created by Alina Nicorescu on 26/06/2020.
//  Copyright © 2020 Alina Nicorescu. All rights reserved.
//

import UIKit

class CommentsCell: UITableViewCell {

    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var commentText: UILabel!
    @IBOutlet weak var commentTitle: UILabel!
    @IBOutlet weak var commentsImageView: UIImageView!
    
    static let reuseIdentifier: String = "CommentsCell"

    public func configure(_ commenth: CommentHolder) {
        self.commentText.numberOfLines = 0
        self.commentText.text = commenth.text
        self.commentText.sizeToFit()
        self.commentsImageView.image = commenth.getImage()
        self.commentTitle.text = commenth.name
        self.ageLabel.text = formatTime(timeInterval: Date().timeIntervalSince(commenth.timestamp))
    }
    
    private func formatTime(timeInterval: TimeInterval) -> String? {
      let formatter = DateComponentsFormatter()
      formatter.allowedUnits = [.day, .hour, .minute, .second, .nanosecond]
      formatter.unitsStyle = .abbreviated
      formatter.maximumUnitCount = 1
        return formatter.string(from: timeInterval)
    }
}
