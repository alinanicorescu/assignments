//
//  TextCell.swift
//  tv.shows
//
//  Created by Alina Nicorescu on 23/06/2020.
//  Copyright © 2020 Alina Nicorescu. All rights reserved.
//

import UIKit

class TextCell: UITableViewCell {
   
    @IBOutlet weak var textView: UILabel!
    
    static let reuseIdentifier: String = "TextCell"
    
    static var nib: UINib {
        return UINib(nibName: reuseIdentifier, bundle: nil)
    }
    public func configure(text: String) {
        self.textView.numberOfLines = 0
        self.textView.text = text
        self.textView.sizeToFit()
    }
    
}
