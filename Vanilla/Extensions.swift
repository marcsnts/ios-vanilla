//
//  Extensions.swift
//  Vanilla
//
//  Created by Flybits Inc on 7/16/17.
//  Copyright © Flybits Inc. All rights reserved.
//

import UIKit
import FlybitsContextSDK
import FlybitsPushSDK

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

extension UserDefaults {
    enum Key: String {
        case environment
        case projectID
        case autoRegisterContextPlugins
        case flybitsManager
    }

    func getEnvironment() -> Int? {
        return value(forKey: Key.environment.rawValue) as? Int
    }

    func getProjectID() -> String? {
        return value(forKey: Key.projectID.rawValue) as? String
    }

    func getAutoRegister() -> Bool {
        return (value(forKey: Key.autoRegisterContextPlugins.rawValue) as? Bool) ?? false
    }

    func getFlybitsManager() -> FlybitsManager? {
        guard let managerData = UserDefaults.standard.object(forKey: Key.flybitsManager.rawValue) as? Data else { return nil }
        return NSKeyedUnarchiver.unarchiveObject(with: managerData) as? FlybitsManager
    }
}

extension RuleScope {
    var string: String {
        switch self {
        case .Project: return "Project"
        case .User: return "User"
        case .All: return "All"
        }
    }
}

extension RuleResult {
    var string: String {
        switch self {
        case .false: return "is False"
        case .true: return "is True"
        case .trueOrFalse: return "is either True or False"
        }
    }

    static let numberOfPossibleResults = 3
}
