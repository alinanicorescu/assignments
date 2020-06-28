//
//  ShowTitleSection.swift
//  tv.shows
//
//  Created by Alina Nicorescu on 23/06/2020.
//  Copyright © 2020 Alina Nicorescu. All rights reserved.
//

import Foundation
import UIKit

final class ShowTitleSection: UITableViewHeaderFooterView {
    
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!
    
    static let reuseIdentifier: String = "ShowTitleSection"
    
    static var nib: UINib {
        return UINib(nibName: reuseIdentifier, bundle: nil)
    }
    
    public func configure(text: String?) {
        guard let text = text else {
            return
        }
        configureLeftLabel(text, fontSize: 28)
        rightLabel.text = nil
    }

    public func configure (_ data: (leftText: String, rightText: Int)?) {
        self.backgroundView = UIView(frame: self.bounds)
        self.backgroundView?.backgroundColor = .white
        guard let data = data else {
            return
        }
        leftLabel.text = data.leftText
        if data.rightText <= 0 {
            rightLabel.text = nil
        } else {
            configureRightLabel(String(data.rightText))
        }
        configureLeftLabel(data.leftText, fontSize: 20)
        leftLabel.sizeToFit()
        rightLabel.sizeToFit()
    }
    
    private func configureLeftLabel(_ text: String, fontSize: CGFloat) {
        leftLabel.attributedText = NSAttributedString(string: text, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: fontSize)])
    }
       
    private func configureRightLabel(_ text: String) {
        rightLabel.attributedText = NSAttributedString(string: String(text), attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20),
            NSAttributedString.Key.foregroundColor : UIColor.lightGray])
    }
}
