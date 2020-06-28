//
//  TvShowCell.swift
//  tv.shows
//
//  Created by Alina Nicorescu on 23/06/2020.
//  Copyright © 2020 Alina Nicorescu. All rights reserved.
//
import UIKit
import AlamofireImage

class TvShowCell: UITableViewCell {

    static let REUSE_ID = "TvShowCell"

    @IBOutlet weak var showImage: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
  
    public func configure(_ tvShow: TvShow?) {
        label.text = tvShow?.title
        if let urlString = tvShow?.imageUrl, let imageUrl = URL(string: urlString)  {
            self.showImage?.af.setImage(withURL: imageUrl)
        }
    }
    
}
