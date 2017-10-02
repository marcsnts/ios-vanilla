//
//  Extensions.swift
//  Vanilla
//
//  Created by Alex on 7/16/17.
//  Copyright © Flybits Inc. All rights reserved.
//

import UIKit

extension String {
    public func heightWithConstrainedWidth(_ width: CGFloat, for font: UIFont = UIFont.systemFont(ofSize: 17)) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        return boundingBox.height
    }

    public func toDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return dateFormatter.date(from: self)
    }
}

extension Date {
    public func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return dateFormatter.string(from: self)
    }
}
