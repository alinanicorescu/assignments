//
//  EpisodeCell.swift
//  tv.shows
//
//  Created by Alina Nicorescu on 24/06/2020.
//  Copyright © 2020 Alina Nicorescu. All rights reserved.
//

import UIKit

class EpisodeCell: UITableViewCell {
    
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!
    
    static let reuseIdentifier: String = "EpisodeCell"
    
    static var nib: UINib {
        return UINib(nibName: reuseIdentifier, bundle: nil)
    }
    
    public func configure(_ data: (leftText: String, rightText: String)?) {
        if var leftText = data?.leftText {
            if !( leftText.starts(with: "s") || leftText.starts(with: "S") ){
                leftText = "S" + leftText
            }
            leftLabel.text = leftText
        }
        if var rightText = data?.rightText {
            if !( rightText.starts(with: "e") || rightText.starts(with: "E") ){
                    rightText = "Ep" + rightText
            }
            rightLabel.text = rightText
        }
        leftLabel.sizeToFit()
        rightLabel.sizeToFit()
    }
}
