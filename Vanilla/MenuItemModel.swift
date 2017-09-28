//
//  MenuItemModel.swift
//  Vanilla
//
//  Created by Marc Santos on 2017-09-28.
//  Copyright © 2017 Alex. All rights reserved.
//

import Foundation
import FlybitsKernelSDK

class MenuItemModel: ContentData {
    var name: LocalizedObject<String>
    var calories: Int
    var price: Double
    var ingredients: [String]?
    var image: URL?

    required init?(responseData: Any) throws {
        guard let representation = responseData as? [String: Any] else { throw ContentError.missingRepresentationDictionary }
        guard let localizations = representation[Constant.localizations] as? [String: [String: Any]] else { throw ContentError.missingLocalizationsDictionary }
        guard let calories = representation[Key.calories.rawValue] as? Int else { throw ContentError.missingProperty(Key.calories.rawValue) }
        guard let price = representation[Key.price.rawValue] as? Double else { throw ContentError.missingProperty(Key.price.rawValue) }

        self.name = LocalizedObject<String>(key: Key.name.rawValue, localizations: localizations)
        self.calories = calories
        self.price = price
        if let ingredients = representation["ingredients"] as? [String]? {
            self.ingredients = ingredients
        }
        if let imageURL = representation["image"] as? String {
            self.image = URL(string: imageURL)
        }

        try! super.init(responseData: responseData)
    }
}

// MARK: - Content data property keys

extension MenuItemModel {
    enum Key: String {
        case name
        case calories
        case price
        case ingredients
        case image
    }
}
