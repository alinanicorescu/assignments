//
//  String+Extension.swift
//  tv.shows
//
//  Created by Alina Nicorescu on 23/06/2020.
//  Copyright © 2020 Alina Nicorescu. All rights reserved.
//

import Foundation
extension String {
    public var isEmail: Bool {
        let dataDetector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)

        let firstMatch = dataDetector?.firstMatch(in: self, options: NSRegularExpression.MatchingOptions.reportCompletion, range: NSRange(location: 0, length: length))

        return (firstMatch?.range.location != NSNotFound && firstMatch?.url?.scheme == "mailto")
    }

    public var length: Int {
        return self.count
    }
}
